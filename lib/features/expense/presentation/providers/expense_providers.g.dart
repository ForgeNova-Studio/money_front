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
    r'cd71f338f5a9a4fc84d0890754b041739ad0b222';

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

String _$expenseRepositoryHash() => r'dbb2fd91adc3ff09b46a37f56d08ae01cc83d7fc';

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
    r'0370f8b186ef15928c3382c0c1f4ec1d0a9de016';

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
    r'a66731406fe36d28af2281ee679bac21a0eecf89';

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
    r'a3443e52ece0fbf3c644b1aa8c18d36831f806d1';

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
    r'9855f34d50528983b81985cee8c17b937ed2f227';

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
    r'c4cdb8b4807a70e77d574ffdde2662f1be29022a';

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
    r'817325b5092330e39000cc792ef123c86f9aa753';
