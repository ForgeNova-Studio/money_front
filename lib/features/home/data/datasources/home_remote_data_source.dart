// packages
import 'package:dio/dio.dart';

// core
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';

abstract class HomeRemoteDataSource {
  Future<Map<String, dynamic>> getMonthlyData({required String yearMonth});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getMonthlyData({required String yearMonth}) async {
    try {
      final response = await dio.get(
        ApiConstants.homeMonthlyData,
        queryParameters: {'yearMonth': yearMonth},
      );
      return response.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
