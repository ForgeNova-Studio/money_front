import 'package:hive/hive.dart';
import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';

import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';

class HomeMonthlyCacheEntry {
  final DateTime cachedAt;
  final Map<String, DailyTransactionSummaryModel> data;

  HomeMonthlyCacheEntry({
    required this.cachedAt,
    required this.data,
  });
}

class BudgetCacheEntry {
  final DateTime cachedAt;
  final BudgetEntity? data;

  BudgetCacheEntry({
    required this.cachedAt,
    required this.data,
  });
}

class AssetCacheEntry {
  final DateTime cachedAt;
  final AssetEntity data;

  AssetCacheEntry({
    required this.cachedAt,
    required this.data,
  });
}

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
