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

class InitialBalanceSettingsState {
  const InitialBalanceSettingsState({
    required this.isLoading,
    required this.isSaving,
    required this.isNegative,
    this.currentTotalAssets,
    this.initialAmount,
    this.event,
  });

  factory InitialBalanceSettingsState.initial() {
    return const InitialBalanceSettingsState(
      isLoading: false,
      isSaving: false,
      isNegative: false,
    );
  }

  final bool isLoading;
  final bool isSaving;
  final bool isNegative;
  final double? currentTotalAssets;
  final int? initialAmount;
  final InitialBalanceSettingsEvent? event;

  static const _unset = Object();

  InitialBalanceSettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isNegative,
    Object? currentTotalAssets = _unset,
    Object? initialAmount = _unset,
    Object? event = _unset,
  }) {
    return InitialBalanceSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isNegative: isNegative ?? this.isNegative,
      currentTotalAssets: currentTotalAssets == _unset
          ? this.currentTotalAssets
          : currentTotalAssets as double?,
      initialAmount:
          initialAmount == _unset ? this.initialAmount : initialAmount as int?,
      event:
          event == _unset ? this.event : event as InitialBalanceSettingsEvent?,
    );
  }
}
