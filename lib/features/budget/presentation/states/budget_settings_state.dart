import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';

part 'budget_settings_state.freezed.dart';

/// 예산 설정 화면 이벤트를 반환하는 클래스
/// - [BudgetSettingsShowError]: 에러 메시지를 표시한다.
/// - [BudgetSettingsPop]: 화면을 종료한다.
/// - [BudgetSettingsPopWithToast]: 화면을 종료하고 토스트 메시지를 표시한다.
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

/// 예산 설정 화면의 상태를 반환하는 클래스
@freezed
sealed class BudgetSettingsState with _$BudgetSettingsState {
  const BudgetSettingsState._();

  const factory BudgetSettingsState({
    required DateTime currentMonth,
    required DateTime selectedMonth,
    @Default(<String, BudgetEntity?>{}) Map<String, BudgetEntity?> budgetCache,
    @Default(true) bool isInitialLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,
    BudgetSettingsEvent? event,
  }) = _BudgetSettingsState;

  factory BudgetSettingsState.initial({
    required DateTime currentMonth,
    required DateTime selectedMonth,
  }) =>
      BudgetSettingsState(
      currentMonth: currentMonth,
      selectedMonth: selectedMonth,
    );

  bool get isCurrentMonth =>
      selectedMonth.year == currentMonth.year &&
      selectedMonth.month == currentMonth.month;

  BudgetEntity? get selectedBudget =>
      budgetCache[buildBudgetMonthKey(selectedMonth)];
}
