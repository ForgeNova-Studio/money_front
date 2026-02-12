import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

/// 지출 삭제 UseCase
///
/// 특정 지출 내역을 삭제하는 비즈니스 로직을 처리합니다.
///
/// **주요 기능:**
/// - 지출 ID를 기반으로 데이터 삭제 요청
///
/// **주요 파라미터:**
/// - [expenseId]: 삭제할 지출의 고유 ID
///
/// **사용 예시:**
/// ```dart
/// await deleteExpenseUseCase('exp_12345');
/// ```
class DeleteExpenseUseCase {
  final ExpenseRepository _repository;

  DeleteExpenseUseCase(this._repository);

  Future<void> call(String expenseId) async {
    return await _repository.deleteExpense(expenseId: expenseId);
  }
}
