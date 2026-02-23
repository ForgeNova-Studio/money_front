import 'package:freezed_annotation/freezed_annotation.dart';

part 'initial_balance_settings_state.freezed.dart';

/// 잔액 설정 화면 이벤트를 반환하는 클래스
/// - [InitialBalanceSettingsShowError] : 에러 발생시 이벤트
/// - [InitialBalanceSettingsPopWithToast] : 화면을 종료하고 토스트 메시지를 표시한다.
sealed class InitialBalanceSettingsEvent {
  const InitialBalanceSettingsEvent();
}

class InitialBalanceSettingsShowError extends InitialBalanceSettingsEvent {
  const InitialBalanceSettingsShowError(this.message);

  final String message;
}

class InitialBalanceSettingsPopWithToast extends InitialBalanceSettingsEvent {
  const InitialBalanceSettingsPopWithToast(this.message);

  final String message;
}

@freezed
sealed class InitialBalanceSettingsState with _$InitialBalanceSettingsState {
  const InitialBalanceSettingsState._();

  const factory InitialBalanceSettingsState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isNegative,
    double? currentTotalAssets,
    int? initialAmount,
    InitialBalanceSettingsEvent? event,
  }) = _InitialBalanceSettingsState;

  factory InitialBalanceSettingsState.initial() =>
      const InitialBalanceSettingsState();
}
