import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';

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

class CachedBudget {
  final BudgetEntity? data;
  final DateTime cachedAt;

  CachedBudget({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }
}

class CachedAsset {
  final AssetEntity data;
  final DateTime cachedAt;

  CachedAsset({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }
}
