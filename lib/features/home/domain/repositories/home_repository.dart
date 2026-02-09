import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/entities/monthly_home_cache.dart';

/// 홈 화면 데이터 접근을 위한 Repository 인터페이스
///
/// 클린 아키텍처의 Repository 패턴을 구현하여
/// 데이터 소스(Remote/Local)를 추상화합니다.
///
/// 주요 메서드:
/// - [getMonthlyHomeData]: 월간 거래 데이터 조회 (서버)
/// - [getCachedMonthlyHomeData]: 캐시된 월간 데이터 조회 (로컬)
/// - [invalidateMonthlyHomeData]: 캐시 무효화
/// - [getCachedBudget] / [saveCachedBudget]: 예산 캐시 관리
/// - [getCachedAsset] / [saveCachedAsset]: 자산 캐시 관리
///
/// 구현체:
/// - `HomeRepositoryImpl`: 실제 구현 (data layer)
abstract class HomeRepository {
  Future<Map<String, DailyTransactionSummary>> getMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  });
  Future<MonthlyHomeCache?> getCachedMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  });
  Future<void> invalidateMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  });
  Future<CachedBudget?> getCachedBudget({
    required DateTime month,
    required String accountBookId,
  });
  Future<void> saveCachedBudget({
    required DateTime month,
    required String accountBookId,
    required BudgetEntity? budget,
  });
  Future<CachedAsset?> getCachedAsset({
    required String accountBookId,
  });
  Future<void> saveCachedAsset({
    required String accountBookId,
    required AssetEntity asset,
  });
}
