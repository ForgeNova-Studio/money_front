import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

class DeleteBudgetUseCase {
  DeleteBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<void> call({
    required String budgetId,
  }) {
    return _repository.deleteBudget(budgetId: budgetId);
  }
}
