import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';
import 'package:moneyflow/features/ocr/domain/entities/receipt_data.dart';
import 'package:moneyflow/features/ocr/domain/patterns/receipt_pattern.dart';

class CommonPattern implements ReceiptPattern {
  final _logger = Logger();

  @override
  String get name => 'CommonPattern (Dual Date Regex)';

  // 금액 Regex
  static final RegExp _moneyRegex = RegExp(
    r'([+\-]?\s?[\d]{1,3}(,[\d]{3})+)(\s?원)?|([+\-]?\s?[\d]{3,}\s?원?)',
  );

  // 날짜 Regex 1: 연도 포함 (예: 5.11.24, 25.11.20, 2025-11-20)
  // 1자리 연도도 허용 (OCR이 "25"를 "5"로 인식하는 경우 대응)
  static final RegExp _dateFullRegex = RegExp(
    r'(\d{1,4})[\s\.\-/년]+(\d{1,2})[\s\.\-/월]+(\d{1,2})[일]?',
  );

  // 날짜 Regex 2: 월/일만 있음 (예: 11 24, 11/24)
  static final RegExp _dateShortRegex = RegExp(
    r'(\d{1,2})[\s\.\-/월]+(\d{1,2})[일]?',
  );

  // 카드사 결제내역 노이즈 패턴 (기존 + 추가)
  static final RegExp _noiseRegex = RegExp(
    r'(\d{1,2}:\d{2})|'           // 시간 (14:30)
    r'(\d+(\.\d+)?%)|'            // 퍼센트
    r'(일시불|할부|적립|이용|내역|' // 기존 노이즈
    r'예정|시불|익월|출금|청구|'    // 카드사 용어
    r'결제완료|승인|취소|'          // 상태
    r'\d{1,2}\s?\([^)]*\))'       // "23 ()" 같은 패턴
  );

  static const List<String> _dropKeywords = [
    '합계', '총액', '결제금액', '청구금액', '출금예정', '이번달', '명세서', '결제예정', '잔액', '포인트'
  ];

  @override
  bool canParse(RecognizedText text) => true;

  @override
  List<ReceiptData> parse(RecognizedText text) {
    List<ReceiptData> results = [];
    List<TextLine> allLines = [];

    for (var block in text.blocks) {
      allLines.addAll(block.lines);
    }

    var moneyLines = allLines.where((line) {
      // 날짜 형식이 포함된 라인은 금액 라인이 아님 (오인 방지)
      return _moneyRegex.hasMatch(line.text) &&
          !_dateFullRegex.hasMatch(line.text) &&
          !_dateShortRegex.hasMatch(line.text);
    }).toList();

    moneyLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    //  날짜 헤더 라인 수집 (날짜만 있고 금액은 없는 라인)
    // 예: "25. 12. 20(토)" - 이 아래에 여러 거래가 묶여있는 형식
    final dateHeaderLines = allLines.where((line) {
      final hasFullDate = _dateFullRegex.hasMatch(line.text);
      final hasMoney = _moneyRegex.hasMatch(line.text);
      return hasFullDate && !hasMoney;
    }).toList();
    dateHeaderLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
    
    _logger.d(' 발견된 금액 라인: ${moneyLines.length}개');
    _logger.d(' 발견된 날짜 헤더: ${dateHeaderLines.length}개');

    // 날짜 컨텍스트 추적 변수
    DateTime? lastKnownDate;
    int linesSinceLastDate = 0;
    const int maxDateContextDistance = 10; // 최대 10라인까지 컨텍스트 유지

    for (var moneyLine in moneyLines) {
      if (_hasDropKeyword(moneyLine.text)) continue;

      int amount = _parseAmountInt(moneyLine.text);
      if (amount == 0) continue;

      final anchor = moneyLine.boundingBox;
      final double h = anchor.height;

      // Smart Zone: 위로 2.5줄, 아래로 1.5줄
      final smartZone = Rect.fromLTRB(
          0,
          anchor.top - (h * 2.5),
          anchor.left + 20,
          anchor.bottom + (h * 1.5)
      );

      List<TextLine> rawTexts = [];

      for (var line in allLines) {
        if (line == moneyLine) continue;

        if (_isOverlapping(line.boundingBox, smartZone)) {
          if (!_hasDropKeyword(line.text)) {
            rawTexts.add(line);
          }
        }
      }

      rawTexts.sort((a, b) {
        double dy = (a.boundingBox.top - b.boundingBox.top).abs();
        if (dy < h * 0.5) return a.boundingBox.left.compareTo(b.boundingBox.left);
        return a.boundingBox.top.compareTo(b.boundingBox.top);
      });

      String fullText = rawTexts.map((e) => e.text).join(' ');

      //  OCR 원본 텍스트 로그
      _logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.d('📝 OCR 원본 텍스트: "$fullText"');
      _logger.d('   금액 라인: "${moneyLine.text}" ($amount원)');

      if (_hasDropKeyword(fullText)) continue;

      //  스마트 날짜 추출 (모든 후보 찾기 → 점수화 → 최적 선택)
      final dateResult = _extractBestDate(fullText);
      String? dateStr = dateResult.dateStr;
      bool isShortDate = dateResult.isShort;

      DateTime? parsedDate = _parseDateObj(dateStr, isShortDate);
      
      //  "오늘" 키워드 처리 → 오늘 날짜 적용
      // 텍스트 맨 앞에 "오늘"이 있고 뒤에 공백/특수문자가 올 때만 (날짜 헤더 역할)
      // 예: "오늘 ● 컴포즈커피..." → , "맛있는 오늘 카페" → ❌
      final todayRegex = RegExp(r'^오늘[\s●•\-\.]');
      if (parsedDate == null && todayRegex.hasMatch(fullText)) {
        final now = DateTime.now();
        parsedDate = DateTime(now.year, now.month, now.day);
        _logger.d('    "오늘" 헤더 감지 → $parsedDate 적용');
      }
      
      //  날짜 컨텍스트 처리
      if (parsedDate != null) {
        // 인라인 날짜 발견 시 컨텍스트 업데이트
        lastKnownDate = parsedDate;
        linesSinceLastDate = 0;
      } else {
        // 인라인 날짜 없음 → 가장 가까운 날짜 헤더 라인 검색
        linesSinceLastDate++;
        
        // 현재 금액 라인 위에 있는 가장 가까운 날짜 헤더 찾기
        TextLine? closestDateHeader;
        for (var headerLine in dateHeaderLines.reversed) {
          if (headerLine.boundingBox.top < moneyLine.boundingBox.top) {
            closestDateHeader = headerLine;
            break;
          }
        }
        
        if (closestDateHeader != null) {
          // 날짜 헤더에서 날짜 추출
          final headerDateResult = _extractBestDate(closestDateHeader.text);
          final headerDate = _parseDateObj(headerDateResult.dateStr, headerDateResult.isShort);
          
          if (headerDate != null) {
            parsedDate = headerDate;
            lastKnownDate = headerDate;
            _logger.d('    날짜 헤더에서 컨텍스트 적용: ${closestDateHeader.text} → $parsedDate');
          }
        } else if (lastKnownDate != null && linesSinceLastDate <= maxDateContextDistance) {
          // 날짜 헤더도 없으면 마지막 알려진 날짜 사용 (거리 제한 내)
          parsedDate = lastKnownDate;
          _logger.d('    이전 컨텍스트 날짜 적용: $parsedDate (${linesSinceLastDate}라인 전)');
        }
      }

      // 상호명 추출 (날짜 텍스트 제거)
      String merchantName = fullText;
      if (dateStr != null) {
        merchantName = merchantName.replaceAll(dateStr, '');
      }
      merchantName = _cleanStoreName(merchantName);

      if (merchantName.isEmpty) merchantName = "미확인 가맹점";

      _logger.d('    파싱 결과: 상호="$merchantName", 날짜=$parsedDate');

      //  [핵심] 쓰레기 데이터 소각
      // 상호명도 모르고 날짜도 없으면 -> 의미 없는 데이터 (1번 항목 제거용)
      if (merchantName == "미확인 가맹점" && parsedDate == null) {
        _logger.w(' 쓰레기 데이터 삭제: $amount원');
        continue;
      }

      bool isCancel = moneyLine.text.contains('-') ||
          moneyLine.text.contains('취소') ||
          merchantName.contains('취소');

      results.add(ReceiptData(
        rawText: fullText,  //  금액이 아닌 전체 원본 텍스트를 저장 (중복 판단에 사용)
        amount: isCancel ? amount.abs() : amount,
        date: parsedDate,
        merchant: merchantName,
        status: isCancel ? ReceiptStatus.cancelled : ReceiptStatus.approved,
        cardIssuer: null,
      ));
    }

    return results;
  }

  bool _isOverlapping(Rect target, Rect box) {
    if (!target.overlaps(box)) return false;
    final intersection = target.intersect(box);
    return (intersection.width * intersection.height) > 0;
  }

  bool _hasDropKeyword(String text) {
    String clean = text.replaceAll(RegExp(r'\s'), '');
    return _dropKeywords.any((k) => clean.contains(k));
  }

  String _cleanStoreName(String text) {
    String clean = text;
    clean = clean.replaceAll(_noiseRegex, '');
    clean = clean.replaceAll(RegExp(r'[^\w가-힣\(\)\s]'), '');
    List<String> words = clean.split(' ');
    words.removeWhere((w) => w.length <= 1 && RegExp(r'[A-Za-z0-9]').hasMatch(w));
    return words.join(' ').trim();
  }

  int _parseAmountInt(String text) {
    try {
      String clean = text.replaceAll(RegExp(r'[^0-9\-]'), '');
      return int.parse(clean);
    } catch (e) {
      return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🧠 스마트 날짜 추출 시스템 (Production-Grade)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// 모든 날짜 후보를 찾아 점수화하고 최적의 날짜를 반환
  _DateResult _extractBestDate(String fullText) {
    final candidates = <_DateCandidate>[];
    final now = DateTime.now();
    
    // 1. Full 날짜 패턴 (YY.MM.DD) 모든 매칭 수집
    for (final match in _dateFullRegex.allMatches(fullText)) {
      final dateStr = match.group(0)!;
      final yearStr = match.group(1)!;
      final monthStr = match.group(2)!;
      final dayStr = match.group(3)!;
      
      int year = int.tryParse(yearStr) ?? 0;
      int month = int.tryParse(monthStr) ?? 0;
      int day = int.tryParse(dayStr) ?? 0;
      
      //  OCR 연도 오류 복구: "5" → "25", "4" → "24"
      if (year >= 1 && year <= 9) {
        year = 2020 + year;  // 1-9 → 2021-2029
      } else if (year >= 10 && year <= 99) {
        year = 2000 + year;  // 10-99 → 2010-2099
      }
      
      // 유효성 검사
      if (!_isValidDate(year, month, day)) continue;
      
      final parsedDate = DateTime(year, month, day);
      final score = _scoreDateCandidate(
        parsedDate: parsedDate,
        matchPosition: match.start,
        fullText: fullText,
        now: now,
        originalYearStr: yearStr,
      );
      
      candidates.add(_DateCandidate(
        dateStr: dateStr,
        parsedDate: parsedDate,
        isShort: false,
        score: score,
        matchPosition: match.start,
      ));
      
      _logger.d('    후보[${ candidates.length}] Full: "$dateStr" → $parsedDate (점수: ${score.toStringAsFixed(2)})');
    }
    
    // 2. Short 날짜 패턴 (MM.DD) - Full이 없을 때만 사용
    if (candidates.isEmpty) {
      for (final match in _dateShortRegex.allMatches(fullText)) {
        final dateStr = match.group(0)!;
        final monthStr = match.group(1)!;
        final dayStr = match.group(2)!;
        
        int month = int.tryParse(monthStr) ?? 0;
        int day = int.tryParse(dayStr) ?? 0;
        
        //  Short 날짜에서 OCR 오류 복구: "5. 11" → "11. 5" 또는 "11월 5일"로 해석
        // 첫 번째 숫자가 13 이상이면 일자일 가능성 (잘못된 월-일 순서)
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
        ) - 0.1;  // Short는 Full보다 약간 낮은 점수
        
        candidates.add(_DateCandidate(
          dateStr: dateStr,
          parsedDate: parsedDate,
          isShort: true,
          score: score,
          matchPosition: match.start,
        ));
        
        _logger.d('    후보[${candidates.length}] Short: "$dateStr" → $parsedDate (점수: ${score.toStringAsFixed(2)})');
      }
    }
    
    // 3. 후보가 없으면 빈 결과 반환
    if (candidates.isEmpty) {
      _logger.d('    날짜 후보 없음');
      return _DateResult(dateStr: null, isShort: false, parsedDate: null);
    }
    
    // 4. 점수순 정렬 후 최고 점수 선택
    candidates.sort((a, b) => b.score.compareTo(a.score));
    final best = candidates.first;
    
    _logger.d('    최종 선택: "${best.dateStr}" → ${best.parsedDate} (점수: ${best.score.toStringAsFixed(2)})');
    
    return _DateResult(
      dateStr: best.dateStr,
      isShort: best.isShort,
      parsedDate: best.parsedDate,
    );
  }

  /// 날짜 후보의 점수 계산 (높을수록 좋음)
  double _scoreDateCandidate({
    required DateTime parsedDate,
    required int matchPosition,
    required String fullText,
    required DateTime now,
    String? originalYearStr,
  }) {
    double score = 0.0;
    
    // === 1. 위치 점수 (뒤에 있을수록 높음 - 보통 가맹점명 뒤에 날짜가 옴) ===
    // 전체 텍스트에서의 상대적 위치 (0.0 ~ 0.3)
    final relativePosition = matchPosition / max(fullText.length, 1);
    score += relativePosition * 0.3;
    
    // === 2. 신선도 점수 (현재와 가까울수록 높음) ===
    final daysDiff = now.difference(parsedDate).inDays.abs();
    if (daysDiff <= 7) {
      score += 0.3;  // 일주일 이내
    } else if (daysDiff <= 30) {
      score += 0.25;  // 한 달 이내
    } else if (daysDiff <= 90) {
      score += 0.15;  // 3개월 이내
    } else if (daysDiff <= 365) {
      score += 0.05;  // 1년 이내
    } else {
      score -= 0.2;  // 1년 이상 과거/미래는 감점
    }
    
    // === 3. 미래 날짜 페널티 ===
    if (parsedDate.isAfter(now)) {
      score -= 0.3;  // 미래 날짜는 큰 감점
    }
    
    // === 4. 연도 완전성 보너스 ===
    if (originalYearStr != null && originalYearStr.length >= 2) {
      score += 0.1;  // 연도가 2자리 이상이면 보너스
    }
    
    // === 5. 가맹점 키워드 근접성 보너스 ===
    // 날짜 앞에 한글(가맹점명)이 있으면 보너스
    if (matchPosition > 3) {
      final beforeDate = fullText.substring(max(0, matchPosition - 15), matchPosition);
      if (RegExp(r'[가-힣]{2,}').hasMatch(beforeDate)) {
        score += 0.15;  // 날짜 앞에 한글이 있으면 가맹점 바로 뒤일 가능성
      }
    }
    
    return score;
  }
  
  /// 날짜 유효성 검사
  bool _isValidDate(int year, int month, int day) {
    if (year < 2020 || year > 2030) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    
    // 월별 일수 체크
    const daysInMonth = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (day > daysInMonth[month]) return false;
    
    return true;
  }

  // 날짜 파싱 (Short 포맷 지원) - _extractBestDate에서 이미 파싱된 경우 재사용
  DateTime? _parseDateObj(String? text, bool isShort) {
    if (text == null) return null;
    try {
      int year, month, day;
      DateTime now = DateTime.now();

      if (isShort) {
        // Short: "11 24" -> 금년 11월 24일
        final match = _dateShortRegex.firstMatch(text);
        if (match == null) return null;
        year = now.year;
        month = int.parse(match.group(1)!);
        day = int.parse(match.group(2)!);
      } else {
        // Full: "25 11 20" or "5 11 24" (OCR 오류)
        final match = _dateFullRegex.firstMatch(text);
        if (match == null) return null;
        String yStr = match.group(1)!;
        month = int.parse(match.group(2)!);
        day = int.parse(match.group(3)!);
        
        //  OCR 연도 복구
        int yearNum = int.parse(yStr);
        if (yearNum >= 1 && yearNum <= 9) {
          year = 2020 + yearNum;  // 5 → 2025
        } else if (yearNum >= 10 && yearNum <= 99) {
          year = 2000 + yearNum;  // 25 → 2025
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
}

// ═══════════════════════════════════════════════════════════════════════════
// Helper Classes
// ═══════════════════════════════════════════════════════════════════════════

/// 날짜 후보 정보
class _DateCandidate {
  final String dateStr;
  final DateTime parsedDate;
  final bool isShort;
  final double score;
  final int matchPosition;
  
  _DateCandidate({
    required this.dateStr,
    required this.parsedDate,
    required this.isShort,
    required this.score,
    required this.matchPosition,
  });
}

/// 날짜 추출 결과
class _DateResult {
  final String? dateStr;
  final bool isShort;
  final DateTime? parsedDate;
  
  _DateResult({
    required this.dateStr,
    required this.isShort,
    required this.parsedDate,
  });
}