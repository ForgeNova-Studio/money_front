import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource.dart';
import 'package:moamoa/features/budget/data/models/budget_models.dart';

/// Budget Remote Data Source 구현체
///
/// 애플리케이션의 예산 및 자산 관련 데이터 통신을 담당하는 원격 데이터 소스 클래스입니다.
/// [Dio] HTTP 클라이언트를 사용하여 백엔드 API와 통신하고, 응답 데이터를 모델 객체로 변환하거나
/// 발생하는 예외를 시스템 예외로 변환하여 던집니다.
///
/// **Key Features:**
/// *   새로운 예산 생성 및 기존 예산 수정 (`createOrUpdateBudget`)
/// *   특정 월의 예산 정보 조회 (`getMonthlyBudget`)
/// *   예산 삭제 처리 (`deleteBudget`)
/// *   가계부의 총 자산 및 초기 잔액 정보 등의 통계 조회 (`getTotalAssets`)
/// *   가계부의 초기 잔액(자산 시작값) 변경 (`updateInitialBalance`)
///
/// **Parameters:**
/// *   [dio] - 통신에 사용할 설정이 완료된 Dio 인스턴스입니다.
///
/// **Usage Example:**
/// ```dart
/// final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
/// final budgetRemoteDataSource = BudgetRemoteDataSourceImpl(dio: dio);
///
/// // 특정 월의 예산 조회 예시
/// final monthlyBudget = await budgetRemoteDataSource.getMonthlyBudget(
///   year: 2026,
///   month: 2,
///   accountBookId: 'account-123',
/// );
/// ```
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

      return BudgetResponseModel.fromJson(
          response.data as Map<String, dynamic>);
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

      // 예산없음 noContent(204) 처리
      if (response.statusCode == 204) {
        return null;
      }

      if (response.data == null ||
          response.data == '' ||
          response.data is! Map<String, dynamic>) {
        return null;
      }

      return BudgetResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
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
  Future<void> deleteBudget({
    required String budgetId,
  }) async {
    try {
      await dio.delete(ApiConstants.budgetById(budgetId));
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[BudgetRemoteDataSource] deleteBudget error: $e');
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
