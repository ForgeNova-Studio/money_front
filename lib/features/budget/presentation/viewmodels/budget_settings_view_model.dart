import 'dart:async';

import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
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

  Future<void> initialize(DateTime? initialDate) async {
    if (_initialized) return;
    _initialized = true;

    final selectedMonth = initialDate != null
        ? DateTime(initialDate.year, initialDate.month)
        : state.currentMonth;

    state = state.copyWith(selectedMonth: selectedMonth);
    await _prefetchBudgets();
  }

  void clearEvent() {
    if (state.event == null) return;
    state = state.copyWith(event: null);
  }

  Future<void> changeMonth(int delta) async {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + delta,
    );

    state = state.copyWith(selectedMonth: newMonth);
    await _fetchAndCacheMonth(newMonth, direction: delta);
  }

  Future<void> goToCurrentMonth() async {
    if (state.isCurrentMonth) return;
    final month = state.currentMonth;
    state = state.copyWith(selectedMonth: month);
    await _fetchAndCacheMonth(month, direction: 0);
  }

  Future<void> saveBudget(double amount) async {
    if (amount < 0) {
      _showError('예산 금액은 0원 이상이어야 합니다.');
      return;
    }

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      _showError('가계부를 선택해주세요.');
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
    } catch (e) {
      if (!ref.mounted) return;
      _showError('예산 저장에 실패했습니다: $e');
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  Future<void> deleteSelectedBudget() async {
    final budget = state.selectedBudget;
    if (budget == null) {
      _showError('삭제할 예산이 없습니다.');
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
    } catch (e) {
      if (!ref.mounted) return;
      _showError('예산 삭제에 실패했습니다: $e');
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isDeleting: false);
      }
    }
  }

  Future<void> _prefetchBudgets() async {
    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      state = state.copyWith(isInitialLoading: false);
      return;
    }

    final baseMonth = state.selectedMonth;
    final months = <DateTime>[];
    for (int i = -1; i <= 1; i++) {
      months.add(DateTime(baseMonth.year, baseMonth.month + i));
    }

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
        // 프리페치 실패는 캐시하지 않는다.
      }
    }));

    if (!ref.mounted) return;
    state = state.copyWith(
      budgetCache: updatedCache,
      isInitialLoading: false,
    );
  }

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

  String? _resolveAccountBookId() {
    final accountBookState = ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }

  void _showError(String message) {
    state = state.copyWith(event: BudgetSettingsShowError(message));
  }
}
