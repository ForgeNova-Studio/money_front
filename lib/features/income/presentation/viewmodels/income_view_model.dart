import 'dart:async';

import 'package:moamoa/features/income/domain/entities/income.dart';
import 'package:moamoa/features/income/presentation/providers/income_providers.dart';
import 'package:moamoa/features/income/presentation/states/income_state.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'income_view_model.g.dart';

/// 수입 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 수입 목록 조회, 상세 조회, 등록/수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 수입 목록 조회 및 정렬 ([loadIncome])
/// - 수입 상세 조회 ([getIncomeDetail])
/// - 수입 등록/수정 통합 처리 ([submitIncome])
/// - 수입 생성 시 가계부 ID 자동 주입 ([createIncome])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(incomeViewModelProvider.notifier).loadIncome();
///
/// // 등록
/// ref.read(incomeViewModelProvider.notifier).submitIncome(
///   amount: 3000000,
///   date: DateTime.now(),
///   source: 'SALARY',
/// );
/// ```
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

  /// 수입 상세 조회
  Future<Income> getIncomeDetail(String incomeId) async {
    final useCase = ref.read(getIncomeDetailUsecaseProvider);
    return await useCase(incomeId: incomeId);
  }

  /// 수입 등록/수정 통합 메서드
  ///
  /// [existingIncome]이 null이면 신규 등록, 아니면 수정.
  /// API 호출 성공 후 HomeViewModel 데이터를 갱신합니다.
  Future<void> submitIncome({
    required int amount,
    required DateTime date,
    required String source,
    String? description,
    String? incomeId,
    Income? existingIncome,
  }) async {
    if (existingIncome != null && incomeId != null) {
      // === 수정 ===
      final updated = existingIncome.copyWith(
        incomeId: incomeId,
        amount: amount,
        date: date,
        source: source,
        description: description,
      );

      await updateIncome(income: updated);
    } else {
      // === 신규 등록 ===
      final income = Income(
        amount: amount,
        date: date,
        source: source,
        description: description,
      );

      await createIncome(income);
    }

    // 성공 시 홈 데이터 갱신
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    unawaited(homeViewModel.fetchMonthlyData(date, forceRefresh: true));
    homeViewModel.refreshBudgetAndAsset();
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

    await createUseCase(income: request);
  }

  /// 수입 수정
  Future<void> updateIncome({
    required Income income,
  }) async {
    final updateUseCase = ref.read(updateIncomeUsecaseProvider);
    await updateUseCase(incomeId: income.incomeId!, income: income);
  }

  /// 총 금액 계산
  int _calculateTotalAmount(List<Income> incomes) {
    return incomes.fold(0, (sum, item) => sum + item.amount);
  }
}
