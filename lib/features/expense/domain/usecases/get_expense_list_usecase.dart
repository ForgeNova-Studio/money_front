import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';

/// 지출 목록 조회 UseCase
///
/// 지정된 기간 내의 지출 내역을 조회하는 비즈니스 로직을 캡슐화합니다.
/// 월간 가계부 조회, 리포트 생성 등에 활용됩니다.
///
/// **주요 기능:**
/// - 기간(시작~종료일) 기반 지출 목록 조회
/// - 카테고리별 필터링 옵션 제공
///
/// **주요 파라미터:**
/// - [startDate]: 조회 시작일
/// - [endDate]: 조회 종료일
/// - [category]: (Optional) 필터링할 카테고리 코드
///
/// **사용 예시:**
/// ```dart
/// final expenses = await getExpenseListUseCase(
///   startDate: DateTime(2023, 1, 1),
///   endDate: DateTime(2023, 1, 31),
///   category: 'FOOD',
/// );
/// ```
class GetExpenseListUseCase {
  final ExpenseRepository _repository;

  GetExpenseListUseCase(this._repository);

  Future<List<Expense>> call({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    return await _repository.getExpenseList(
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
  }
}
