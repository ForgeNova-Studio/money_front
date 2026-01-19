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

@ProviderFor(HomeRefreshError)
const homeRefreshErrorProvider = HomeRefreshErrorProvider._();

final class HomeRefreshErrorProvider
    extends $NotifierProvider<HomeRefreshError, String?> {
  const HomeRefreshErrorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeRefreshErrorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeRefreshErrorHash();

  @$internal
  @override
  HomeRefreshError create() => HomeRefreshError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$homeRefreshErrorHash() => r'c41473780612d2f8e8371c645911c7016ef15d72';

abstract class _$HomeRefreshError extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

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

String _$homeRepositoryHash() => r'5a13bdee285d28d83d0de1c429a4561cb7eb55c0';

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
