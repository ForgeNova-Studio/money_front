import 'package:dio/dio.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/home/data/models/home_monthly_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<Map<String, DailyTransactionSummaryModel>> getMonthlyData({required String yearMonth});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, DailyTransactionSummaryModel>> getMonthlyData({required String yearMonth}) async {
    try {
      final response = await dio.get(
        ApiConstants.homeMonthlyData,
        queryParameters: {'yearMonth': yearMonth},
      );
      
      final Map<String, dynamic> data = response.data;
      
      return data.map((key, value) => MapEntry(
        key, 
        DailyTransactionSummaryModel.fromJson(value as Map<String, dynamic>)
      ));
      
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}