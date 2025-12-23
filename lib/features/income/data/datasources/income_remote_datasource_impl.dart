// packages
import 'package:dio/dio.dart';

// core
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';

// models
import 'package:moneyflow/features/income/data/models/income_model.dart';

// datasources
import 'package:moneyflow/features/income/data/datasources/income_remote_datasource.dart';

/// Income Remote Data Source 구현체
///
/// Dio를 사용한 API 통신 구현
class IncomeRemoteDataSourceImpl implements IncomeRemoteDataSource {
  final Dio dio;

  IncomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<IncomeModel>> getIncomeList({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (source != null) {
        queryParams['source'] = source;
      }

      final response = await dio.get(
        ApiConstants.incomes,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => IncomeModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<IncomeModel> createIncome({required IncomeModel income}) async {
    try {
      final response = await dio.post(
        ApiConstants.incomes,
        data: income.toJson(),
      );

      return IncomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<IncomeModel> getIncomeDetail({required String incomeId}) async {
    try {
      final response = await dio.get(
        ApiConstants.incomeById(incomeId),
      );

      return IncomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<IncomeModel> updateIncome({
    required String incomeId,
    required IncomeModel income,
  }) async {
    try {
      final response = await dio.put(
        ApiConstants.incomeById(incomeId),
        data: income.toJson(),
      );

      return IncomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> deleteIncome({required String incomeId}) async {
    try {
      await dio.delete(
        ApiConstants.incomeById(incomeId),
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
