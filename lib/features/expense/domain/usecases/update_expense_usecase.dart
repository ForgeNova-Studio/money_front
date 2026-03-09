import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

/// 지출 수정 UseCase
///
/// 기존 지출 내역을 수정하는 비즈니스 로직을 처리합니다.
///
/// **주요 기능:**
/// - [ExpenseRepository]를 통해 기존 지출 정보 업데이트
///
/// **주요 파라미터:**
/// - [expenseId]: 수정할 지출의 고유 ID
/// - [expense]: 수정된 정보가 담긴 지출 객체
///
/// **사용 예시:**
/// ```dart
/// await updateExpenseUseCase(
///   expenseId: 'exp_123',
///   expense: updatedExpense,
/// );
/// ```
class UpdateExpenseUseCase {
  final ExpenseRepository _repository;

  UpdateExpenseUseCase(this._repository);

  Future<Expense> call({
    required String expenseId,
    required Expense expense,
  }) async {
    return await _repository.updateExpense(
      expenseId: expenseId,
      expense: expense,
    );
  }
}
