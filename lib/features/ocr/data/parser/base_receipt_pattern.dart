import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:moamoa/features/ocr/domain/entities/receipt_data.dart';
import 'package:moamoa/features/ocr/domain/patterns/receipt_pattern.dart';

/// 카드사별 OCR 패턴의 기본 추상 클래스
///
/// 공통 파싱 로직을 제공하고, 카드사별로 특화된 부분만 오버라이드할 수 있도록 설계
///
/// **확장 방법:**
/// ```dart
/// class ShinhanPattern extends BaseReceiptPattern {
///   @override
///   String get name => '신한카드';
///
///   @override
///   String get cardIssuerId => 'shinhan';
///
///   @override
///   List<String> get identifierKeywords => ['신한카드', 'SOL페이', '신한'];
/// }
/// ```
abstract class BaseReceiptPattern implements ReceiptPattern {
  final Logger _logger = Logger(level: kDebugMode ? Level.debug : Level.off);

  /// 카드사 ID (예: 'shinhan', 'samsung')
  String get cardIssuerId;

  /// 이 패턴을 식별하는 키워드들 (예: ['신한카드', 'SOL페이'])
  List<String> get identifierKeywords;

  /// 카드사별 추가 노이즈 키워드 (기본 노이즈에 추가됨)
  List<String> get additionalNoiseKeywords => [];

  /// 카드사별 날짜 형식 힌트 (향후 확장용)
  /// 예: 'YY.MM.DD', 'MM/DD', 'YYYY-MM-DD'
  String get dateFormatHint => 'auto';

  // ═══════════════════════════════════════════════════════════════════════════
  // 공통 정규식 패턴
  // ═══════════════════════════════════════════════════════════════════════════

  /// 금액 Regex
  static final RegExp moneyRegex = RegExp(
    r'([+\-]?\s?[\d]{1,3}(,[\d]{3})+)(\s?원)?|([+\-]?\s?[\d]{3,}\s?원?)',
  );

  /// 날짜 Regex 1: 연도 포함 (예: 5.11.24, 25.11.20, 2025-11-20)
  static final RegExp dateFullRegex = RegExp(
    r'(\d{1,4})[\s\.\-/년]+(\d{1,2})[\s\.\-/월]+(\d{1,2})[일]?',
  );

  /// 날짜 Regex 2: 월/일만 있음 (예: 11 24, 11/24)
  static final RegExp dateShortRegex = RegExp(
    r'(\d{1,2})[\s\.\-/월]+(\d{1,2})[일]?',
  );

  /// 기본 노이즈 패턴
  static final RegExp baseNoiseRegex = RegExp(
    r'(\d{1,2}:\d{2})|' // 시간 (14:30)
    r'(\d+(\.\d+)?%)|' // 퍼센트
    r'(일시불|할부|적립|이용|내역|' // 기존 노이즈
    r'예정|시불|익월|출금|청구|' // 카드사 용어
    r'결제완료|승인|취소|' // 상태
    r'적립예정|분할결제|신청하기|' // 추가 카드사 UI 텍스트
    r'ZERO\s*ED2?|ED2|할인형|기본|할인|' // 카드 상품명 패턴
    r'\d{1,2}\s?\([^)]*\)|' // "23 ()" 같은 패턴
    r'\([월화수목금토일]\)|' // 요일 패턴
    r'\|?Pay|카카오페이|네이버페이|삼성페이|애플페이)', // 결제수단
  );

  /// 할인 정보 패턴
  static final RegExp discountInfoRegex = RegExp(
    r'\d+(\.\d+)?%\s*(할인|_[^\s]+)?\s*-?\d+원?',
  );

  /// 기본 드롭 키워드
  static const List<String> baseDropKeywords = [
    '합계', '총액', '결제금액', '청구금액', '출금예정',
    '이번달', '명세서', '결제예정', '잔액', '포인트',
    '최신순', '고액순',
  ];

  /// 요약 라인 감지 정규식
  static final RegExp summaryLineRegex = RegExp(
    r'총\s*\d+\s*건|^\d+\s*건\s+[\d,]+\s*원?$',
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ReceiptPattern 인터페이스 구현
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  bool canParse(RecognizedText text) {
    final fullText = text.blocks.map((b) => b.text).join(' ');
    return identifierKeywords.any(
      (keyword) => fullText.contains(keyword),
    );
  }

  @override
  List<ReceiptData> parse(RecognizedText text) {
    List<ReceiptData> results = [];
    List<TextLine> allLines = [];

    for (var block in text.blocks) {
      allLines.addAll(block.lines);
    }

    _logAllLines(allLines);

    var moneyLines = _extractMoneyLines(allLines);
    final dateHeaderLines = _extractDateHeaderLines(allLines);

    _logger.d('[$name] 발견된 금액 라인: ${moneyLines.length}개');
    _logger.d('[$name] 발견된 날짜 헤더: ${dateHeaderLines.length}개');

    // 날짜 컨텍스트 추적
    DateTime? lastKnownDate;
    int linesSinceLastDate = 0;
    const int maxDateContextDistance = 10;

    for (var moneyLine in moneyLines) {
      if (_hasDropKeyword(moneyLine.text)) continue;

      int amount = _parseAmountInt(moneyLine.text);
      if (amount == 0) continue;

      final anchor = moneyLine.boundingBox;
      final double h = anchor.height;

      // Smart Zone 계산 (카드사별로 오버라이드 가능)
      final smartZone = calculateSmartZone(anchor, h);

      List<TextLine> rawTexts = [];
      bool hasSummaryLineNearby = false;

      for (var line in allLines) {
        if (line == moneyLine) continue;

        if (_isOverlapping(line.boundingBox, smartZone)) {
          if (summaryLineRegex.hasMatch(line.text)) {
            hasSummaryLineNearby = true;
            break;
          }
          if (!_hasDropKeyword(line.text)) {
            rawTexts.add(line);
          }
        }
      }

      if (hasSummaryLineNearby) continue;

      rawTexts.sort((a, b) {
        double dy = (a.boundingBox.top - b.boundingBox.top).abs();
        if (dy < h * 0.5) {
          return a.boundingBox.left.compareTo(b.boundingBox.left);
        }
        return a.boundingBox.top.compareTo(b.boundingBox.top);
      });

      String fullText = rawTexts.map((e) => e.text).join(' ');
      String fullTextWithMoneyLine = '$fullText ${moneyLine.text}';

      if (_hasDropKeyword(fullText)) continue;

      // 날짜 추출
      final dateResult = extractBestDate(fullTextWithMoneyLine);
      String? dateStr = dateResult.dateStr;
      bool isShortDate = dateResult.isShort;

      DateTime? parsedDate = parseDateObj(dateStr, isShortDate);

      // "오늘" 키워드 처리
      final todayRegex = RegExp(r'^오늘[\s●•\-\.]');
      if (parsedDate == null && todayRegex.hasMatch(fullText)) {
        final now = DateTime.now();
        parsedDate = DateTime(now.year, now.month, now.day);
      }

      // 날짜 컨텍스트 처리
      if (parsedDate != null) {
        lastKnownDate = parsedDate;
        linesSinceLastDate = 0;
      } else {
        linesSinceLastDate++;
        parsedDate = _findDateFromContext(
          moneyLine,
          dateHeaderLines,
          allLines,
          lastKnownDate,
          linesSinceLastDate,
          maxDateContextDistance,
        );
        if (parsedDate != null) {
          lastKnownDate = parsedDate;
        }
      }

      // 상호명 추출
      String merchantName = fullText;
      if (dateStr != null) {
        merchantName = merchantName.replaceAll(dateStr, '');
      }
      merchantName = cleanStoreName(merchantName);

      if (merchantName.isEmpty) merchantName = "미확인 가맹점";

      // 쓰레기 데이터 필터링
      if (merchantName == "미확인 가맹점" && parsedDate == null) {
        _logger.w('[$name] 쓰레기 데이터 삭제: $amount원');
        continue;
      }

      bool isCancel = moneyLine.text.contains('-') ||
          moneyLine.text.contains('취소') ||
          merchantName.contains('취소');

      results.add(ReceiptData(
        rawText: fullText,
        amount: isCancel ? amount.abs() : amount,
        date: parsedDate,
        merchant: merchantName,
        status: isCancel ? ReceiptStatus.cancelled : ReceiptStatus.approved,
        cardIssuer: cardIssuerId,
      ));
    }

    return results;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 카드사별 오버라이드 가능한 메서드
  // ═══════════════════════════════════════════════════════════════════════════

  /// Smart Zone 계산 (카드사별로 다른 레이아웃에 맞게 조정 가능)
  ///
  /// [anchor] 금액 라인의 bounding box
  /// [lineHeight] 라인 높이
  Rect calculateSmartZone(Rect anchor, double lineHeight) {
    // 기본: 위로 2.5줄, 아래로 1.5줄
    return Rect.fromLTRB(
      0,
      anchor.top - (lineHeight * 2.5),
      anchor.left + 20,
      anchor.bottom + (lineHeight * 1.5),
    );
  }

  /// 상호명 정제 (카드사별로 추가 정제 로직 적용 가능)
  String cleanStoreName(String text) {
    String clean = text;

    // 1. 할인 정보 패턴 제거
    clean = clean.replaceAll(discountInfoRegex, '');

    // 2. 금액 패턴 제거
    clean = clean.replaceAll(RegExp(r'-?\d+원'), '');

    // 3. 기본 노이즈 패턴 제거
    clean = clean.replaceAll(baseNoiseRegex, '');

    // 4. 카드사별 추가 노이즈 제거
    for (final noise in additionalNoiseKeywords) {
      clean = clean.replaceAll(noise, '');
    }

    // 5. 카드사명 제거
    for (final keyword in identifierKeywords) {
      clean = clean.replaceAll(keyword, '');
    }

    // 6. 특수문자 제거 (괄호는 유지)
    clean = clean.replaceAll(RegExp(r'[^\w가-힣\(\)\s]'), '');

    // 7. 1자리 영숫자 단어 제거
    List<String> words = clean.split(' ');
    words.removeWhere(
      (w) => w.length <= 1 && RegExp(r'[A-Za-z0-9]').hasMatch(w),
    );

    // 8. 연속 공백 정리
    return words.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// 날짜 추출 (카드사별로 특화된 날짜 형식 지원 가능)
  DateResult extractBestDate(String fullText) {
    final candidates = <DateCandidate>[];
    final now = DateTime.now();

    // 1. Full 날짜 패턴 (YY.MM.DD)
    for (final match in dateFullRegex.allMatches(fullText)) {
      final dateStr = match.group(0)!;
      final yearStr = match.group(1)!;
      final monthStr = match.group(2)!;
      final dayStr = match.group(3)!;

      int year = int.tryParse(yearStr) ?? 0;
      int month = int.tryParse(monthStr) ?? 0;
      int day = int.tryParse(dayStr) ?? 0;

      // OCR 연도 오류 복구
      if (year >= 1 && year <= 9) {
        year = 2020 + year;
      } else if (year >= 10 && year <= 99) {
        year = 2000 + year;
      }

      if (!_isValidDate(year, month, day)) continue;

      final parsedDate = DateTime(year, month, day);
      final score = _scoreDateCandidate(
        parsedDate: parsedDate,
        matchPosition: match.start,
        fullText: fullText,
        now: now,
        originalYearStr: yearStr,
      );

      candidates.add(DateCandidate(
        dateStr: dateStr,
        parsedDate: parsedDate,
        isShort: false,
        score: score,
        matchPosition: match.start,
      ));
    }

    // 2. Short 날짜 패턴 (MM.DD) - Full이 없을 때만
    if (candidates.isEmpty) {
      for (final match in dateShortRegex.allMatches(fullText)) {
        final dateStr = match.group(0)!;
        final monthStr = match.group(1)!;
        final dayStr = match.group(2)!;

        int month = int.tryParse(monthStr) ?? 0;
        int day = int.tryParse(dayStr) ?? 0;

        // 월-일 순서 오류 복구
        if (month > 12 && day <= 12) {
          final temp = month;
          month = day;
          day = temp;
        }

        if (!_isValidDate(now.year, month, day)) continue;

        final parsedDate = DateTime(now.year, month, day);
        final score = _scoreDateCandidate(
          parsedDate: parsedDate,
          matchPosition: match.start,
          fullText: fullText,
          now: now,
          originalYearStr: null,
        ) - 0.1;

        candidates.add(DateCandidate(
          dateStr: dateStr,
          parsedDate: parsedDate,
          isShort: true,
          score: score,
          matchPosition: match.start,
        ));
      }
    }

    if (candidates.isEmpty) {
      return DateResult(dateStr: null, isShort: false, parsedDate: null);
    }

    candidates.sort((a, b) => b.score.compareTo(a.score));
    final best = candidates.first;

    return DateResult(
      dateStr: best.dateStr,
      isShort: best.isShort,
      parsedDate: best.parsedDate,
    );
  }

  /// 날짜 문자열을 DateTime으로 파싱
  DateTime? parseDateObj(String? text, bool isShort) {
    if (text == null) return null;
    try {
      int year, month, day;
      DateTime now = DateTime.now();

      if (isShort) {
        final match = dateShortRegex.firstMatch(text);
        if (match == null) return null;
        year = now.year;
        month = int.parse(match.group(1)!);
        day = int.parse(match.group(2)!);
      } else {
        final match = dateFullRegex.firstMatch(text);
        if (match == null) return null;
        String yStr = match.group(1)!;
        month = int.parse(match.group(2)!);
        day = int.parse(match.group(3)!);

        int yearNum = int.parse(yStr);
        if (yearNum >= 1 && yearNum <= 9) {
          year = 2020 + yearNum;
        } else if (yearNum >= 10 && yearNum <= 99) {
          year = 2000 + yearNum;
        } else {
          year = yearNum;
        }
      }

      if (month < 1 || month > 12 || day < 1 || day > 31) return null;
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Private 헬퍼 메서드
  // ═══════════════════════════════════════════════════════════════════════════

  void _logAllLines(List<TextLine> allLines) {
    _logger.d('━━━ [$name] OCR 인식된 전체 라인 (${allLines.length}개) ━━━');
    for (var i = 0; i < allLines.length; i++) {
      final line = allLines[i];
      final hasDate = dateFullRegex.hasMatch(line.text);
      final hasMoney = moneyRegex.hasMatch(line.text);
      String markers = '';
      if (hasDate) markers += '📅';
      if (hasMoney) markers += '💰';
      _logger.d('  [$i] $markers "${line.text}"');
    }
  }

  List<TextLine> _extractMoneyLines(List<TextLine> allLines) {
    var moneyLines = allLines.where((line) {
      return moneyRegex.hasMatch(line.text) &&
          !dateFullRegex.hasMatch(line.text) &&
          !dateShortRegex.hasMatch(line.text);
    }).toList();

    moneyLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
    return moneyLines;
  }

  List<TextLine> _extractDateHeaderLines(List<TextLine> allLines) {
    final dateHeaderLines = allLines.where((line) {
      final hasFullDate = dateFullRegex.hasMatch(line.text);
      final hasMoney = moneyRegex.hasMatch(line.text);
      return hasFullDate && !hasMoney;
    }).toList();

    dateHeaderLines.sort(
      (a, b) => a.boundingBox.top.compareTo(b.boundingBox.top),
    );
    return dateHeaderLines;
  }

  bool _isOverlapping(Rect target, Rect box) {
    if (!target.overlaps(box)) return false;
    final intersection = target.intersect(box);
    return (intersection.width * intersection.height) > 0;
  }

  bool _hasDropKeyword(String text) {
    String clean = text.replaceAll(RegExp(r'\s'), '');

    if (summaryLineRegex.hasMatch(text)) {
      return true;
    }

    return baseDropKeywords.any((k) => clean.contains(k));
  }

  int _parseAmountInt(String text) {
    try {
      String clean = text.replaceAll(RegExp(r'[^0-9\-]'), '');
      return int.parse(clean);
    } catch (e) {
      return 0;
    }
  }

  DateTime? _findDateFromContext(
    TextLine moneyLine,
    List<TextLine> dateHeaderLines,
    List<TextLine> allLines,
    DateTime? lastKnownDate,
    int linesSinceLastDate,
    int maxDateContextDistance,
  ) {
    // 1. 가장 가까운 날짜 헤더 찾기
    TextLine? closestDateHeader;
    double minDistance = double.infinity;

    for (var headerLine in dateHeaderLines) {
      if (headerLine.boundingBox.bottom < moneyLine.boundingBox.top) {
        final distance =
            moneyLine.boundingBox.top - headerLine.boundingBox.bottom;
        if (distance < minDistance) {
          minDistance = distance;
          closestDateHeader = headerLine;
        }
      }
    }

    if (closestDateHeader != null) {
      final headerDateResult = extractBestDate(closestDateHeader.text);
      final headerDate =
          parseDateObj(headerDateResult.dateStr, headerDateResult.isShort);
      if (headerDate != null) {
        return headerDate;
      }
    }

    // 2. 모든 라인에서 날짜 검색
    TextLine? closestDateLine;
    double minDist = double.infinity;
    final anchor = moneyLine.boundingBox;
    final h = anchor.height;

    for (var line in allLines) {
      if (dateFullRegex.hasMatch(line.text) && line != moneyLine) {
        final searchZone = Rect.fromLTRB(
          0,
          anchor.top - (h * 3),
          double.infinity,
          anchor.bottom + (h * 2),
        );

        if (_isOverlapping(line.boundingBox, searchZone)) {
          double dist;
          if (line.boundingBox.bottom <= anchor.top) {
            dist = anchor.top - line.boundingBox.bottom;
          } else {
            dist = line.boundingBox.top - anchor.bottom;
          }

          if (dist < minDist) {
            minDist = dist;
            closestDateLine = line;
          }
        }
      }
    }

    if (closestDateLine != null) {
      final lineDate = extractBestDate(closestDateLine.text);
      final parsed = parseDateObj(lineDate.dateStr, lineDate.isShort);
      if (parsed != null) {
        return parsed;
      }
    }

    // 3. 마지막 알려진 날짜 사용
    if (lastKnownDate != null && linesSinceLastDate <= maxDateContextDistance) {
      return lastKnownDate;
    }

    return null;
  }

  double _scoreDateCandidate({
    required DateTime parsedDate,
    required int matchPosition,
    required String fullText,
    required DateTime now,
    String? originalYearStr,
  }) {
    double score = 0.0;

    // 1. 위치 점수
    final relativePosition = matchPosition / max(fullText.length, 1);
    score += relativePosition * 0.3;

    // 2. 신선도 점수
    final daysDiff = now.difference(parsedDate).inDays.abs();
    if (daysDiff <= 7) {
      score += 0.3;
    } else if (daysDiff <= 30) {
      score += 0.25;
    } else if (daysDiff <= 90) {
      score += 0.15;
    } else if (daysDiff <= 365) {
      score += 0.05;
    } else {
      score -= 0.2;
    }

    // 3. 미래 날짜 페널티
    if (parsedDate.isAfter(now)) {
      score -= 0.3;
    }

    // 4. 연도 완전성 보너스
    if (originalYearStr != null && originalYearStr.length >= 2) {
      score += 0.1;
    }

    // 5. 가맹점 키워드 근접성 보너스
    if (matchPosition > 3) {
      final beforeDate =
          fullText.substring(max(0, matchPosition - 15), matchPosition);
      if (RegExp(r'[가-힣]{2,}').hasMatch(beforeDate)) {
        score += 0.15;
      }
    }

    return score;
  }

  bool _isValidDate(int year, int month, int day) {
    if (year < 2020 || year > 2030) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;

    const daysInMonth = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (day > daysInMonth[month]) return false;

    return true;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Helper Classes
// ═══════════════════════════════════════════════════════════════════════════

/// 날짜 후보 정보
class DateCandidate {
  final String dateStr;
  final DateTime parsedDate;
  final bool isShort;
  final double score;
  final int matchPosition;

  DateCandidate({
    required this.dateStr,
    required this.parsedDate,
    required this.isShort,
    required this.score,
    required this.matchPosition,
  });
}

/// 날짜 추출 결과
class DateResult {
  final String? dateStr;
  final bool isShort;
  final DateTime? parsedDate;

  DateResult({
    required this.dateStr,
    required this.isShort,
    required this.parsedDate,
  });
}
