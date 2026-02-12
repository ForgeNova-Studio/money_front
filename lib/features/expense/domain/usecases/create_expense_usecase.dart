import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

/// 지출 생성 UseCase
///
/// 새로운 지출 내역을 생성하는 비즈니스 로직을 캡슐화합니다.
///
/// **주요 기능:**
/// - [ExpenseRepository]를 통해 지출 데이터 저장
///
/// **주요 파라미터:**
/// - [expense]: 생성할 지출 정보 객체
///
/// **사용 예시:**
/// ```dart
/// await createExpenseUseCase(
///   Expense(amount: 10000, ...),
/// );
/// ```
class CreateExpenseUseCase {
  final ExpenseRepository _repository;

  CreateExpenseUseCase(this._repository);

  Future<Expense> call(Expense expense) async {
    return await _repository.createExpense(expense: expense);
  }
}
