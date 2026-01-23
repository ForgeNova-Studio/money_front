import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 월간 예산 조회 UseCase
class GetMonthlyBudgetUseCase {
  final BudgetRepository _repository;

  GetMonthlyBudgetUseCase(this._repository);

  Future<BudgetEntity?> call({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    return await _repository.getMonthlyBudget(
      year: year,
      month: month,
      accountBookId: accountBookId,
    );
  }
}
