import 'package:moneyflow/core/providers/core_providers.dart';
import 'package:moneyflow/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:moneyflow/features/expense/data/datasources/expense_remote_datasource_impl.dart';
import 'package:moneyflow/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';
import 'package:moneyflow/features/expense/domain/usecases/create_expense_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/get_expense_detail_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/get_expense_list_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/get_recent_expenses_usecase.dart';
import 'package:moneyflow/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_providers.g.dart';

// DataSource
@riverpod
ExpenseRemoteDataSource expenseRemoteDataSource(Ref ref) {
  return ExpenseRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// Repository
@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepositoryImpl(ref.read(expenseRemoteDataSourceProvider));
}

// UseCases
@riverpod
GetExpenseListUseCase getExpenseListUseCase(Ref ref) {
  return GetExpenseListUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
GetRecentExpensesUseCase getRecentExpensesUseCase(Ref ref) {
  return GetRecentExpensesUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
CreateExpenseUseCase createExpenseUseCase(Ref ref) {
  return CreateExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
UpdateExpenseUseCase updateExpenseUseCase(Ref ref) {
  return UpdateExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
DeleteExpenseUseCase deleteExpenseUseCase(Ref ref) {
  return DeleteExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
GetExpenseDetailUseCase getExpenseDetailUseCase(Ref ref) {
  return GetExpenseDetailUseCase(ref.read(expenseRepositoryProvider));
}
