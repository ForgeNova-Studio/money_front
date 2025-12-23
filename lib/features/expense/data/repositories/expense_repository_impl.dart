import 'package:moneyflow/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:moneyflow/features/expense/data/models/expense_model.dart';
import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Expense>> getExpenseList({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    final response = await _remoteDataSource.getExpenseList(
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
    return response.expenses.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Expense> createExpense({required Expense expense}) async {
    final model = ExpenseModel.fromEntity(expense);
    final response = await _remoteDataSource.createExpense(expense: model);
    return response.toEntity();
  }

  @override
  Future<Expense> getExpenseDetail({required String expenseId}) async {
    final model = await _remoteDataSource.getExpenseDetail(expenseId: expenseId);
    return model.toEntity();
  }

  @override
  Future<Expense> updateExpense({
    required String expenseId,
    required Expense expense,
  }) async {
    final model = ExpenseModel.fromEntity(expense);
    final response = await _remoteDataSource.updateExpense(
      expenseId: expenseId,
      expense: model,
    );
    return response.toEntity();
  }

  @override
  Future<void> deleteExpense({required String expenseId}) async {
    await _remoteDataSource.deleteExpense(expenseId: expenseId);
  }
}
