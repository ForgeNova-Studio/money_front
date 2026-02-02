// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statisticsRemoteDataSource)
const statisticsRemoteDataSourceProvider =
    StatisticsRemoteDataSourceProvider._();

final class StatisticsRemoteDataSourceProvider extends $FunctionalProvider<
    StatisticsRemoteDataSource,
    StatisticsRemoteDataSource,
    StatisticsRemoteDataSource> with $Provider<StatisticsRemoteDataSource> {
  const StatisticsRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'statisticsRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$statisticsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<StatisticsRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatisticsRemoteDataSource create(Ref ref) {
    return statisticsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsRemoteDataSource>(value),
    );
  }
}

String _$statisticsRemoteDataSourceHash() =>
    r'adff96c5003af11ea44e0844741802b47eb683b0';

@ProviderFor(statisticsRepository)
const statisticsRepositoryProvider = StatisticsRepositoryProvider._();

final class StatisticsRepositoryProvider extends $FunctionalProvider<
    StatisticsRepository,
    StatisticsRepository,
    StatisticsRepository> with $Provider<StatisticsRepository> {
  const StatisticsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'statisticsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$statisticsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StatisticsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatisticsRepository create(Ref ref) {
    return statisticsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsRepository>(value),
    );
  }
}

String _$statisticsRepositoryHash() =>
    r'7627e8439131a60f7177b45b6f316dcda0443c30';

@ProviderFor(getMonthlyStatisticsUseCase)
const getMonthlyStatisticsUseCaseProvider =
    GetMonthlyStatisticsUseCaseProvider._();

final class GetMonthlyStatisticsUseCaseProvider extends $FunctionalProvider<
    GetMonthlyStatisticsUseCase,
    GetMonthlyStatisticsUseCase,
    GetMonthlyStatisticsUseCase> with $Provider<GetMonthlyStatisticsUseCase> {
  const GetMonthlyStatisticsUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getMonthlyStatisticsUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getMonthlyStatisticsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMonthlyStatisticsUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetMonthlyStatisticsUseCase create(Ref ref) {
    return getMonthlyStatisticsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMonthlyStatisticsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMonthlyStatisticsUseCase>(value),
    );
  }
}

String _$getMonthlyStatisticsUseCaseHash() =>
    r'3ee92875c45c07b6b138c1fc2ed51084189897b9';
