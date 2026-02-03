import 'package:moamoa/features/sms_import/data/parsers/base_sms_parser.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';

/// 하나카드 SMS 파서
/// 예시: [하나카드] 홍*동님 12,000원 스타벅스 01/27
class HanaParser extends BaseSmsParser {
  @override
  String get cardCompanyId => 'hana';

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
    final pattern = RegExp(r'원\s+(.+?)\s+\d{1,2}[/-]');
    final match = pattern.firstMatch(text);
    if (match != null) {
      return match.group(1)?.trim() ?? '알 수 없음';
    }
    return '알 수 없음';
  }
}
