import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 예산 생성/수정 UseCase
class CreateOrUpdateBudgetUseCase {
  final BudgetRepository _repository;

  CreateOrUpdateBudgetUseCase(this._repository);

  Future<BudgetEntity> call({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
    return await _repository.createOrUpdateBudget(
      accountBookId: accountBookId,
      year: year,
      month: month,
      targetAmount: targetAmount,
    );
  }
}
