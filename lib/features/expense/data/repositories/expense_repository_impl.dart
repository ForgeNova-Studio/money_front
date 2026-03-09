import 'package:moamoa/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:moamoa/features/expense/data/models/expense_model.dart';
import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/repositories/expense_repository.dart';
import 'package:moamoa/features/common/utils/transaction_repository_utils.dart';

/// Expense Repository 구현체
///
/// [ExpenseRepository] 인터페이스를 구현하며, 데이터 소스([ExpenseRemoteDataSource])와 도메인 계층(UseCase)을 연결합니다.
/// 데이터 소스에서 가져온 Model을 Entity로 변환하여 반환합니다.
///
/// **주요 기능:**
/// - Remote Data Source 호출
/// - 데이터 변환 (Model -> Entity, Entity -> Model)
///
/// **사용 예시:**
/// ```dart
/// final repository = ExpenseRepositoryImpl(remoteDataSource);
/// ```
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Expense>> getExpenseList({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    final response = await _remoteDataSource.getExpenseList(
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
    return mapModelsToEntities(response.expenses, (model) => model.toEntity());
  }

  @override
  Future<Expense> createExpense({required Expense expense}) async {
    return mapEntityRoundTrip(
      entity: expense,
      toModel: ExpenseModel.fromEntity,
      request: (model) => _remoteDataSource.createExpense(expense: model),
      toEntity: (model) => model.toEntity(),
    );
  }

  @override
  Future<Expense> getExpenseDetail({required String expenseId}) async {
    return mapModelToEntity(
      request: _remoteDataSource.getExpenseDetail(expenseId: expenseId),
      toEntity: (model) => model.toEntity(),
    );
  }

  @override
  Future<Expense> updateExpense({
    required String expenseId,
    required Expense expense,
  }) async {
    return mapEntityRoundTrip(
      entity: expense,
      toModel: ExpenseModel.fromEntity,
      request: (model) => _remoteDataSource.updateExpense(
        expenseId: expenseId,
        expense: model,
      ),
      toEntity: (model) => model.toEntity(),
    );
  }

  @override
  Future<void> deleteExpense({required String expenseId}) async {
    await _remoteDataSource.deleteExpense(expenseId: expenseId);
  }
}
