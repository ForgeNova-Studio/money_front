import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/services/base_api_service.dart';

class StatisticsApiService extends BaseApiService {
  // Statistics APIs
  Future<Map<String, dynamic>> getMonthlyStatistics({
    required int year,
    required int month,
  }) async {
    final response = await dio.get(
      ApiConstants.statisticsMonthly,
      queryParameters: {
        'year': year,
        'month': month,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getWeeklyStatistics({
    required DateTime startDate,
  }) async {
    final response = await dio.get(
      ApiConstants.statisticsWeekly,
      queryParameters: {
        'startDate': startDate.toIso8601String().split('T')[0],
      },
    );
    return response.data;
  }
}
