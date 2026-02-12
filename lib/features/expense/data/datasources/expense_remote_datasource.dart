import 'package:moamoa/features/expense/data/models/expense_model.dart';
import 'package:moamoa/features/expense/data/models/expense_list_response_model.dart';

/// Expense Remote DataSource 인터페이스
///
/// 백엔드 API와의 통신을 담당하는 추상화 계층입니다.
///
/// **주요 기능:**
/// - 지출 목록/상세 조회 API 호출
/// - 지출 생성/수정/삭제 API 호출
///
/// **사용 예시:**
/// ```dart
/// class ExpenseRepositoryImpl implements ExpenseRepository {
///   final ExpenseRemoteDataSource _dataSource;
///   ...
/// }
/// ```
abstract class ExpenseRemoteDataSource {
  Future<ExpenseListResponseModel> getExpenseList({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  });

  Future<ExpenseModel> createExpense({
    required ExpenseModel expense,
  });

  Future<ExpenseModel> getExpenseDetail({
    required String expenseId,
  });

  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required ExpenseModel expense,
  });

  Future<void> deleteExpense({
    required String expenseId,
  });
}
