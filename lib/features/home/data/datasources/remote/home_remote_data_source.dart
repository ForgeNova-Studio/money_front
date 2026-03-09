import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<Map<String, DailyTransactionSummaryModel>> getMonthlyData(
      {required String yearMonth, required String accountBookId});
}
