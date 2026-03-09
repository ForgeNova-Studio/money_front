// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentry_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sentry 서비스 Provider

@ProviderFor(sentryService)
const sentryServiceProvider = SentryServiceProvider._();

/// Sentry 서비스 Provider

final class SentryServiceProvider
    extends $FunctionalProvider<SentryService, SentryService, SentryService>
    with $Provider<SentryService> {
  /// Sentry 서비스 Provider
  const SentryServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sentryServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sentryServiceHash();

  @$internal
  @override
  $ProviderElement<SentryService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SentryService create(Ref ref) {
    return sentryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SentryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SentryService>(value),
    );
  }
}

String _$sentryServiceHash() => r'491feec713bf3f072b461376aba67747677d4b1f';
