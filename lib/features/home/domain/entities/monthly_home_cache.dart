import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';

class MonthlyHomeCache {
  final Map<String, DailyTransactionSummary> data;
  final DateTime cachedAt;

  MonthlyHomeCache({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }
}
