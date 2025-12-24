// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IncomeViewModel)
const incomeViewModelProvider = IncomeViewModelProvider._();

final class IncomeViewModelProvider
    extends $NotifierProvider<IncomeViewModel, IncomeState> {
  const IncomeViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'incomeViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$incomeViewModelHash();

  @$internal
  @override
  IncomeViewModel create() => IncomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncomeState>(value),
    );
  }
}

String _$incomeViewModelHash() => r'5e6e46c313c53e6e5fef8268e17f52ed4b4a87aa';

abstract class _$IncomeViewModel extends $Notifier<IncomeState> {
  IncomeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IncomeState, IncomeState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<IncomeState, IncomeState>, IncomeState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
