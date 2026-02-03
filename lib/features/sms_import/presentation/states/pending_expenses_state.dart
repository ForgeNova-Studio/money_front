import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/sms_import/domain/entities/pending_expense.dart';

part 'pending_expenses_state.freezed.dart';

/// 대기 중인 지출 목록 상태
@freezed
sealed class PendingExpensesState with _$PendingExpensesState {
  const PendingExpensesState._();

  const factory PendingExpensesState({
    /// 대기 중인 지출 목록
    @Default([]) List<PendingExpense> pendingExpenses,

    /// 저장 중 여부
    @Default(false) bool isSaving,

    /// 에러 메시지
    String? error,
  }) = _PendingExpensesState;

  /// 대기 중인 지출 개수
  int get count => pendingExpenses.length;

  /// 대기 중인 지출이 있는지 여부
  bool get hasPendingExpenses => pendingExpenses.isNotEmpty;

  /// 전체 금액 합계
  int get totalAmount =>
      pendingExpenses.fold(0, (sum, item) => sum + item.amount);
}
