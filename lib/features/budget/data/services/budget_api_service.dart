import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/services/base_api_service.dart';

class BudgetApiService extends BaseApiService {
  // Budget APIs
  Future<Map<String, dynamic>> createOrUpdateBudget(
      Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.budgets, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> getBudget({
    required int year,
    required int month,
  }) async {
    final response = await dio.get(
      ApiConstants.budgets,
      queryParameters: {
        'year': year,
        'month': month,
      },
    );
    return response.data;
  }

  Future<void> deleteBudget(String budgetId) async {
    await dio.delete('${ApiConstants.budgets}/$budgetId');
  }
}
