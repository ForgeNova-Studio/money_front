// datasources
import 'package:moneyflow/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:moneyflow/features/expense/data/datasources/expense_remote_datasource_impl.dart';

// repositories
import 'package:moneyflow/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';

// usecases
import 'package:moneyflow/features/expense/domain/usecases/create_expense_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/get_expense_detail_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/get_expense_list_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/update_expense_usecase.dart';

// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// providers
import 'package:moneyflow/features/common/providers/core_providers.dart';

part 'expense_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================
@riverpod
ExpenseRemoteDataSource expenseRemoteDataSource(Ref ref) {
  return ExpenseRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================
@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepositoryImpl(ref.read(expenseRemoteDataSourceProvider));
}

// ============================================================================
// UseCase Providers
// ============================================================================
@riverpod
GetExpenseListUseCase getExpenseListUseCase(Ref ref) {
  return GetExpenseListUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
CreateExpenseUseCase createExpenseUseCase(Ref ref) {
  return CreateExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
GetExpenseDetailUseCase getExpenseDetailUseCase(Ref ref) {
  return GetExpenseDetailUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
UpdateExpenseUseCase updateExpenseUseCase(Ref ref) {
  return UpdateExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
DeleteExpenseUseCase deleteExpenseUseCase(Ref ref) {
  return DeleteExpenseUseCase(ref.read(expenseRepositoryProvider));
}
