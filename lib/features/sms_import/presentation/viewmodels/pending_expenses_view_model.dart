import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';
import 'package:moamoa/features/sms_import/domain/entities/pending_expense.dart';
import 'package:moamoa/features/sms_import/presentation/states/pending_expenses_state.dart';
import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/presentation/viewmodels/expense_view_model.dart';

part 'pending_expenses_view_model.g.dart';

/// 대기 중인 지출 관리 ViewModel
/// SMS에서 파싱된 지출을 임시 저장하고 일괄 처리
@Riverpod(keepAlive: true)
class PendingExpensesViewModel extends _$PendingExpensesViewModel {
  @override
  PendingExpensesState build() {
    return const PendingExpensesState();
  }

  /// 파싱된 지출을 대기 목록에 추가
  void addPendingExpense(ParsedExpense expense) {
    final pendingExpense = PendingExpense.fromParsedExpense(expense);
    state = state.copyWith(
      pendingExpenses: [...state.pendingExpenses, pendingExpense],
      error: null,
    );

    if (kDebugMode) {
      debugPrint('[PendingExpenses] Added: ${pendingExpense.merchant} - ${pendingExpense.amount}원');
      debugPrint('[PendingExpenses] Total pending: ${state.count}');
    }
  }

  /// 개별 항목 수정 (카테고리, 메모, 가맹점명)
  void updatePendingExpense({
    required String id,
    String? category,
    String? memo,
    String? merchant,
  }) {
    final updatedList = state.pendingExpenses.map((item) {
      if (item.id == id) {
        return item.copyWith(
          category: category ?? item.category,
          memo: memo ?? item.memo,
          merchantOverride: merchant ?? item.merchantOverride,
        );
      }
      return item;
    }).toList();

    state = state.copyWith(pendingExpenses: updatedList);
  }

  /// 개별 항목 삭제
  void removePendingExpense(String id) {
    final updatedList = state.pendingExpenses
        .where((item) => item.id != id)
        .toList();

    state = state.copyWith(pendingExpenses: updatedList);

    if (kDebugMode) {
      debugPrint('[PendingExpenses] Removed item: $id');
      debugPrint('[PendingExpenses] Remaining: ${state.count}');
    }
  }

  /// 모든 대기 지출 일괄 저장
  Future<void> saveAllPendingExpenses() async {
    if (state.pendingExpenses.isEmpty) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final expenseViewModel = ref.read(expenseViewModelProvider.notifier);

      for (final pending in state.pendingExpenses) {
        final expense = Expense(
          amount: pending.amount,
          date: pending.date,
          merchant: pending.merchant,
          category: pending.category,
          memo: pending.memo ?? pending.parsedExpense.rawText,
          paymentMethod: 'CARD',
        );

        await expenseViewModel.createExpense(expense);
      }

      // 저장 완료 후 목록 비우기
      state = const PendingExpensesState();

      if (kDebugMode) {
        debugPrint('[PendingExpenses] All expenses saved successfully');
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: '저장 중 오류가 발생했습니다: $e',
      );

      if (kDebugMode) {
        debugPrint('[PendingExpenses] Save error: $e');
      }
    }
  }

  /// 전체 삭제
  void clearAll() {
    state = const PendingExpensesState();

    if (kDebugMode) {
      debugPrint('[PendingExpenses] Cleared all pending expenses');
    }
  }
}
