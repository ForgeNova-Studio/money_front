// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_overlay_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppScrimActive)
const appScrimActiveProvider = AppScrimActiveProvider._();

final class AppScrimActiveProvider
    extends $NotifierProvider<AppScrimActive, bool> {
  const AppScrimActiveProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appScrimActiveProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appScrimActiveHash();

  @$internal
  @override
  AppScrimActive create() => AppScrimActive();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appScrimActiveHash() => r'f36ffd646c7435dfe626c46f767b9cdc01076b89';

abstract class _$AppScrimActive extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
