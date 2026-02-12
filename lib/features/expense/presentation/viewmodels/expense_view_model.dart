import 'dart:async';

import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/presentation/providers/expense_providers.dart';
import 'package:moamoa/features/expense/presentation/states/expense_state.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_view_model.g.dart';

/// 지출 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 지출 목록 조회, 상세 조회, 등록, 수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 지출 목록 조회 및 정렬 ([loadExpenses])
/// - 지출 상세 조회 ([getExpenseDetail])
/// - 지출 등록/수정 통합 처리 ([submitExpense])
/// - 지출 생성 시 가계부 ID 자동 주입 ([createExpense])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(expenseViewModelProvider.notifier).loadExpenses();
///
/// // 등록
/// ref.read(expenseViewModelProvider.notifier).submitExpense(
///   amount: 15000,
///   date: DateTime.now(),
///   category: 'FOOD',
///   paymentMethod: 'CARD',
/// );
/// ```
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
  /// API 호출 성공 후 HomeViewModel 데이터를 갱신합니다.
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
    if (existingExpense != null && expenseId != null) {
      // === 수정 ===
      final updated = existingExpense.copyWith(
        expenseId: expenseId,
        amount: amount,
        date: date,
        category: category,
        merchant: merchant,
        memo: memo,
        paymentMethod: paymentMethod,
      );

      await updateExpense(expense: updated);
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

      await createExpense(expense);
    }

    // 성공 시 홈 데이터 갱신
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    unawaited(homeViewModel.fetchMonthlyData(date, forceRefresh: true));
    homeViewModel.refreshBudgetAndAsset();

    // 현재 리스트 갱신 (Stale Data 방지)
    await loadExpenses();
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

  /// 지출 수정
  Future<void> updateExpense({
    required Expense expense,
  }) async {
    final updateUseCase = ref.read(updateExpenseUseCaseProvider);
    await updateUseCase(expenseId: expense.expenseId!, expense: expense);
  }

  /// 총 금액 계산
  int _calculateTotalAmount(List<Expense> expenses) {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }
}
