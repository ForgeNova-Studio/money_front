import 'package:moamoa/features/income/domain/entities/income.dart';
import 'package:moamoa/features/income/presentation/providers/income_providers.dart';
import 'package:moamoa/features/income/presentation/states/income_state.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'income_view_model.g.dart';

@riverpod
class IncomeViewModel extends _$IncomeViewModel {
  @override
  IncomeState build() {
    return IncomeState(
      focusedDay: DateTime.now(),
      selectedDate: DateTime.now(),
    );
  }

  /// 초기 데이터 로드 및 월 변경 시 호출
  Future<void> loadIncome() async {
    final repository = ref.read(getIncomeListUsecaseProvider);
    final focusedDay = state.focusedDay;

    // 해당 월의 시작일과 종료일 계산
    final startDate = DateTime(focusedDay.year, focusedDay.month, 1);
    final endDate = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    state = state.copyWith(incomes: const AsyncValue.loading());

    try {
      final incomes = await repository(
        startDate: startDate,
        endDate: endDate,
      );

      // 날짜 내림차순 정렬
      incomes.sort((a, b) => b.date.compareTo(a.date));

      state = state.copyWith(
        incomes: AsyncValue.data(incomes),
        totalAmount: _calculateTotalAmount(incomes),
      );
    } catch (e, stack) {
      state = state.copyWith(incomes: AsyncValue.error(e, stack));
    }
  }

  /// 수입 생성
  Future<void> createIncome(Income income) async {
    // 선택된 가계부 ID 가져오기
    final selectedAccountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (selectedAccountBookId == null) {
      throw StateError('Account book is not selected');
    }
    final createUseCase = ref.read(createIncomeUsecaseProvider);
    final request = income.copyWith(accountBookId: selectedAccountBookId);

    // 낙관적 업데이트 또는 로딩 표시를 할 수 있지만,
    // 여기서는 심플하게 API 호출 후 목록을 다시 로드하는 방식을 사용
    await createUseCase(income: request);
    // await loadIncome();
  }

  /// 수입 상세 조회

  /// 수입 수정

  /// 수입 삭제

  /// 총 금액 계산
  double _calculateTotalAmount(List<Income> incomes) {
    return incomes.fold(0, (sum, item) => sum + item.amount);
  }
}
