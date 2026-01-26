import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/entities/monthly_home_cache.dart';

abstract class HomeRepository {
  /// 특정 월의 날짜별 요약 및 내역 데이터를 가져옵니다.
  /// 결과는 날짜를 Key(YYYY-MM-DD 형식)로 하는 Map 형태입니다.
  Future<Map<String, DailyTransactionSummary>> getMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  });

  /// 특정 월의 캐시된 데이터를 가져옵니다.
  Future<MonthlyHomeCache?> getCachedMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  });

  /// 특정 월의 캐시 데이터를 삭제합니다.
  Future<void> invalidateMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  });

  // ========== 예산 캐시 ==========
  Future<CachedBudget?> getCachedBudget({
    required DateTime month,
    required String accountBookId,
  });

  Future<void> saveCachedBudget({
    required DateTime month,
    required String accountBookId,
    required BudgetEntity? budget,
  });

  // ========== 자산 캐시 ==========
  Future<CachedAsset?> getCachedAsset({
    required String accountBookId,
  });

  Future<void> saveCachedAsset({
    required String accountBookId,
    required AssetEntity asset,
  });
}
