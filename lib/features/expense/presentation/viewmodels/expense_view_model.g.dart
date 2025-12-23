// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseViewModel)
const expenseViewModelProvider = ExpenseViewModelProvider._();

final class ExpenseViewModelProvider
    extends $NotifierProvider<ExpenseViewModel, ExpenseState> {
  const ExpenseViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseViewModelHash();

  @$internal
  @override
  ExpenseViewModel create() => ExpenseViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseState>(value),
    );
  }
}

String _$expenseViewModelHash() => r'3a4ab381de02bca9aeeab2c5520cdb255a4f79a7';

abstract class _$ExpenseViewModel extends $Notifier<ExpenseState> {
  ExpenseState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExpenseState, ExpenseState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ExpenseState, ExpenseState>,
        ExpenseState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
