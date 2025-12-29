import 'package:dio/dio.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/home/data/models/home_monthly_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeMonthlyResponseModel> getMonthlyData({required String yearMonth});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<HomeMonthlyResponseModel> getMonthlyData({required String yearMonth}) async {
    try {
      final response = await dio.get(
        ApiConstants.homeMonthlyData,
        queryParameters: {'yearMonth': yearMonth},
      );
      return HomeMonthlyResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}