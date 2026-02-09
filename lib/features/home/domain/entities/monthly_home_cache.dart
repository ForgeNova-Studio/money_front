import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';

/// 월간 홈 데이터의 캐시 엔티티
///
/// 특정 월의 일별 거래 요약 데이터([DailyTransactionSummary])를 캐싱합니다.
/// [cachedAt] 필드를 통해 데이터의 유효성을 검사합니다.
///
/// 주요 속성:
/// - [data]: 날짜별 거래 요약 Map
/// - [cachedAt]: 캐시 저장 시각
///
/// 메서드:
/// - [isExpired]: 캐시 만료 여부 확인 (TTL 비교)
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

/// 월간 예산 정보의 캐시 엔티티
///
/// [BudgetEntity] 데이터를 캐싱하며, 만료 시간(TTL)을 관리합니다.
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

/// 총 자산 정보의 캐시 엔티티
///
/// [AssetEntity] 데이터를 캐싱하며, 만료 시간(TTL)을 관리합니다.
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
