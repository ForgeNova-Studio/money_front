import 'package:freezed_annotation/freezed_annotation.dart';

part 'parsed_expense.freezed.dart';

/// SMS에서 파싱된 지출 데이터
@freezed
sealed class ParsedExpense with _$ParsedExpense {
  const factory ParsedExpense({
    /// 금액 (원)
    required int amount,

    /// 가맹점명
    required String merchant,

    /// 결제 일시
    required DateTime date,

    /// 카드사 ID (samsung, shinhan, kb 등)
    required String cardCompanyId,

    /// 원본 SMS 텍스트
    required String rawText,

    /// 카드 종류 (신용/체크)
    String? cardType,

    /// 할부 개월 (일시불이면 null)
    int? installmentMonths,
  }) = _ParsedExpense;
}

/// 파싱 결과
@freezed
sealed class SmsParseResult with _$SmsParseResult {
  const factory SmsParseResult.success(ParsedExpense expense) = SmsParseSuccess;
  const factory SmsParseResult.failure(String error) = SmsParseFailure;
}
