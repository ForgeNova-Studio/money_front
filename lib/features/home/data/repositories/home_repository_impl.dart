// packages
import 'package:intl/intl.dart';

// entities
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moneyflow/features/home/domain/entities/monthly_home_cache.dart';

// repository
import 'package:moneyflow/features/home/domain/repositories/home_repository.dart';

// dataSource
import 'package:moneyflow/features/home/data/datasources/home_local_data_source.dart';
import 'package:moneyflow/features/home/data/datasources/home_remote_data_source.dart';

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

    try {
      await _homeLocalDataSource.saveMonthlyData(
        cacheKey: _buildCacheKey(userId, accountBookId, yearMonthStr),
        data: responseMap,
      );
    } catch (_) {
      // Cache failures should not block remote data usage.
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
}
