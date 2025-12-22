import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/income/domain/entities/income.dart';

part 'income_state.freezed.dart';

@freezed
sealed class IncomeState with _$IncomeState {
  const factory IncomeState({
    @Default(false) bool isLoading,
    @Default([]) List<Income> incomes,
    @Default('') String errorMessage,
  }) = _IncomeState;

  const IncomeState._();

  /// 초기 상태
  factory IncomeState.initial() => const IncomeState();

  /// 로딩 상태
  factory IncomeState.loading() => const IncomeState(isLoading: true);

  /// 성공 상태
  factory IncomeState.success(List<Income> incomes) =>
      IncomeState(incomes: incomes);

  // 에러 상태
  factory IncomeState.error(String errorMessage) =>
      IncomeState(errorMessage: errorMessage);
}
