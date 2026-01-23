import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 초기 잔액 수정 UseCase
class UpdateInitialBalanceUseCase {
  final BudgetRepository _repository;

  UpdateInitialBalanceUseCase(this._repository);

  Future<void> call({
    required String accountBookId,
    required double initialBalance,
  }) async {
    return await _repository.updateInitialBalance(
      accountBookId: accountBookId,
      initialBalance: initialBalance,
    );
  }
}
