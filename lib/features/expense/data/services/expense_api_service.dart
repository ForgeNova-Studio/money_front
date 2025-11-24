import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/services/base_api_service.dart';

class ExpenseApiService extends BaseApiService {
  // Expense APIs
  Future<Map<String, dynamic>> createExpense(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.expenses, data: data);
    return response.data;
  }

  Future<dynamic> getRecentExpenses() async {
    final response = await dio.get('${ApiConstants.expenses}/recent');
    return response.data;
  }

  Future<Map<String, dynamic>> getExpenses({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      if (category != null && category.isNotEmpty) 'category': category,
    };

    final response = await dio.get(
      ApiConstants.expenses,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getExpense(String expenseId) async {
    final response = await dio.get('${ApiConstants.expenses}/$expenseId');
    return response.data;
  }

  Future<Map<String, dynamic>> updateExpense(
    String expenseId,
    Map<String, dynamic> data,
  ) async {
    final response = await dio.put(
      '${ApiConstants.expenses}/$expenseId',
      data: data,
    );
    return response.data;
  }

  Future<void> deleteExpense(String expenseId) async {
    await dio.delete('${ApiConstants.expenses}/$expenseId');
  }
}
