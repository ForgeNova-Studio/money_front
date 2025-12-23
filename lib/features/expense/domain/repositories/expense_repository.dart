// entities
import 'package:moneyflow/features/expense/domain/entities/expense.dart';

/// Expense Repository 인터페이스
///
/// 지출 관련 비즈니스 로직의 추상화 계층
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

  /// 최근 지출 내역 조회 (홈 화면용)
  Future<List<Expense>> getRecentExpenses();

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
