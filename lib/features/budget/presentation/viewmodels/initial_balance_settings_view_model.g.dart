// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_balance_settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InitialBalanceSettingsViewModel)
const initialBalanceSettingsViewModelProvider =
    InitialBalanceSettingsViewModelProvider._();

final class InitialBalanceSettingsViewModelProvider extends $NotifierProvider<
    InitialBalanceSettingsViewModel, InitialBalanceSettingsState> {
  const InitialBalanceSettingsViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initialBalanceSettingsViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initialBalanceSettingsViewModelHash();

  @$internal
  @override
  InitialBalanceSettingsViewModel create() => InitialBalanceSettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitialBalanceSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitialBalanceSettingsState>(value),
    );
  }
}

String _$initialBalanceSettingsViewModelHash() =>
    r'c4dfd3e6edaface23760e2e1f5ee57bb1209321d';

abstract class _$InitialBalanceSettingsViewModel
    extends $Notifier<InitialBalanceSettingsState> {
  InitialBalanceSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<InitialBalanceSettingsState, InitialBalanceSettingsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<InitialBalanceSettingsState, InitialBalanceSettingsState>,
        InitialBalanceSettingsState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
