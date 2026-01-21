import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<Map<String, DailyTransactionSummaryModel>> getMonthlyData(
      {required String yearMonth, required String accountBookId});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, DailyTransactionSummaryModel>> getMonthlyData(
      {required String yearMonth, required String accountBookId}) async {
    try {
      final response = await dio.get(
        ApiConstants.homeMonthlyData,
        queryParameters: {
          'yearMonth': yearMonth,
          'accountBookId': accountBookId,
        },
      );

      final Map<String, dynamic> data = response.data;

      return data.map((key, value) {
        try {
          return MapEntry(
              key,
              DailyTransactionSummaryModel.fromJson(
                  value as Map<String, dynamic>));
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[HomeRemoteDataSource] Unexpected error: $e');
          }
          rethrow;
        }
      });
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[HomeRemoteDataSource] Unexpected error: $e');
        debugPrint('[HomeRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
}
