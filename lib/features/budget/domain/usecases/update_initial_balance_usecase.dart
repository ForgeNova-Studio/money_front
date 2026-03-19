import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 초기 잔액 수정 UseCase
///
/// 사용자가 가계부의 기초 자산이 되는 초기 잔고(시작 금액)를 설정하거나 변경할 때 호출되는 유즈케이스입니다.
///
/// **Key Features:**
/// *   가계부 초기 자산 설정 및 수정
///
/// **Parameters:**
/// *   [accountBookId] - 대상 가계부의 고유 식별자
/// *   [initialBalance] - 새로 설정할 초기 잔고 금액 (양수 또는 음수 가능)
///
/// **Usage Example:**
/// ```dart
/// final updateInitialBalance = ref.read(updateInitialBalanceUseCaseProvider);
/// await updateInitialBalance(
///   accountBookId: 'account-123',
///   initialBalance: 1500000,
/// );
/// ```
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
