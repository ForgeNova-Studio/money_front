// packages
import 'package:dio/dio.dart';

// core
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';

import 'package:moamoa/features/income/data/models/income_list_response_model.dart';
// models
import 'package:moamoa/features/income/data/models/income_model.dart';

// datasources
import 'package:moamoa/features/income/data/datasources/income_remote_datasource.dart';

/// 수입 원격 데이터 소스 구현체
///
/// Dio 클라이언트를 사용하여 실제 API 호출을 수행합니다.
/// [ExceptionHandler]를 통해 DioException을 공통 예외로 변환하여 처리합니다.
class IncomeRemoteDataSourceImpl implements IncomeRemoteDataSource {
  final Dio dio;

  IncomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<IncomeListResponseModel> getIncomeList({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };

      if (source != null) {
        queryParams['source'] = source;
      }

      final response = await dio.get(
        ApiConstants.incomes,
        queryParameters: queryParams,
      );

      return IncomeListResponseModel.fromJson(response.data);
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
