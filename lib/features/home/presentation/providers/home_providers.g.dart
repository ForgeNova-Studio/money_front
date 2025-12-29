// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeRemoteDataSource)
const homeRemoteDataSourceProvider = HomeRemoteDataSourceProvider._();

final class HomeRemoteDataSourceProvider extends $FunctionalProvider<
    HomeRemoteDataSource,
    HomeRemoteDataSource,
    HomeRemoteDataSource> with $Provider<HomeRemoteDataSource> {
  const HomeRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<HomeRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRemoteDataSource create(Ref ref) {
    return homeRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRemoteDataSource>(value),
    );
  }
}

String _$homeRemoteDataSourceHash() =>
    r'ebbd6560e7de2f1a548ba80347ca1f247fa2092c';

@ProviderFor(homeRepository)
const homeRepositoryProvider = HomeRepositoryProvider._();

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  const HomeRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'2e2746fa904c1b0476b47008dc448378da3dc5f6';

@ProviderFor(getHomeMonthlyDataUseCase)
const getHomeMonthlyDataUseCaseProvider = GetHomeMonthlyDataUseCaseProvider._();

final class GetHomeMonthlyDataUseCaseProvider extends $FunctionalProvider<
    GetHomeMonthlyDataUseCase,
    GetHomeMonthlyDataUseCase,
    GetHomeMonthlyDataUseCase> with $Provider<GetHomeMonthlyDataUseCase> {
  const GetHomeMonthlyDataUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getHomeMonthlyDataUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getHomeMonthlyDataUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetHomeMonthlyDataUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetHomeMonthlyDataUseCase create(Ref ref) {
    return getHomeMonthlyDataUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetHomeMonthlyDataUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetHomeMonthlyDataUseCase>(value),
    );
  }
}

String _$getHomeMonthlyDataUseCaseHash() =>
    r'74382202edde27d2ff9315787da5847df9315d55';
