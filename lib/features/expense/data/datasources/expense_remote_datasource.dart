import 'package:moamoa/features/expense/data/models/expense_model.dart';
import 'package:moamoa/features/expense/data/models/expense_list_response_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<ExpenseListResponseModel> getExpenseList({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  });

  Future<ExpenseModel> createExpense({
    required ExpenseModel expense,
  });

  Future<ExpenseModel> getExpenseDetail({
    required String expenseId,
  });

  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required ExpenseModel expense,
  });

  Future<void> deleteExpense({
    required String expenseId,
  });
}
