import 'package:dio/dio.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/features/common/utils/transaction_remote_utils.dart';
import 'package:moamoa/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:moamoa/features/expense/data/models/expense_list_response_model.dart';
import 'package:moamoa/features/expense/data/models/expense_model.dart';

/// Expense Remote DataSource 구현체
///
/// [Dio]를 사용하여 실제 백엔드 API와 통신합니다.
///
/// **주요 기능:**
/// - [ExpenseRemoteDataSource] 인터페이스 구현
/// - API 요청 구성 및 전송
/// - 응답 데이터(JSON)를 [ExpenseModel]로 변환하여 반환
/// - [DioException] 발생 시 [ExceptionHandler]를 통한 예외 처리
///
/// **사용 예시:**
/// ```dart
/// final dataSource = ExpenseRemoteDataSourceImpl(dio: dioInstance);
/// ```
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final Dio dio;

  ExpenseRemoteDataSourceImpl({required this.dio});

  @override
  Future<ExpenseListResponseModel> getExpenseList({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    final queryParams = buildTransactionListQuery(
      startDate: startDate,
      endDate: endDate,
      filterKey: 'category',
      filterValue: category,
    );

    return requestModel(
      request: () => dio.get(
        ApiConstants.expenses,
        queryParameters: queryParams,
      ),
      fromJson: ExpenseListResponseModel.fromJson,
    );
  }

  @override
  Future<ExpenseModel> createExpense({required ExpenseModel expense}) async {
    return requestModel(
      request: () => dio.post(
        ApiConstants.expenses,
        data: expense.toJson(),
      ),
      fromJson: ExpenseModel.fromJson,
    );
  }

  @override
  Future<ExpenseModel> getExpenseDetail({required String expenseId}) async {
    return requestModel(
      request: () => dio.get(ApiConstants.expenseById(expenseId)),
      fromJson: ExpenseModel.fromJson,
    );
  }

  @override
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required ExpenseModel expense,
  }) async {
    return requestModel(
      request: () => dio.put(
        ApiConstants.expenseById(expenseId),
        data: expense.toJson(),
      ),
      fromJson: ExpenseModel.fromJson,
    );
  }

  @override
  Future<void> deleteExpense({required String expenseId}) async {
    await requestVoid(
      request: () => dio.delete(ApiConstants.expenseById(expenseId)),
    );
  }
}
