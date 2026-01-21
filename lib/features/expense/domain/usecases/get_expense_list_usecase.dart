import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

class GetExpenseListUseCase {
  final ExpenseRepository _repository;

  GetExpenseListUseCase(this._repository);

  Future<List<Expense>> call({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    return await _repository.getExpenseList(
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
  }
}
