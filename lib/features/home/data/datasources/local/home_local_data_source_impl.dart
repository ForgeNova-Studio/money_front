import 'package:hive/hive.dart';
import 'package:moamoa/features/home/data/datasources/local/home_local_data_source.dart';
import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';

/// 로컬 데이터 소스 구현체
///
/// Hive Box(`home_monthly_cache`)를 사용하여 데이터를 영구 저장합니다.
/// 데이터는 JSON 형태로 직렬화되어 저장됩니다.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String boxName = 'home_monthly_cache';

  Box? _box;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _box = await Hive.openBox(boxName);
    _initialized = true;
  }

  @override
  Future<HomeMonthlyCacheEntry?> getMonthlyData(
      {required String cacheKey}) async {
    await _ensureInitialized();

    final box = _box;
    if (box == null) return null;

    final stored = box.get(cacheKey);
    if (stored is! Map) return null;

    final cachedAtMillis = stored['cachedAt'] as int?;
    final rawData = stored['data'];
    if (cachedAtMillis == null || rawData is! Map) return null;

    final parsedData = <String, DailyTransactionSummaryModel>{};
    rawData.forEach((key, value) {
      if (key is String && value is Map<String, dynamic>) {
        parsedData[key] = DailyTransactionSummaryModel.fromJson(value);
      } else if (key is String && value is Map) {
        parsedData[key] = DailyTransactionSummaryModel.fromJson(
          Map<String, dynamic>.from(value),
        );
      }
    });

    return HomeMonthlyCacheEntry(
      cachedAt: DateTime.fromMillisecondsSinceEpoch(cachedAtMillis),
      data: parsedData,
    );
  }

  @override
  Future<void> saveMonthlyData({
    required String cacheKey,
    required Map<String, DailyTransactionSummaryModel> data,
  }) async {
    await _ensureInitialized();

    final box = _box;
    if (box == null) return;

    final serialized = data.map(
      (key, value) => MapEntry(key, _serializeSummary(value)),
    );

    await box.put(cacheKey, {
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
      'data': serialized,
    });
  }

  @override
  Future<void> deleteMonthlyData({required String cacheKey}) async {
    await _ensureInitialized();
    await _box?.delete(cacheKey);
  }

  @override
  Future<BudgetCacheEntry?> getBudgetCache({required String cacheKey}) async {
    await _ensureInitialized();
    final box = _box;
    if (box == null) return null;

    final stored = box.get(cacheKey);
    if (stored is! Map) return null;

    final cachedAtMillis = stored['cachedAt'] as int?;
    final data = stored['data'];
    if (cachedAtMillis == null) return null;

    BudgetEntity? parsedData;
    if (data != null && data is Map) {
      final map = Map<String, dynamic>.from(data);
      parsedData = BudgetEntity(
        budgetId: map['budgetId'],
        year: map['year'],
        month: map['month'],
        targetAmount: map['targetAmount'],
        currentSpending: map['currentSpending'],
        remainingAmount: map['remainingAmount'],
        usagePercentage: map['usagePercentage'],
      );
    }

    return BudgetCacheEntry(
      cachedAt: DateTime.fromMillisecondsSinceEpoch(cachedAtMillis),
      data: parsedData,
    );
  }

  @override
  Future<void> saveBudgetCache({
    required String cacheKey,
    required BudgetEntity? data,
  }) async {
    await _ensureInitialized();
    final box = _box;
    if (box == null) return;

    Map<String, dynamic>? dataMap;
    if (data != null) {
      dataMap = {
        'budgetId': data.budgetId,
        'year': data.year,
        'month': data.month,
        'targetAmount': data.targetAmount,
        'currentSpending': data.currentSpending,
        'remainingAmount': data.remainingAmount,
        'usagePercentage': data.usagePercentage,
      };
    }

    await box.put(cacheKey, {
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
      'data': dataMap,
    });
  }

  @override
  Future<AssetCacheEntry?> getAssetCache({required String cacheKey}) async {
    await _ensureInitialized();
    final box = _box;
    if (box == null) return null;

    final stored = box.get(cacheKey);
    if (stored is! Map) return null;

    final cachedAtMillis = stored['cachedAt'] as int?;
    final data = stored['data'];
    if (cachedAtMillis == null || data is! Map) return null;

    final map = Map<String, dynamic>.from(data);
    final parsedData = AssetEntity(
      accountBookId: map['accountBookId'],
      accountBookName: map['accountBookName'],
      currentTotalAssets: map['currentTotalAssets'],
      initialBalance: map['initialBalance'],
      totalIncome: map['totalIncome'],
      totalExpense: map['totalExpense'],
      periodIncome: map['periodIncome'],
      periodExpense: map['periodExpense'],
      periodNetIncome: map['periodNetIncome'],
    );

    return AssetCacheEntry(
      cachedAt: DateTime.fromMillisecondsSinceEpoch(cachedAtMillis),
      data: parsedData,
    );
  }

  @override
  Future<void> saveAssetCache({
    required String cacheKey,
    required AssetEntity data,
  }) async {
    await _ensureInitialized();
    final box = _box;
    if (box == null) return;

    final dataMap = {
      'accountBookId': data.accountBookId,
      'accountBookName': data.accountBookName,
      'currentTotalAssets': data.currentTotalAssets,
      'initialBalance': data.initialBalance,
      'totalIncome': data.totalIncome,
      'totalExpense': data.totalExpense,
      'periodIncome': data.periodIncome,
      'periodExpense': data.periodExpense,
      'periodNetIncome': data.periodNetIncome,
    };

    await box.put(cacheKey, {
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
      'data': dataMap,
    });
  }

  Map<String, dynamic> _serializeSummary(
    DailyTransactionSummaryModel summary,
  ) {
    return {
      'date': summary.date,
      'totalIncome': summary.totalIncome,
      'totalExpense': summary.totalExpense,
      'transactions': summary.transactions
          .map((transaction) => transaction.toJson())
          .toList(),
    };
  }
}
