import 'dart:async';

import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/presentation/providers/expense_providers.dart';
import 'package:moamoa/features/expense/presentation/states/expense_state.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_view_model.g.dart';

@riverpod
class ExpenseViewModel extends _$ExpenseViewModel {
  @override
  ExpenseState build() {
    return ExpenseState(
      focusedDay: DateTime.now(),
      selectedDate: DateTime.now(),
    );
  }

  /// 초기 데이터 로드 및 월 변경 시 호출
  Future<void> loadExpenses() async {
    final repository = ref.read(getExpenseListUseCaseProvider);
    final focusedDay = state.focusedDay;

    // 해당 월의 시작일과 종료일 계산
    final startDate = DateTime(focusedDay.year, focusedDay.month, 1);
    final endDate = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    state = state.copyWith(expenses: const AsyncValue.loading());

    try {
      final expenses = await repository(
        startDate: startDate,
        endDate: endDate,
      );

      // 날짜 내림차순 정렬
      expenses.sort((a, b) => b.date.compareTo(a.date));

      state = state.copyWith(
        expenses: AsyncValue.data(expenses),
        totalAmount: _calculateTotalAmount(expenses),
      );
    } catch (e, stack) {
      state = state.copyWith(expenses: AsyncValue.error(e, stack));
    }
  }

  /// 지출 상세 조회
  Future<Expense> getExpenseDetail(String expenseId) async {
    final useCase = ref.read(getExpenseDetailUseCaseProvider);
    return await useCase(expenseId);
  }

  /// 지출 등록/수정 통합 메서드
  ///
  /// [existingExpense]가 null이면 신규 등록, 아니면 수정.
  /// Optimistic Update → API 호출 → HomeViewModel 갱신을 일괄 처리합니다.
  Future<void> submitExpense({
    required int amount,
    required DateTime date,
    required String category,
    String? merchant,
    String? memo,
    String? paymentMethod,
    String? expenseId,
    Expense? existingExpense,
  }) async {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    if (existingExpense != null && expenseId != null) {
      // === 수정 ===
      final updated = existingExpense.copyWith(
        amount: amount,
        date: date,
        category: category,
        merchant: merchant,
        memo: memo,
        paymentMethod: paymentMethod,
      );

      // 1. Optimistic Update
      final oldTransaction = TransactionEntity.fromExpense(existingExpense);
      final newTransaction = TransactionEntity.fromExpense(
        updated.copyWith(expenseId: existingExpense.expenseId ?? expenseId),
      );
      homeViewModel.updateTransactionOptimistically(
        oldTransaction: oldTransaction,
        newTransaction: newTransaction,
      );

      // 2. API 호출
      final updateUseCase = ref.read(updateExpenseUseCaseProvider);
      await updateUseCase(
        expenseId: existingExpense.expenseId ?? expenseId,
        expense: updated,
      );
    } else {
      // === 신규 등록 ===
      final expense = Expense(
        amount: amount,
        date: date,
        category: category,
        merchant: merchant,
        memo: memo,
        paymentMethod: paymentMethod,
      );

      // 1. Optimistic Update
      final optimisticTransaction = TransactionEntity(
        id: '',
        amount: amount,
        date: date,
        title: merchant ?? category,
        category: category,
        memo: memo,
        type: TransactionType.expense,
        createdAt: DateTime.now(),
      );
      homeViewModel.addTransactionOptimistically(optimisticTransaction);

      // 2. API 호출
      await createExpense(expense);
    }

    // 3. 서버 데이터로 갱신
    unawaited(homeViewModel.fetchMonthlyData(
      date,
      forceRefresh: true,
    ));

    // 4. 예산/자산 정보 갱신
    homeViewModel.refreshBudgetAndAsset();
  }

  /// 지출 생성
  Future<void> createExpense(Expense expense) async {
    // 선택된 가계부 ID 가져오기
    final selectedAccountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (selectedAccountBookId == null) {
      throw StateError('Account book is not selected');
    }
    final createUseCase = ref.read(createExpenseUseCaseProvider);
    final request = expense.copyWith(accountBookId: selectedAccountBookId);

    await createUseCase(request);
  }

  /// 총 금액 계산
  int _calculateTotalAmount(List<Expense> expenses) {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }
}
