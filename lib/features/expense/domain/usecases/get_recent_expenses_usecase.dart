import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';

class GetRecentExpensesUseCase {
  final ExpenseRepository _repository;

  GetRecentExpensesUseCase(this._repository);

  Future<List<Expense>> call() async {
    return await _repository.getRecentExpenses();
  }
}
