import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';

import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/entities/asset_entity.dart';

/// 월간 홈 데이터 캐시 모델
///
/// [DailyTransactionSummaryModel] 리스트를 포함하며, 캐싱 시각을 저장합니다.
class HomeMonthlyCacheEntry {
  final DateTime cachedAt;
  final Map<String, DailyTransactionSummaryModel> data;

  HomeMonthlyCacheEntry({
    required this.cachedAt,
    required this.data,
  });
}

/// 월간 예산 캐시 모델
///
/// [BudgetEntity]를 포함하며, 캐싱 시각을 저장합니다.
class BudgetCacheEntry {
  final DateTime cachedAt;
  final BudgetEntity? data;

  BudgetCacheEntry({
    required this.cachedAt,
    required this.data,
  });
}

/// 자산 정보 캐시 모델
///
/// [AssetEntity]를 포함하며, 캐싱 시각을 저장합니다.
class AssetCacheEntry {
  final DateTime cachedAt;
  final AssetEntity data;

  AssetCacheEntry({
    required this.cachedAt,
    required this.data,
  });
}

/// 로컬 데이터 소스 인터페이스
///
/// Hive를 사용하여 홈 화면 데이터를 로컬에 캐싱하고 조회합니다.
///
/// 주요 기능:
/// - 월간 거래 데이터 캐시 (GET/SAVE/DELETE)
/// - 예산 정보 캐시 (GET/SAVE)
/// - 자산 정보 캐시 (GET/SAVE)
abstract class HomeLocalDataSource {
  Future<HomeMonthlyCacheEntry?> getMonthlyData({required String cacheKey});
  Future<void> saveMonthlyData({
    required String cacheKey,
    required Map<String, DailyTransactionSummaryModel> data,
  });
  Future<void> deleteMonthlyData({required String cacheKey});

  Future<BudgetCacheEntry?> getBudgetCache({required String cacheKey});
  Future<void> saveBudgetCache({
    required String cacheKey,
    required BudgetEntity? data,
  });

  Future<AssetCacheEntry?> getAssetCache({required String cacheKey});
  Future<void> saveAssetCache({
    required String cacheKey,
    required AssetEntity data,
  });
}
