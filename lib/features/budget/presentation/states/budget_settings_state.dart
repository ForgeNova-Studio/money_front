import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';

sealed class BudgetSettingsEvent {
  const BudgetSettingsEvent();
}

class BudgetSettingsShowError extends BudgetSettingsEvent {
  const BudgetSettingsShowError(this.message);

  final String message;
}

class BudgetSettingsPop extends BudgetSettingsEvent {
  const BudgetSettingsPop();
}

class BudgetSettingsPopWithToast extends BudgetSettingsEvent {
  const BudgetSettingsPopWithToast(this.message);

  final String message;
}

class BudgetSettingsState {
  const BudgetSettingsState({
    required this.currentMonth,
    required this.selectedMonth,
    required this.budgetCache,
    required this.isInitialLoading,
    required this.isSaving,
    required this.isDeleting,
    this.event,
  });

  factory BudgetSettingsState.initial({
    required DateTime currentMonth,
    required DateTime selectedMonth,
  }) {
    return BudgetSettingsState(
      currentMonth: currentMonth,
      selectedMonth: selectedMonth,
      budgetCache: const {},
      isInitialLoading: true,
      isSaving: false,
      isDeleting: false,
    );
  }

  final DateTime currentMonth;
  final DateTime selectedMonth;
  final Map<String, BudgetEntity?> budgetCache;
  final bool isInitialLoading;
  final bool isSaving;
  final bool isDeleting;
  final BudgetSettingsEvent? event;

  bool get isCurrentMonth =>
      selectedMonth.year == currentMonth.year &&
      selectedMonth.month == currentMonth.month;

  BudgetEntity? get selectedBudget =>
      budgetCache[buildBudgetMonthKey(selectedMonth)];

  static const _unset = Object();

  BudgetSettingsState copyWith({
    DateTime? currentMonth,
    DateTime? selectedMonth,
    Map<String, BudgetEntity?>? budgetCache,
    bool? isInitialLoading,
    bool? isSaving,
    bool? isDeleting,
    Object? event = _unset,
  }) {
    return BudgetSettingsState(
      currentMonth: currentMonth ?? this.currentMonth,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      budgetCache: budgetCache ?? this.budgetCache,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      event: event == _unset ? this.event : event as BudgetSettingsEvent?,
    );
  }
}
