import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/expense/presentation/providers/expense_providers.dart';
import 'package:moneyflow/features/expense/presentation/states/expense_state.dart';
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

  /// 지출 생성
  Future<void> createExpense(Expense expense) async {
    final createUseCase = ref.read(createExpenseUseCaseProvider);

    // 낙관적 업데이트 또는 로딩 표시를 할 수 있지만,
    // 여기서는 심플하게 API 호출 후 목록을 다시 로드하는 방식을 사용
    await createUseCase(expense);
    // await loadExpenses();
  }

  // 지출 상세 조회

  /// 지출 수정

  /// 지출 삭제

  /// 총 금액 계산
  double _calculateTotalAmount(List<Expense> expenses) {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }
}
