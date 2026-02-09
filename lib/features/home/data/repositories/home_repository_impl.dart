// packages
import 'package:intl/intl.dart';

// entities
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/entities/monthly_home_cache.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';

// repository
import 'package:moamoa/features/home/domain/repositories/home_repository.dart';

// dataSource
import 'package:moamoa/features/home/data/datasources/local/home_local_data_source.dart';
import 'package:moamoa/features/home/data/datasources/remote/home_remote_data_source.dart';

/// 홈 화면 데이터 접근을 위한 Repository 구현체
///
/// [HomeRepository] 인터페이스를 구현하며,
/// 원격 데이터 소스([HomeRemoteDataSource])와 로컬 데이터 소스([HomeLocalDataSource])를
/// 조합하여 데이터를 제공합니다.
///
/// 주요 기능:
/// - 월간 홈 데이터 조회: 먼저 서버에서 데이터를 가져오고, 성공 시 로컬 DB에 캐싱합니다.
/// - 캐시된 데이터 조회: 로컬 DB에서 캐시된 데이터를 조회합니다.
/// - 예산/자산 캐시 관리: 예산 및 자산 정보를 로컬 DB에 저장하고 조회합니다.
///
/// 데이터 흐름:
/// 1. `getMonthlyHomeData`: Remote -> Local Save -> Entity Return
/// 2. `getCachedMonthlyHomeData`: Local -> Entity Return
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  final HomeLocalDataSource _homeLocalDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource homeRemoteDataSource,
    required HomeLocalDataSource homeLocalDataSource,
  })  : _homeRemoteDataSource = homeRemoteDataSource,
        _homeLocalDataSource = homeLocalDataSource;

  @override
  Future<Map<String, DailyTransactionSummary>> getMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  }) async {
    final yearMonthStr = DateFormat('yyyy-MM').format(yearMonth);

    // API 호출 (이미 날짜별로 정리된 데이터를 받아옴)
    final responseMap = await _homeRemoteDataSource.getMonthlyData(
      yearMonth: yearMonthStr,
      accountBookId: accountBookId,
    );

    if (userId.isNotEmpty) {
      try {
        await _homeLocalDataSource.saveMonthlyData(
          cacheKey: _buildCacheKey(userId, accountBookId, yearMonthStr),
          data: responseMap,
        );
      } catch (_) {
        // Cache failures should not block remote data usage.
      }
    }

    // Model -> Entity 변환
    return responseMap.map((key, model) => MapEntry(key, model.toEntity()));
  }

  @override
  Future<MonthlyHomeCache?> getCachedMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  }) async {
    if (userId.isEmpty) return null;
    final yearMonthStr = DateFormat('yyyy-MM').format(yearMonth);
    HomeMonthlyCacheEntry? entry;
    try {
      entry = await _homeLocalDataSource.getMonthlyData(
        cacheKey: _buildCacheKey(userId, accountBookId, yearMonthStr),
      );
    } catch (_) {
      return null;
    }

    if (entry == null) return null;

    return MonthlyHomeCache(
      data: entry.data.map((key, model) => MapEntry(key, model.toEntity())),
      cachedAt: entry.cachedAt,
    );
  }

  @override
  Future<void> invalidateMonthlyHomeData({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  }) async {
    if (userId.isEmpty) return;
    final yearMonthStr = DateFormat('yyyy-MM').format(yearMonth);
    try {
      await _homeLocalDataSource.deleteMonthlyData(
        cacheKey: _buildCacheKey(userId, accountBookId, yearMonthStr),
      );
    } catch (_) {
      // Ignore cache invalidation errors.
    }
  }

  String _buildCacheKey(String userId, String accountBookId, String yearMonth) {
    return 'home_monthly:$userId:$accountBookId:$yearMonth';
  }

  @override
  Future<CachedBudget?> getCachedBudget({
    required DateTime month,
    required String accountBookId,
  }) async {
    final yearMonthStr = DateFormat('yyyy-MM').format(month);
    final key = 'budget:$accountBookId:$yearMonthStr';
    final entry = await _homeLocalDataSource.getBudgetCache(cacheKey: key);
    if (entry == null) return null;
    return CachedBudget(data: entry.data, cachedAt: entry.cachedAt);
  }

  @override
  Future<void> saveCachedBudget({
    required DateTime month,
    required String accountBookId,
    required BudgetEntity? budget,
  }) async {
    final yearMonthStr = DateFormat('yyyy-MM').format(month);
    final key = 'budget:$accountBookId:$yearMonthStr';
    await _homeLocalDataSource.saveBudgetCache(cacheKey: key, data: budget);
  }

  @override
  Future<CachedAsset?> getCachedAsset({required String accountBookId}) async {
    final key = 'asset:$accountBookId';
    final entry = await _homeLocalDataSource.getAssetCache(cacheKey: key);
    if (entry == null) return null;
    return CachedAsset(data: entry.data, cachedAt: entry.cachedAt);
  }

  @override
  Future<void> saveCachedAsset({
    required String accountBookId,
    required AssetEntity asset,
  }) async {
    final key = 'asset:$accountBookId';
    await _homeLocalDataSource.saveAssetCache(cacheKey: key, data: asset);
  }
}
