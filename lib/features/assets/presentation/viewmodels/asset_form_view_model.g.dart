// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 자산 폼 ViewModel (추가/수정)

@ProviderFor(AssetFormViewModel)
const assetFormViewModelProvider = AssetFormViewModelProvider._();

/// 자산 폼 ViewModel (추가/수정)
final class AssetFormViewModelProvider
    extends $NotifierProvider<AssetFormViewModel, AssetFormState> {
  /// 자산 폼 ViewModel (추가/수정)
  const AssetFormViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'assetFormViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetFormViewModelHash();

  @$internal
  @override
  AssetFormViewModel create() => AssetFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetFormState>(value),
    );
  }
}

String _$assetFormViewModelHash() =>
    r'5e8730c57f5b409f76f65eeda4d4a552c5a65609';

/// 자산 폼 ViewModel (추가/수정)

abstract class _$AssetFormViewModel extends $Notifier<AssetFormState> {
  AssetFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AssetFormState, AssetFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AssetFormState, AssetFormState>,
        AssetFormState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
