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
    extends $StreamNotifierProvider<DeepLinkService, DeepLinkData> {
  /// 딥링크 서비스
  /// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리
  const DeepLinkServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deepLinkServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deepLinkServiceHash();

  @$internal
  @override
  DeepLinkService create() => DeepLinkService();
}

String _$deepLinkServiceHash() => r'c88de764b2762189360cc90a112f7e132f14564f';

/// 딥링크 서비스
/// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리

abstract class _$DeepLinkService extends $StreamNotifier<DeepLinkData> {
  Stream<DeepLinkData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<DeepLinkData>, DeepLinkData>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<DeepLinkData>, DeepLinkData>,
        AsyncValue<DeepLinkData>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// 최신 딥링크 데이터 Provider (일회성 소비용)

@ProviderFor(PendingDeepLink)
const pendingDeepLinkProvider = PendingDeepLinkProvider._();

/// 최신 딥링크 데이터 Provider (일회성 소비용)
final class PendingDeepLinkProvider
    extends $NotifierProvider<PendingDeepLink, DeepLinkData?> {
  /// 최신 딥링크 데이터 Provider (일회성 소비용)
  const PendingDeepLinkProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pendingDeepLinkProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pendingDeepLinkHash();

  @$internal
  @override
  PendingDeepLink create() => PendingDeepLink();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkData?>(value),
    );
  }
}

String _$pendingDeepLinkHash() => r'63ae13af3fde46973af9babeef344279ceb9a56d';

/// 최신 딥링크 데이터 Provider (일회성 소비용)

abstract class _$PendingDeepLink extends $Notifier<DeepLinkData?> {
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
