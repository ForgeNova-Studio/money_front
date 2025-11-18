import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/services/base_api_service.dart';

class IncomeApiService extends BaseApiService {
  // Income APIs
  Future<Map<String, dynamic>> createIncome(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.incomes, data: data);
    return response.data;
  }

  Future<dynamic> getRecentIncomes() async {
    final response = await dio.get('${ApiConstants.incomes}/recent');
    return response.data;
  }

  Future<Map<String, dynamic>> getIncomes({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      if (source != null && source.isNotEmpty) 'source': source,
    };

    final response = await dio.get(
      ApiConstants.incomes,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getIncome(String incomeId) async {
    final response = await dio.get('${ApiConstants.incomes}/$incomeId');
    return response.data;
  }

  Future<Map<String, dynamic>> updateIncome(
    String incomeId,
    Map<String, dynamic> data,
  ) async {
    final response = await dio.put(
      '${ApiConstants.incomes}/$incomeId',
      data: data,
    );
    return response.data;
  }

  Future<void> deleteIncome(String incomeId) async {
    await dio.delete('${ApiConstants.incomes}/$incomeId');
  }
}
