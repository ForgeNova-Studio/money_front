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

String _$expenseViewModelHash() => r'4b6a89fc6f3021d3a15cf8ad2de13218b111d398';

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
