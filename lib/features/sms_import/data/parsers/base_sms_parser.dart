import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';

/// SMS 파서 기본 클래스
abstract class BaseSmsParser {
  /// 카드사 ID
  String get cardCompanyId;

  /// SMS 텍스트를 파싱하여 지출 데이터 추출
  SmsParseResult parse(String smsText);

  /// 금액 문자열에서 숫자 추출 (예: "12,000원" -> 12000)
  int? extractAmount(String text) {
    final amountPattern = RegExp(r'([\d,]+)\s*원');
    final match = amountPattern.firstMatch(text);
    if (match != null) {
      final amountStr = match.group(1)!.replaceAll(',', '');
      return int.tryParse(amountStr);
    }
    return null;
  }

  /// 날짜 추출 (시간 제외, 날짜만)
  DateTime? extractDate(String text) {
    final now = DateTime.now();

    // 패턴 1: MM/DD (예: 01/27)
    final pattern1 = RegExp(r'(\d{1,2})/(\d{1,2})');
    var match = pattern1.firstMatch(text);
    if (match != null) {
      final month = int.parse(match.group(1)!);
      final day = int.parse(match.group(2)!);
      return DateTime(now.year, month, day);
    }

    // 패턴 2: MM-DD (예: 01-27)
    final pattern2 = RegExp(r'(\d{1,2})-(\d{1,2})');
    match = pattern2.firstMatch(text);
    if (match != null) {
      final month = int.parse(match.group(1)!);
      final day = int.parse(match.group(2)!);
      return DateTime(now.year, month, day);
    }

    // 날짜를 찾지 못한 경우 오늘 날짜 반환
    return DateTime(now.year, now.month, now.day);
  }

  /// 할부 개월 수 추출
  int? extractInstallmentMonths(String text) {
    if (text.contains('일시불')) {
      return null;
    }

    final pattern = RegExp(r'(\d+)\s*개월');
    final match = pattern.firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }

    return null;
  }
}
