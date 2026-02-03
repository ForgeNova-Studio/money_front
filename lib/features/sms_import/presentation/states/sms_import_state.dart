import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';

part 'sms_import_state.freezed.dart';

/// SMS 임포트 상태
@freezed
sealed class SmsImportState with _$SmsImportState {
  const SmsImportState._();

  /// 대기 상태 (딥링크 수신 전)
  const factory SmsImportState.idle() = SmsImportIdle;

  /// 파싱 중
  const factory SmsImportState.parsing() = SmsImportParsing;

  /// 파싱 성공 - 확인 대기 중
  const factory SmsImportState.parsed({
    required ParsedExpense expense,
  }) = SmsImportParsed;

  /// 저장 중
  const factory SmsImportState.saving() = SmsImportSaving;

  /// 저장 완료
  const factory SmsImportState.saved() = SmsImportSaved;

  /// 에러
  const factory SmsImportState.error({
    required String message,
    String? rawText,
  }) = SmsImportError;

  /// 현재 파싱된 지출 데이터 (있는 경우)
  ParsedExpense? get parsedExpense => switch (this) {
        SmsImportParsed(:final expense) => expense,
        _ => null,
      };

  /// 로딩 중 여부
  bool get isLoading => switch (this) {
        SmsImportParsing() || SmsImportSaving() => true,
        _ => false,
      };
}
