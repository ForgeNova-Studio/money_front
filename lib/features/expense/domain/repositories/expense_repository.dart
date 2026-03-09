// entities
import 'package:moamoa/features/expense/domain/entities/expense.dart';

/// Expense Repository 인터페이스
///
/// 지출 도메인의 비즈니스 로직 처리를 위한 데이터 접근 계층의 추상 인터페이스입니다.
/// 데이터 소스(Remote, Local)의 구체적인 구현 내용을 숨기고, UseCase에 필요한 데이터 조작 기능만을 노출합니다.
///
/// **주요 기능:**
/// - 지출 목록 조회 (기간별, 카테고리별 필터링)
/// - 지출 상세 조회
/// - 지출 생성, 수정, 삭제 (CRUD)
///
/// **사용 예시:**
/// ```dart
/// class GetExpenseListUseCase {
///   final ExpenseRepository _repository;
///
///   GetExpenseListUseCase(this._repository);
///
///   Future<List<Expense>> call() {
///     return _repository.getExpenseList(...);
///   }
/// }
/// ```
abstract class ExpenseRepository {
  /// 지출 목록 조회
  /// [startDate] 조회 시작일
  /// [endDate] 조회 종료일
  /// [category] 카테고리 필터
  Future<List<Expense>> getExpenseList({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  });

  /// 지출 생성
  Future<Expense> createExpense({
    required Expense expense,
  });

  /// 지출 상세 조회
  Future<Expense> getExpenseDetail({
    required String expenseId,
  });

  /// 지출 수정
  Future<Expense> updateExpense({
    required String expenseId,
    required Expense expense,
  });

  /// 지출 삭제
  Future<void> deleteExpense({
    required String expenseId,
  });
}
