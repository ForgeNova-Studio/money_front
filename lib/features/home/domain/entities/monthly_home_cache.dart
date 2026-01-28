import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';

class MonthlyHomeCache {
  final Map<String, DailyTransactionSummary> data;
  final DateTime cachedAt;

  const MonthlyHomeCache({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyHomeCache &&
          runtimeType == other.runtimeType &&
          cachedAt == other.cachedAt &&
          _mapEquals(data, other.data);

  @override
  int get hashCode => cachedAt.hashCode ^ data.hashCode;

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

class CachedBudget {
  final BudgetEntity? data;
  final DateTime cachedAt;

  const CachedBudget({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedBudget &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          cachedAt == other.cachedAt;

  @override
  int get hashCode => data.hashCode ^ cachedAt.hashCode;
}

class CachedAsset {
  final AssetEntity data;
  final DateTime cachedAt;

  const CachedAsset({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedAsset &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          cachedAt == other.cachedAt;

  @override
  int get hashCode => data.hashCode ^ cachedAt.hashCode;
}
