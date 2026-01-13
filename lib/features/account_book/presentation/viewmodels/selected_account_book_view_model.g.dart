// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_account_book_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedAccountBookViewModel)
const selectedAccountBookViewModelProvider =
    SelectedAccountBookViewModelProvider._();

final class SelectedAccountBookViewModelProvider extends $NotifierProvider<
    SelectedAccountBookViewModel, AsyncValue<String?>> {
  const SelectedAccountBookViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedAccountBookViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedAccountBookViewModelHash();

  @$internal
  @override
  SelectedAccountBookViewModel create() => SelectedAccountBookViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }
}

String _$selectedAccountBookViewModelHash() =>
    r'14e880154cb4b529fa193f0e3bcc807ba0fb6529';

abstract class _$SelectedAccountBookViewModel
    extends $Notifier<AsyncValue<String?>> {
  AsyncValue<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, AsyncValue<String?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String?>, AsyncValue<String?>>,
        AsyncValue<String?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
