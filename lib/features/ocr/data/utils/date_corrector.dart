import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:moneyflow/features/ocr/domain/entities/receipt_data.dart';

/// OCR 날짜 인식 오류를 휴리스틱 기반으로 자동 보정하는 유틸리티
///
/// 주요 기능:
/// 1. 클러스터 분석: 같은 이미지에서 추출된 날짜들의 월 분포 분석
/// 2. 이상치 탐지: 다수 월과 다른 소수 월을 이상치로 판단
/// 3. 자동 보정: 이상치 날짜를 다수 월로 보정 (높은 신뢰도일 때만)
///
/// 예시:
/// - 입력: [11/20, 11/24, 01/27, 11/28, 12/03] (01/27은 OCR 오류)
/// - 분석: 11월(3개), 12월(1개), 1월(1개) → 1월은 이상치
/// - 보정: 01/27 → 11/27로 자동 수정
class DateCorrector {
  final _logger = Logger(level: kDebugMode ? Level.debug : Level.nothing);

  /// 보정 결과를 담는 클래스
  static const double _highConfidenceThreshold = 0.8;
  static const double _mediumConfidenceThreshold = 0.35; // 낮춤: 더 적극적 보정

  /// 추출된 ReceiptData 리스트의 날짜를 분석하고 보정
  ///
  /// [receipts] OCR로 추출된 영수증 데이터 리스트
  /// [referenceDate] 기준 날짜 (기본값: 현재 시간)
  ///
  /// Returns: 보정된 ReceiptData 리스트
  List<ReceiptData> correctDates(
    List<ReceiptData> receipts, {
    DateTime? referenceDate,
  }) {
    if (receipts.isEmpty) return receipts;

    final ref = referenceDate ?? DateTime.now();
    _logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    _logger.d(' 날짜 보정 시작 (기준일: ${_formatDate(ref)})');

    // 1. 유효한 날짜가 있는 항목만 분석
    final datedReceipts = receipts.where((r) => r.date != null).toList();
    if (datedReceipts.length < 2) {
      _logger.d('   ⏭️ 날짜 있는 항목이 2개 미만 → 보정 스킵');
      return receipts;
    }

    // 2. 월별 클러스터 분석
    final monthClusters = _analyzeMonthClusters(datedReceipts);
    _logger.d('    월별 분포: $monthClusters');

    // 3. 다수 월(dominant month) 결정 (OCR 오류 패턴 고려)
    final dominantMonth = _findDominantMonthWithOcrPattern(monthClusters);
    if (dominantMonth == null) {
      _logger.d('    다수 월을 결정할 수 없음 → 보정 스킵');
      return receipts;
    }
    _logger.d('    다수 월: $dominantMonth월');

    // 4. 이상치 탐지 및 보정
    final correctedReceipts = <ReceiptData>[];
    for (final receipt in receipts) {
      final corrected = _correctIfNeeded(
        receipt,
        dominantMonth,
        monthClusters,
        ref,
      );
      correctedReceipts.add(corrected);
    }

    _logger.d(' 날짜 보정 완료');
    _logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return correctedReceipts;
  }

  /// 월별 클러스터 분석
  /// Returns: {월: 개수} 맵
  Map<int, int> _analyzeMonthClusters(List<ReceiptData> receipts) {
    final clusters = <int, int>{};
    for (final receipt in receipts) {
      if (receipt.date != null) {
        final month = receipt.date!.month;
        clusters[month] = (clusters[month] ?? 0) + 1;
      }
    }
    return clusters;
  }

  /// 다수 월 결정 (OCR 오류 패턴을 고려하여 가상 클러스터 병합)
  /// 예: 1월(2개) + 11월(3개) → 11월 그룹(5개)
  int? _findDominantMonthWithOcrPattern(Map<int, int> clusters) {
    if (clusters.isEmpty) return null;

    // 1. 가상 클러스터 생성 (OCR 오류 패턴 병합)
    // 10↔0, 11↔1, 12↔2 를 같은 그룹으로 취급
    final virtualClusters = <int, int>{};
    
    for (final entry in clusters.entries) {
      final month = entry.key;
      final count = entry.value;
      
      // 타겟 월 결정: 10,11,12를 기준으로 통합
      int targetMonth = month;
      if (month >= 0 && month <= 2) {
        // 0,1,2 → 10,11,12로 매핑
        targetMonth = month + 10;
      }
      
      virtualClusters[targetMonth] = (virtualClusters[targetMonth] ?? 0) + count;
    }
    
    _logger.d('    가상 클러스터 (OCR 오류 패턴 병합): $virtualClusters');

    final totalCount = virtualClusters.values.reduce((a, b) => a + b);
    final sorted = virtualClusters.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topMonth = sorted.first;

    // 가장 많은 월이 전체의 35% 이상이면 다수 월로 인정
    if (topMonth.value / totalCount >= 0.35) {
      return topMonth.key;
    }

    return null;
  }

  /// 필요시 날짜 보정
  ReceiptData _correctIfNeeded(
    ReceiptData receipt,
    int dominantMonth,
    Map<int, int> monthClusters,
    DateTime referenceDate,
  ) {
    if (receipt.date == null) return receipt;

    final originalDate = receipt.date!;
    final originalMonth = originalDate.month;

    // 이미 다수 월이면 보정 불필요
    if (originalMonth == dominantMonth) return receipt;

    // 보정 신뢰도 계산
    final confidence = _calculateCorrectionConfidence(
      originalMonth,
      dominantMonth,
      monthClusters,
      originalDate,
      referenceDate,
    );

    if (confidence < _mediumConfidenceThreshold) {
      _logger.d('   ⏭️ ${_formatDate(originalDate)}: 신뢰도 낮음 (${(confidence * 100).toStringAsFixed(0)}%) → 보정 안함');
      return receipt;
    }

    // 보정된 날짜 생성
    final correctedDate = _createCorrectedDate(
      originalDate,
      dominantMonth,
      referenceDate,
    );

    if (correctedDate == null) {
      _logger.d('    ${_formatDate(originalDate)}: 보정 날짜 생성 실패');
      return receipt;
    }

    // 보정된 날짜가 유효한지 검증
    if (!_isValidCorrectedDate(correctedDate, referenceDate)) {
      _logger.d('    ${_formatDate(originalDate)}: 보정 결과가 유효하지 않음 → ${_formatDate(correctedDate)}');
      return receipt;
    }

    final confidenceLevel = confidence >= _highConfidenceThreshold ? '높음' : '중간';
    _logger.i('    날짜 보정: ${_formatDate(originalDate)} → ${_formatDate(correctedDate)} (신뢰도: $confidenceLevel)');

    return receipt.copyWith(date: correctedDate);
  }

  /// 보정 신뢰도 계산 (0.0 ~ 1.0)
  double _calculateCorrectionConfidence(
    int originalMonth,
    int dominantMonth,
    Map<int, int> monthClusters,
    DateTime originalDate,
    DateTime referenceDate,
  ) {
    double confidence = 0.0;

    final totalCount = monthClusters.values.reduce((a, b) => a + b);
    final dominantCount = monthClusters[dominantMonth] ?? 0;
    final originalCount = monthClusters[originalMonth] ?? 0;

    // 1. 클러스터 비율 기반 신뢰도 (최대 0.4)
    // 다수 월의 비율이 높을수록 신뢰도 증가
    final dominantRatio = dominantCount / totalCount;
    confidence += dominantRatio * 0.4;

    // 2. 원본 월이 소수인 경우 신뢰도 증가 (최대 0.3)
    // 원본 월이 1개뿐이면 OCR 오류일 가능성 높음
    if (originalCount == 1) {
      confidence += 0.3;
    } else if (originalCount == 2) {
      confidence += 0.15;
    }

    // 3. 월 차이가 OCR 오류 패턴과 일치하는지 (최대 0.45)
    // 예: 11 → 1 (앞자리 누락), 12 → 2 (앞자리 누락)
    if (_isTypicalOcrError(originalMonth, dominantMonth)) {
      confidence += 0.45; // 더 높은 가중치
    }

    // 4. 보정 후 날짜가 기준일과 가까운지 (보너스 최대 0.1)
    final daysDiff = (originalDate.difference(referenceDate).inDays).abs();
    if (daysDiff <= 60) {
      confidence += 0.1;
    }

    // 5. 미래 날짜 패널티 (과거 영수증이 미래로 되어있으면 오류)
    if (originalDate.isAfter(referenceDate)) {
      confidence += 0.1; // 미래 날짜는 보정해야 할 가능성 높음
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// 전형적인 OCR 오류 패턴인지 확인
  /// 예: 11 → 1 (첫 번째 '1'이 누락), 12 → 2, 10 → 0
  bool _isTypicalOcrError(int detected, int expected) {
    // 10, 11, 12월이 0, 1, 2월로 인식되는 패턴
    if (expected >= 10 && expected <= 12) {
      final lastDigit = expected % 10;
      if (detected == lastDigit || detected == lastDigit + 1) {
        return true;
      }
    }

    // 반대 케이스: 1, 2월이 11, 12월로 인식
    if (detected >= 10 && detected <= 12) {
      final lastDigit = detected % 10;
      if (expected == lastDigit || expected == lastDigit - 1) {
        return true;
      }
    }

    return false;
  }

  /// 보정된 날짜 생성
  DateTime? _createCorrectedDate(
    DateTime original,
    int targetMonth,
    DateTime referenceDate,
  ) {
    try {
      // 연도 결정: 보정 후 날짜가 기준일에 가까워지도록
      int targetYear = original.year;

      // 월이 크게 변경되면 연도 조정 필요할 수 있음
      // 예: 기준일이 12월인데 1월로 인식됐다면, 원래는 11월이었을 수 있음
      if (targetMonth > 6 && original.month <= 2) {
        // 1-2월로 인식됐지만 실제로는 10-12월일 가능성
        // 연도는 그대로 유지
      } else if (targetMonth <= 2 && original.month > 10) {
        // 10-12월로 인식됐지만 실제로는 1-2월일 가능성
        targetYear = original.year + 1;
      }

      final corrected = DateTime(targetYear, targetMonth, original.day);

      // 해당 월에 그 일자가 존재하는지 확인
      if (corrected.month != targetMonth) {
        // 예: 2월 30일 같은 경우 → 해당 월의 마지막 날로 조정
        final lastDay = DateTime(targetYear, targetMonth + 1, 0).day;
        return DateTime(targetYear, targetMonth, lastDay);
      }

      return corrected;
    } catch (e) {
      _logger.w('날짜 생성 오류: $e');
      return null;
    }
  }

  /// 보정된 날짜가 유효한지 검증
  bool _isValidCorrectedDate(DateTime corrected, DateTime referenceDate) {
    // 1. 너무 오래된 날짜 거부 (1년 이상 전)
    final oneYearAgo = referenceDate.subtract(const Duration(days: 365));
    if (corrected.isBefore(oneYearAgo)) {
      return false;
    }

    // 2. 너무 미래 날짜 거부 (1개월 이상 후)
    final oneMonthLater = referenceDate.add(const Duration(days: 30));
    if (corrected.isAfter(oneMonthLater)) {
      return false;
    }

    return true;
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// 날짜 보정 결과를 담는 레코드
class DateCorrectionResult {
  final DateTime original;
  final DateTime corrected;
  final double confidence;
  final String reason;

  const DateCorrectionResult({
    required this.original,
    required this.corrected,
    required this.confidence,
    required this.reason,
  });

  bool get wasModified => original != corrected;

  @override
  String toString() {
    if (!wasModified) return 'No correction needed';
    return '$original → $corrected (${(confidence * 100).toStringAsFixed(0)}% confidence: $reason)';
  }
}
