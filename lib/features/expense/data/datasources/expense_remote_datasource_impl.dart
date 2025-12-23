import 'package:dio/dio.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:moneyflow/features/expense/data/models/expense_list_response_model.dart';
import 'package:moneyflow/features/expense/data/models/expense_model.dart';

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
