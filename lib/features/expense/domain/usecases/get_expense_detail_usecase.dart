import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

/// 지출 상세 조회 UseCase
///
/// 특정 지출의 상세 정보를 조회하는 비즈니스 로직을 수행합니다.
/// 수정 화면 진입 시 초기 데이터 로드 등에 사용됩니다.
///
/// **주요 기능:**
/// - 지출 ID로 단일 지출 건 상세 정보 조회
///
/// **주요 파라미터:**
/// - [expenseId]: 조회할 지출의 고유 ID
///
/// **사용 예시:**
/// ```dart
/// final expense = await getExpenseDetailUseCase('exp_12345');
/// ```
class GetExpenseDetailUseCase {
  final ExpenseRepository _repository;

  GetExpenseDetailUseCase(this._repository);

  Future<Expense> call(String expenseId) async {
    return await _repository.getExpenseDetail(expenseId: expenseId);
  }
}
