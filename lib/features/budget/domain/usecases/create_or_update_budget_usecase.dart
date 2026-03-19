import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 예산 생성/수정 UseCase
///
/// 사용자가 특정 월에 대한 새로운 예산을 설정하거나, 기존에 설정된 예산 금액을 수정할 때 호출되는 유즈케이스입니다.
/// 도메인 리포지토리([BudgetRepository])에 처리를 위임하여 데이터 계층의 원격 API와 통신합니다.
///
/// **Key Features:**
/// *   새로운 월간 예산 데이터 생성
/// *   기존 월간 예산 목표 금액 수정
///
/// **Parameters:**
/// *   [accountBookId] - 예산을 설정할 가계부의 고유 식별자
/// *   [year] - 예산을 설정할 대상 연도
/// *   [month] - 예산을 설정할 대상 월
/// *   [targetAmount] - 사용자가 설정한 목표 예산 금액
///
/// **Usage Example:**
/// ```dart
/// final createOrUpdateBudget = ref.read(createOrUpdateBudgetUseCaseProvider);
/// final updatedBudget = await createOrUpdateBudget(
///   accountBookId: 'account-123',
///   year: 2026,
///   month: 2,
///   targetAmount: 500000,
/// );
/// ```
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
