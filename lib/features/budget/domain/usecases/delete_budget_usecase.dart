import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 예산 삭제 UseCase
///
/// 사용자가 기존에 설정해둔 특정 월의 예산을 삭제할 때 호출되는 유즈케이스입니다.
/// 예산 삭제 요청을 도메인 리포지토리([BudgetRepository])에 전달하여 처리합니다.
///
/// **Key Features:**
/// *   특정 예산 항목 영구 삭제 지원
///
/// **Parameters:**
/// *   [budgetId] - 삭제하고자 하는 예산의 고유 식별자
///
/// **Usage Example:**
/// ```dart
/// final deleteBudget = ref.read(deleteBudgetUseCaseProvider);
/// await deleteBudget(budgetId: 'budget-123');
/// ```
class DeleteBudgetUseCase {
  DeleteBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<void> call({
    required String budgetId,
  }) {
    return _repository.deleteBudget(budgetId: budgetId);
  }
}
