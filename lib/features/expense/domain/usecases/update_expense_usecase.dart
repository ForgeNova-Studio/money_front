import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository _repository;

  UpdateExpenseUseCase(this._repository);

  Future<Expense> call({
    required String expenseId,
    required Expense expense,
  }) async {
    return await _repository.updateExpense(
      expenseId: expenseId,
      expense: expense,
    );
  }
}
