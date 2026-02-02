import 'package:dio/dio.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/statistics/data/datasources/statistics_remote_datasource.dart';
import 'package:moamoa/features/statistics/data/models/monthly_statistics_model.dart';

/// 통계 Remote DataSource 구현체
class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final Dio dio;

  StatisticsRemoteDataSourceImpl({required this.dio});

  @override
  Future<MonthlyStatisticsModel> getMonthlyStatistics({
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
        ApiConstants.statisticsMonthly,
        queryParameters: queryParams,
      );

      return MonthlyStatisticsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
