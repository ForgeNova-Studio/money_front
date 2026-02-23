// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetRemoteDataSource)
const budgetRemoteDataSourceProvider = BudgetRemoteDataSourceProvider._();

final class BudgetRemoteDataSourceProvider extends $FunctionalProvider<
    BudgetRemoteDataSource,
    BudgetRemoteDataSource,
    BudgetRemoteDataSource> with $Provider<BudgetRemoteDataSource> {
  const BudgetRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'budgetRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$budgetRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BudgetRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetRemoteDataSource create(Ref ref) {
    return budgetRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetRemoteDataSource>(value),
    );
  }
}

String _$budgetRemoteDataSourceHash() =>
    r'5844adf493a75fc1097b9aeea8c17012bbd411b2';

@ProviderFor(budgetRepository)
const budgetRepositoryProvider = BudgetRepositoryProvider._();

final class BudgetRepositoryProvider extends $FunctionalProvider<
    BudgetRepository,
    BudgetRepository,
    BudgetRepository> with $Provider<BudgetRepository> {
  const BudgetRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'budgetRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$budgetRepositoryHash();

  @$internal
  @override
  $ProviderElement<BudgetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetRepository create(Ref ref) {
    return budgetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetRepository>(value),
    );
  }
}

String _$budgetRepositoryHash() => r'd02a0e5eb48c689c30fdb688de7ca77f29e93667';
