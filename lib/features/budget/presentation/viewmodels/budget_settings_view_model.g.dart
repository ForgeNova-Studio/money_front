// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetSettingsViewModel)
const budgetSettingsViewModelProvider = BudgetSettingsViewModelProvider._();

final class BudgetSettingsViewModelProvider
    extends $NotifierProvider<BudgetSettingsViewModel, BudgetSettingsState> {
  const BudgetSettingsViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'budgetSettingsViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$budgetSettingsViewModelHash();

  @$internal
  @override
  BudgetSettingsViewModel create() => BudgetSettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetSettingsState>(value),
    );
  }
}

String _$budgetSettingsViewModelHash() =>
    r'a690932f248d1c445eb1469532abccbdfdf4d596';

abstract class _$BudgetSettingsViewModel
    extends $Notifier<BudgetSettingsState> {
  BudgetSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BudgetSettingsState, BudgetSettingsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BudgetSettingsState, BudgetSettingsState>,
        BudgetSettingsState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
