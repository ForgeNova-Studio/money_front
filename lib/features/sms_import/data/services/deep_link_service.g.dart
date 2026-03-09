// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 딥링크 서비스
/// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리

@ProviderFor(DeepLinkService)
const deepLinkServiceProvider = DeepLinkServiceProvider._();

/// 딥링크 서비스
/// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리
final class DeepLinkServiceProvider
    extends $NotifierProvider<DeepLinkService, DeepLinkData?> {
  /// 딥링크 서비스
  /// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리
  const DeepLinkServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deepLinkServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deepLinkServiceHash();

  @$internal
  @override
  DeepLinkService create() => DeepLinkService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkData?>(value),
    );
  }
}

String _$deepLinkServiceHash() => r'f35e796e722fa6ab27ee9bc1d97d832934707ee2';

/// 딥링크 서비스
/// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리

abstract class _$DeepLinkService extends $Notifier<DeepLinkData?> {
  DeepLinkData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DeepLinkData?, DeepLinkData?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DeepLinkData?, DeepLinkData?>,
        DeepLinkData?,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
