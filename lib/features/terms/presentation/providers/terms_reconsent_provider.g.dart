// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_reconsent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 약관 재동의 ViewModel Provider

@ProviderFor(TermsReconsentViewModel)
const termsReconsentViewModelProvider = TermsReconsentViewModelProvider._();

/// 약관 재동의 ViewModel Provider
final class TermsReconsentViewModelProvider
    extends $NotifierProvider<TermsReconsentViewModel, TermsReconsentState> {
  /// 약관 재동의 ViewModel Provider
  const TermsReconsentViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'termsReconsentViewModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$termsReconsentViewModelHash();

  @$internal
  @override
  TermsReconsentViewModel create() => TermsReconsentViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TermsReconsentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TermsReconsentState>(value),
    );
  }
}

String _$termsReconsentViewModelHash() =>
    r'62c55f874215fa14fd15ef788f69c140f10d60f7';

/// 약관 재동의 ViewModel Provider

abstract class _$TermsReconsentViewModel
    extends $Notifier<TermsReconsentState> {
  TermsReconsentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TermsReconsentState, TermsReconsentState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TermsReconsentState, TermsReconsentState>,
        TermsReconsentState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// 약관 재동의 필요 여부 Provider
///
/// AppInitialization에서 설정된 값을 참조
/// 재동의 완료 시 false로 변경

@ProviderFor(TermsReconsentRequired)
const termsReconsentRequiredProvider = TermsReconsentRequiredProvider._();

/// 약관 재동의 필요 여부 Provider
///
/// AppInitialization에서 설정된 값을 참조
/// 재동의 완료 시 false로 변경
final class TermsReconsentRequiredProvider
    extends $NotifierProvider<TermsReconsentRequired, bool> {
  /// 약관 재동의 필요 여부 Provider
  ///
  /// AppInitialization에서 설정된 값을 참조
  /// 재동의 완료 시 false로 변경
  const TermsReconsentRequiredProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'termsReconsentRequiredProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$termsReconsentRequiredHash();

  @$internal
  @override
  TermsReconsentRequired create() => TermsReconsentRequired();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$termsReconsentRequiredHash() =>
    r'ee1f56ab5b7b9056bb6905a747714a064806c716';

/// 약관 재동의 필요 여부 Provider
///
/// AppInitialization에서 설정된 값을 참조
/// 재동의 완료 시 false로 변경

abstract class _$TermsReconsentRequired extends $Notifier<bool> {
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
