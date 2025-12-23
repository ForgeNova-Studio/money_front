import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository _repository;

  CreateExpenseUseCase(this._repository);

  Future<Expense> call(Expense expense) async {
    return await _repository.createExpense(expense: expense);
  }
}
