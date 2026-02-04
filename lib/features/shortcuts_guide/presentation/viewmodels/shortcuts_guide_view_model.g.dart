// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcuts_guide_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShortcutsGuideViewModel)
const shortcutsGuideViewModelProvider = ShortcutsGuideViewModelProvider._();

final class ShortcutsGuideViewModelProvider
    extends $NotifierProvider<ShortcutsGuideViewModel, ShortcutsGuideState> {
  const ShortcutsGuideViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'shortcutsGuideViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$shortcutsGuideViewModelHash();

  @$internal
  @override
  ShortcutsGuideViewModel create() => ShortcutsGuideViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShortcutsGuideState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShortcutsGuideState>(value),
    );
  }
}

String _$shortcutsGuideViewModelHash() =>
    r'a6fd18d4169133aea8ec3eea106d046e8bc69e83';

abstract class _$ShortcutsGuideViewModel
    extends $Notifier<ShortcutsGuideState> {
  ShortcutsGuideState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ShortcutsGuideState, ShortcutsGuideState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ShortcutsGuideState, ShortcutsGuideState>,
        ShortcutsGuideState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
