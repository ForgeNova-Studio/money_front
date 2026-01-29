// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 자산 관리 ViewModel

@ProviderFor(AssetViewModel)
const assetViewModelProvider = AssetViewModelProvider._();

/// 자산 관리 ViewModel
final class AssetViewModelProvider
    extends $NotifierProvider<AssetViewModel, AssetState> {
  /// 자산 관리 ViewModel
  const AssetViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'assetViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetViewModelHash();

  @$internal
  @override
  AssetViewModel create() => AssetViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetState>(value),
    );
  }
}

String _$assetViewModelHash() => r'd07880a6e6ba9c7ed52f0be8b9b0aa2dbc92193c';

/// 자산 관리 ViewModel

abstract class _$AssetViewModel extends $Notifier<AssetState> {
  AssetState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AssetState, AssetState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AssetState, AssetState>, AssetState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
