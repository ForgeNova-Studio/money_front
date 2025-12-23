import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';

class GetExpenseDetailUseCase {
  final ExpenseRepository _repository;

  GetExpenseDetailUseCase(this._repository);

  Future<Expense> call(String expenseId) async {
    return await _repository.getExpenseDetail(expenseId: expenseId);
  }
}
