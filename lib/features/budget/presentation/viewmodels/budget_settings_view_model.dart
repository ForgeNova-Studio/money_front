import 'dart:async';

import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/providers/budget_usecase_providers.dart';
import 'package:moamoa/features/budget/presentation/constants/budget_error_messages.dart';
import 'package:moamoa/features/budget/presentation/states/budget_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_settings_view_model.g.dart';

@riverpod
class BudgetSettingsViewModel extends _$BudgetSettingsViewModel {
  bool _initialized = false;

  @override
  BudgetSettingsState build() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    return BudgetSettingsState.initial(
      currentMonth: currentMonth,
      selectedMonth: currentMonth,
    );
  }

  /// 예산 설정 첫 진입 초기화 담당
  /// - 선택된 월의 예산, 이전 달의 예산, 다음 달의 예산을 미리 캐시에 채운다.
  Future<void> initialize(DateTime? initialDate) async {
    // 초기화는 한 번만 수행한다. 이미 초기화 된 상태면 리턴한다.
    if (_initialized) return;
    _initialized = true;

    // selectedMonth 초기화 및 가공
    // initialDate가 null이면 현재 월을 선택한다.
    final selectedMonth = initialDate != null
        ? DateTime(initialDate.year, initialDate.month)
        : state.currentMonth;

    state = state.copyWith(selectedMonth: selectedMonth);
    await _prefetchBudgets();
  }

  /// 선택된 월의 예산, 이전 달의 예산, 다음 달의 예산을 미리 캐싱한다
  /// 즉 선택된 월과 +- 1인 달의 예산을 캐싱
  Future<void> _prefetchBudgets() async {
    // 가계부 ID를 가져온다.
    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      state = state.copyWith(isInitialLoading: false);
      return;
    }

    // 선택된 월과 +-1인 달의 예산을 캐싱하기 위해 월 선별
    final baseMonth = state.selectedMonth;
    bool selectedMonthFetchFailed = false;
    final months = <DateTime>[];
    for (int i = -1; i <= 1; i++) {
      months.add(DateTime(baseMonth.year, baseMonth.month + i));
    }

    // 선택된 월들에 대한 캐싱
    final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache);

    await Future.wait(months.map((month) async {
      final key = buildBudgetMonthKey(month);
      if (updatedCache.containsKey(key)) return;

      try {
        final budget = await ref.read(getMonthlyBudgetUseCaseProvider)(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        );
        updatedCache[key] = budget;
      } catch (_) {
        if (month.year == baseMonth.year && month.month == baseMonth.month) {
          selectedMonthFetchFailed = true;
        }
        // 프리페치 실패는 캐시하지 않는다.
      }
    }));

    if (!ref.mounted) return;
    if (selectedMonthFetchFailed) {
      _showError(BudgetErrorMessages.selectedMonthBudgetLoadFailed);
    }
    state = state.copyWith(
      budgetCache: updatedCache,
      isInitialLoading: false,
    );
  }

  /// 이벤트가 종료되면 이벤트를 비운다
  void clearEvent() {
    if (state.event == null) return;
    state = state.copyWith(event: null);
  }

  /// 월 변경
  /// [delta] 만큼 월을 변경한다.
  /// [delta]가 0이면 현재 월로 변경한다.
  Future<void> changeMonth(int delta) async {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + delta,
    );

    state = state.copyWith(selectedMonth: newMonth);
    await _fetchAndCacheMonth(newMonth, direction: delta);
  }

  /// 현재 월로 변경
  Future<void> goToCurrentMonth() async {
    if (state.isCurrentMonth) return;
    final month = state.currentMonth;
    state = state.copyWith(selectedMonth: month);
    await _fetchAndCacheMonth(month, direction: 0);
  }

  /// 예산 저장
  /// [amount] 만큼 예산을 저장한다.
  /// [amount]가 0보다 작으면 에러를 발생시킨다.
  /// [accountBookId]가 null이면 에러를 발생시킨다.
  /// [isSaving] 또는 [isDeleting]이 true이면 중복 요청을 무시한다.
  /// 저장 성공시 [BudgetSettingsPopWithToast] 이벤트를 발생시킨다.
  /// 저장 실패시 [BudgetSettingsShowError] 이벤트를 발생시킨다.
  Future<void> saveBudget(double amount) async {
    if (amount < 0) {
      _showError(BudgetErrorMessages.invalidBudgetAmount);
      return;
    }

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      _showError(BudgetErrorMessages.accountBookNotSelected);
      return;
    }

    if (state.isSaving || state.isDeleting) return;
    state = state.copyWith(isSaving: true);

    try {
      final selectedMonth = state.selectedMonth;
      final budget = await ref.read(createOrUpdateBudgetUseCaseProvider)(
        accountBookId: accountBookId,
        year: selectedMonth.year,
        month: selectedMonth.month,
        targetAmount: amount,
      );

      if (!ref.mounted) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..[buildBudgetMonthKey(selectedMonth)] = budget;
      state = state.copyWith(budgetCache: updatedCache);

      await ref.read(homeViewModelProvider.notifier).fetchMonthlyData(
            selectedMonth,
            forceRefresh: true,
          );

      if (!ref.mounted) return;
      state = state.copyWith(
        event: const BudgetSettingsPopWithToast('예산이 저장되었습니다.'),
      );
    } catch (_) {
      if (!ref.mounted) return;
      _showError(BudgetErrorMessages.budgetSaveFailed);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  /// 예산 삭제
  /// [budget]이 null이면 에러를 발생시킨다.
  /// [isSaving] 또는 [isDeleting]이 true이면 중복 요청을 무시한다.
  /// 삭제 성공시 [BudgetSettingsPop] 이벤트를 발생시킨다.
  /// 삭제 실패시 [BudgetSettingsShowError] 이벤트를 발생시킨다.
  Future<void> deleteSelectedBudget() async {
    final budget = state.selectedBudget;
    if (budget == null) {
      _showError(BudgetErrorMessages.noBudgetToDelete);
      return;
    }

    if (state.isSaving || state.isDeleting) return;
    state = state.copyWith(isDeleting: true);

    try {
      final selectedMonth = state.selectedMonth;

      await ref.read(deleteBudgetUseCaseProvider)(budgetId: budget.budgetId);

      if (!ref.mounted) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..[buildBudgetMonthKey(selectedMonth)] = null;
      state = state.copyWith(
        budgetCache: updatedCache,
        event: const BudgetSettingsPop(),
      );

      unawaited(
        ref.read(homeViewModelProvider.notifier).fetchMonthlyData(
              selectedMonth,
              forceRefresh: true,
            ),
      );
    } catch (_) {
      if (!ref.mounted) return;
      _showError(BudgetErrorMessages.budgetDeleteFailed);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isDeleting: false);
      }
    }
  }

  /// 예산 데이터를 가져와 캐시에 저장한다.
  /// 캐시에 이미 값이 있으면 조회를 생략하고 [direction] 방향으로 프리페치만 수행한다.
  /// [direction]은 추가 프리페치 방향이며, -1/1은 이전/다음 달, 0은 추가 프리페치 없음이다.
  Future<void> _fetchAndCacheMonth(
    DateTime month, {
    required int direction,
  }) async {
    final key = buildBudgetMonthKey(month);

    if (state.budgetCache.containsKey(key)) {
      _prefetchDirectional(month, direction);
      return;
    }

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) return;

    try {
      final budget = await ref.read(getMonthlyBudgetUseCaseProvider)(
        year: month.year,
        month: month.month,
        accountBookId: accountBookId,
      );

      if (!ref.mounted) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..[key] = budget;
      state = state.copyWith(budgetCache: updatedCache);

      _prefetchDirectional(month, direction);
    } catch (_) {
      if (!ref.mounted) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..remove(key);
      state = state.copyWith(budgetCache: updatedCache);
    }
  }

  void _prefetchDirectional(DateTime currentMonth, int direction) {
    if (direction == 0) return;

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) return;

    final targetMonth =
        DateTime(currentMonth.year, currentMonth.month + direction);
    final key = buildBudgetMonthKey(targetMonth);

    if (state.budgetCache.containsKey(key)) return;

    unawaited(
      ref
          .read(getMonthlyBudgetUseCaseProvider)(
        year: targetMonth.year,
        month: targetMonth.month,
        accountBookId: accountBookId,
      )
          .then((budget) {
        if (!ref.mounted) return;
        final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
          ..[key] = budget;
        state = state.copyWith(budgetCache: updatedCache);
      }).catchError((_) {
        // 프리페치 실패는 캐시하지 않는다.
      }),
    );
  }

  /// 선택된 가계부의 ID를 반환한다.
  String? _resolveAccountBookId() {
    final accountBookState = ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }

  /// 에러 이벤트를 추가한다.
  /// [message]를 포함한 [BudgetSettingsShowError] 이벤트를 추가한다.
  void _showError(String message) {
    state = state.copyWith(event: BudgetSettingsShowError(message));
  }
}
