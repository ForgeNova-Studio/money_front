import 'package:dio/dio.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
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
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };

      if (category != null) {
        queryParams['category'] = category;
      }

      final response = await dio.get(
        ApiConstants.expenses,
        queryParameters: queryParams,
      );

      return ExpenseListResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<ExpenseModel> createExpense({required ExpenseModel expense}) async {
    try {
      final response = await dio.post(
        ApiConstants.expenses,
        data: expense.toJson(),
      );
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<ExpenseModel> getExpenseDetail({required String expenseId}) async {
    try {
      final response = await dio.get(ApiConstants.expenseById(expenseId));
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required ExpenseModel expense,
  }) async {
    try {
      final response = await dio.put(
        ApiConstants.expenseById(expenseId),
        data: expense.toJson(),
      );
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> deleteExpense({required String expenseId}) async {
    try {
      await dio.delete(ApiConstants.expenseById(expenseId));
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
