// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Terms Remote Data Source Provider

@ProviderFor(termsRemoteDataSource)
const termsRemoteDataSourceProvider = TermsRemoteDataSourceProvider._();

/// Terms Remote Data Source Provider

final class TermsRemoteDataSourceProvider extends $FunctionalProvider<
    TermsRemoteDataSource,
    TermsRemoteDataSource,
    TermsRemoteDataSource> with $Provider<TermsRemoteDataSource> {
  /// Terms Remote Data Source Provider
  const TermsRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'termsRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$termsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<TermsRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TermsRemoteDataSource create(Ref ref) {
    return termsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TermsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TermsRemoteDataSource>(value),
    );
  }
}

String _$termsRemoteDataSourceHash() =>
    r'5d3b6a6e46c83d1c18271afba38d9a8d0adc949e';

/// 현재 유효한 약관 목록 조회 Provider

@ProviderFor(getActiveTerms)
const getActiveTermsProvider = GetActiveTermsProvider._();

/// 현재 유효한 약관 목록 조회 Provider

final class GetActiveTermsProvider extends $FunctionalProvider<
        AsyncValue<List<TermsDocumentModel>>,
        List<TermsDocumentModel>,
        FutureOr<List<TermsDocumentModel>>>
    with
        $FutureModifier<List<TermsDocumentModel>>,
        $FutureProvider<List<TermsDocumentModel>> {
  /// 현재 유효한 약관 목록 조회 Provider
  const GetActiveTermsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getActiveTermsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getActiveTermsHash();

  @$internal
  @override
  $FutureProviderElement<List<TermsDocumentModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<TermsDocumentModel>> create(Ref ref) {
    return getActiveTerms(ref);
  }
}

String _$getActiveTermsHash() => r'ad32d359b1efe77d764d8cd4b2d6379f9dad86ca';

/// 내 약관 동의 이력 조회 Provider

@ProviderFor(getMyAgreements)
const getMyAgreementsProvider = GetMyAgreementsProvider._();

/// 내 약관 동의 이력 조회 Provider

final class GetMyAgreementsProvider extends $FunctionalProvider<
        AsyncValue<List<UserAgreementModel>>,
        List<UserAgreementModel>,
        FutureOr<List<UserAgreementModel>>>
    with
        $FutureModifier<List<UserAgreementModel>>,
        $FutureProvider<List<UserAgreementModel>> {
  /// 내 약관 동의 이력 조회 Provider
  const GetMyAgreementsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getMyAgreementsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getMyAgreementsHash();

  @$internal
  @override
  $FutureProviderElement<List<UserAgreementModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserAgreementModel>> create(Ref ref) {
    return getMyAgreements(ref);
  }
}

String _$getMyAgreementsHash() => r'48c8ae3a240a79fb848ca77345b6e4166325f2d1';
