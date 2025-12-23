// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expenseRemoteDataSource)
const expenseRemoteDataSourceProvider = ExpenseRemoteDataSourceProvider._();

final class ExpenseRemoteDataSourceProvider extends $FunctionalProvider<
    ExpenseRemoteDataSource,
    ExpenseRemoteDataSource,
    ExpenseRemoteDataSource> with $Provider<ExpenseRemoteDataSource> {
  const ExpenseRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExpenseRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExpenseRemoteDataSource create(Ref ref) {
    return expenseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRemoteDataSource>(value),
    );
  }
}

String _$expenseRemoteDataSourceHash() =>
    r'1a5fa4f00e12120a6c09e519b2963761215633d8';

@ProviderFor(expenseRepository)
const expenseRepositoryProvider = ExpenseRepositoryProvider._();

final class ExpenseRepositoryProvider extends $FunctionalProvider<
    ExpenseRepository,
    ExpenseRepository,
    ExpenseRepository> with $Provider<ExpenseRepository> {
  const ExpenseRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExpenseRepository create(Ref ref) {
    return expenseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRepository>(value),
    );
  }
}

String _$expenseRepositoryHash() => r'93d8988a6bf7e5421deb1cc92abdf733de1df073';

@ProviderFor(getExpenseListUseCase)
const getExpenseListUseCaseProvider = GetExpenseListUseCaseProvider._();

final class GetExpenseListUseCaseProvider extends $FunctionalProvider<
    GetExpenseListUseCase,
    GetExpenseListUseCase,
    GetExpenseListUseCase> with $Provider<GetExpenseListUseCase> {
  const GetExpenseListUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getExpenseListUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getExpenseListUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetExpenseListUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetExpenseListUseCase create(Ref ref) {
    return getExpenseListUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetExpenseListUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetExpenseListUseCase>(value),
    );
  }
}

String _$getExpenseListUseCaseHash() =>
    r'7c6dff2322aeda6a80c6048ab77fc72347449558';

@ProviderFor(getRecentExpensesUseCase)
const getRecentExpensesUseCaseProvider = GetRecentExpensesUseCaseProvider._();

final class GetRecentExpensesUseCaseProvider extends $FunctionalProvider<
    GetRecentExpensesUseCase,
    GetRecentExpensesUseCase,
    GetRecentExpensesUseCase> with $Provider<GetRecentExpensesUseCase> {
  const GetRecentExpensesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getRecentExpensesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getRecentExpensesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRecentExpensesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetRecentExpensesUseCase create(Ref ref) {
    return getRecentExpensesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRecentExpensesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRecentExpensesUseCase>(value),
    );
  }
}

String _$getRecentExpensesUseCaseHash() =>
    r'dae7c903a1316b09d504c1bb685a7df656f94f0f';

@ProviderFor(createExpenseUseCase)
const createExpenseUseCaseProvider = CreateExpenseUseCaseProvider._();

final class CreateExpenseUseCaseProvider extends $FunctionalProvider<
    CreateExpenseUseCase,
    CreateExpenseUseCase,
    CreateExpenseUseCase> with $Provider<CreateExpenseUseCase> {
  const CreateExpenseUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'createExpenseUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$createExpenseUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateExpenseUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateExpenseUseCase create(Ref ref) {
    return createExpenseUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateExpenseUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateExpenseUseCase>(value),
    );
  }
}

String _$createExpenseUseCaseHash() =>
    r'29208d4a4289db081f7a73e7dcd5ba97d00f1e80';

@ProviderFor(updateExpenseUseCase)
const updateExpenseUseCaseProvider = UpdateExpenseUseCaseProvider._();

final class UpdateExpenseUseCaseProvider extends $FunctionalProvider<
    UpdateExpenseUseCase,
    UpdateExpenseUseCase,
    UpdateExpenseUseCase> with $Provider<UpdateExpenseUseCase> {
  const UpdateExpenseUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateExpenseUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateExpenseUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateExpenseUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateExpenseUseCase create(Ref ref) {
    return updateExpenseUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateExpenseUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateExpenseUseCase>(value),
    );
  }
}

String _$updateExpenseUseCaseHash() =>
    r'14fa09bd041cc6065ceb5a6595c67a579b8b8518';

@ProviderFor(deleteExpenseUseCase)
const deleteExpenseUseCaseProvider = DeleteExpenseUseCaseProvider._();

final class DeleteExpenseUseCaseProvider extends $FunctionalProvider<
    DeleteExpenseUseCase,
    DeleteExpenseUseCase,
    DeleteExpenseUseCase> with $Provider<DeleteExpenseUseCase> {
  const DeleteExpenseUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deleteExpenseUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deleteExpenseUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteExpenseUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteExpenseUseCase create(Ref ref) {
    return deleteExpenseUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteExpenseUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteExpenseUseCase>(value),
    );
  }
}

String _$deleteExpenseUseCaseHash() =>
    r'47abc92f4cb90d3ba642c0fca787901566e7add1';

@ProviderFor(getExpenseDetailUseCase)
const getExpenseDetailUseCaseProvider = GetExpenseDetailUseCaseProvider._();

final class GetExpenseDetailUseCaseProvider extends $FunctionalProvider<
    GetExpenseDetailUseCase,
    GetExpenseDetailUseCase,
    GetExpenseDetailUseCase> with $Provider<GetExpenseDetailUseCase> {
  const GetExpenseDetailUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getExpenseDetailUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getExpenseDetailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetExpenseDetailUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetExpenseDetailUseCase create(Ref ref) {
    return getExpenseDetailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetExpenseDetailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetExpenseDetailUseCase>(value),
    );
  }
}

String _$getExpenseDetailUseCaseHash() =>
    r'c474b5c9a1970c999043fb51da1f939e56962185';
