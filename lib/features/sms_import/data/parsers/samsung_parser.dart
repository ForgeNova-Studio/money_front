import 'package:moamoa/features/sms_import/data/parsers/base_sms_parser.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';

/// 삼성카드 SMS 파서
/// 예시: [삼성카드] 홍*동님 12,000원 스타벅스 승인 01/27
class SamsungParser extends BaseSmsParser {
  @override
  String get cardCompanyId => 'samsung';

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
    // 패턴: 금액 뒤 가맹점명 뒤 승인
    // 예: 12,000원 스타벅스 승인
    final pattern = RegExp(r'원\s+(.+?)\s+승인');
    final match = pattern.firstMatch(text);
    if (match != null) {
      return match.group(1)?.trim() ?? '알 수 없음';
    }
    return '알 수 없음';
  }
}
