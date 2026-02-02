import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource.dart';
import 'package:moamoa/features/budget/data/models/budget_models.dart';

/// Budget Remote Data Source 구현체
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final Dio dio;

  BudgetRemoteDataSourceImpl({required this.dio});

  @override
  Future<BudgetResponseModel> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.budgets,
        data: {
          'accountBookId': accountBookId,
          'year': year,
          'month': month,
          'targetAmount': targetAmount,
        },
      );

      return BudgetResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[BudgetRemoteDataSource] createOrUpdateBudget error: $e');
        debugPrint('[BudgetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<BudgetResponseModel?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'year': year,
        'month': month,
      };
      if (accountBookId != null) {
        queryParams['accountBookId'] = accountBookId;
      }

      final response = await dio.get(
        ApiConstants.budgets,
        queryParameters: queryParams,
      );

      /// response 바디가 비어있거나 Map이 아니면 -> 예산 없음으로 처리
      /// 즉, 서버가 200 + empty 로 내려주면 프론트에서 null 반환
      if (response.data == null || response.data == '' || response.data is! Map<String, dynamic>) {
        return null;
      }

      return BudgetResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[BudgetRemoteDataSource] getMonthlyBudget error: $e');
        debugPrint('[BudgetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<AssetResponseModel> getTotalAssets({
    String? accountBookId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (accountBookId != null) {
        queryParams['accountBookId'] = accountBookId;
      }

      final response = await dio.get(
        ApiConstants.statisticsAssets,
        queryParameters: queryParams,
      );

      return AssetResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[BudgetRemoteDataSource] getTotalAssets error: $e');
        debugPrint('[BudgetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) async {
    try {
      await dio.patch(
        '${ApiConstants.accountBooks}/$accountBookId/initial-balance',
        data: {
          'initialBalance': initialBalance,
        },
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[BudgetRemoteDataSource] updateInitialBalance error: $e');
        debugPrint('[BudgetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
}
