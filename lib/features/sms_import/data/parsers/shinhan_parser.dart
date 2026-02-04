import 'package:moamoa/features/sms_import/data/parsers/base_sms_parser.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';

/// 신한카드 SMS 파서
/// 예시: [신한카드] 홍*동 12,000원 일시불 스타벅스 01/27
class ShinhanParser extends BaseSmsParser {
  @override
  String get cardCompanyId => 'shinhan';

  @override
  SmsParseResult parse(String smsText) {
    try {
      final amount = extractAmount(smsText);
      if (amount == null) {
        return const SmsParseResult.failure('금액을 찾을 수 없습니다');
      }

      final date = extractDate(smsText) ?? DateTime.now();
      final merchant = _extractMerchant(smsText);
      final installmentMonths = extractInstallmentMonths(smsText);

      return SmsParseResult.success(ParsedExpense(
        amount: amount,
        merchant: merchant,
        date: date,
        cardCompanyId: cardCompanyId,
        rawText: smsText,
        installmentMonths: installmentMonths,
      ));
    } catch (e) {
      return SmsParseResult.failure('파싱 실패: $e');
    }
  }

  String _extractMerchant(String text) {
    // 패턴: 금액 뒤 일시불/N개월 뒤에 가맹점명
    // 예: 12,000원 일시불 스타벅스
    final pattern = RegExp(r'원\s*(?:일시불|\d+개월)?\s*(.+?)(?:\s*\d|$)');
    final match = pattern.firstMatch(text);
    if (match != null) {
      return match.group(1)?.trim() ?? '알 수 없음';
    }
    return '알 수 없음';
  }
}
