import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/sms_import/data/parsers/sms_parser_factory.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';
import 'package:moamoa/features/sms_import/presentation/states/sms_import_state.dart';
import 'package:moamoa/features/sms_import/presentation/viewmodels/pending_expenses_view_model.dart';

part 'sms_import_view_model.g.dart';

@riverpod
class SmsImportViewModel extends _$SmsImportViewModel {
  @override
  SmsImportState build() {
    return const SmsImportState.idle();
  }

  /// 딥링크로 받은 SMS 파싱
  void parseFromDeepLink({
    required String cardCompanyId,
    required String smsText,
  }) {
    state = const SmsImportState.parsing();

    // GoRouter가 쿼리 파라미터를 이미 디코딩하므로 추가 디코딩 불필요
    final text = smsText;

    // 파서 가져오기
    final parser = SmsParserFactory.getParser(cardCompanyId);
    if (parser == null) {
      state = SmsImportState.error(
        message: '지원하지 않는 카드사입니다: $cardCompanyId',
        rawText: text,
      );
      return;
    }

    // 파싱 실행
    final result = parser.parse(text);

    switch (result) {
      case SmsParseSuccess(:final expense):
        state = SmsImportState.parsed(expense: expense);
      case SmsParseFailure(:final error):
        state = SmsImportState.error(
          message: error,
          rawText: text,
        );
    }
  }

  /// 파싱된 지출을 대기 목록에 추가
  void addToPending({
    String? category,
    String? memo,
  }) {
    final currentState = state;
    if (currentState is! SmsImportParsed) return;

    final parsedExpense = currentState.expense;

    // 카테고리/메모 수정이 있으면 새 ParsedExpense 생성
    // (ParsedExpense는 Freezed라 copyWith 가능)
    // 단, ParsedExpense에는 category/memo 필드가 없으므로
    // PendingExpense 생성 후 업데이트
    ref.read(pendingExpensesViewModelProvider.notifier).addPendingExpense(parsedExpense);

    // 카테고리/메모가 있으면 추가된 항목 업데이트
    final pendingState = ref.read(pendingExpensesViewModelProvider);
    if (pendingState.pendingExpenses.isNotEmpty && (category != null || memo != null)) {
      final lastId = pendingState.pendingExpenses.last.id;
      ref.read(pendingExpensesViewModelProvider.notifier).updatePendingExpense(
        id: lastId,
        category: category,
        memo: memo,
      );
    }

    state = const SmsImportState.saved();

    if (kDebugMode) {
      debugPrint('[SmsImport] Added to pending: ${parsedExpense.merchant}');
    }
  }

  /// 상태 초기화
  void reset() {
    state = const SmsImportState.idle();
  }
}

