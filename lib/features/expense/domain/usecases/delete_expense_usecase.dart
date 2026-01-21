import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _repository;

  DeleteExpenseUseCase(this._repository);

  Future<void> call(String expenseId) async {
    return await _repository.deleteExpense(expenseId: expenseId);
  }
}
