import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:moneyflow/features/home/data/models/home_monthly_response_model.dart';

class HomeMonthlyCacheEntry {
  final DateTime cachedAt;
  final Map<String, DailyTransactionSummaryModel> data;

  HomeMonthlyCacheEntry({
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
  Future<HomeMonthlyCacheEntry?> getMonthlyData({required String cacheKey}) async {
    await _ensureInitialized();

    final box = _box;
    if (box == null) return null;

    debugPrint('[HomeCache] GET key=$cacheKey box=${box.length}');
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

    try {
      await box.put(cacheKey, {
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'data': serialized,
      });
      debugPrint('[HomeCache] PUT key=$cacheKey items=${data.length}');
    } catch (e) {
      debugPrint('[HomeCache] PUT failed key=$cacheKey error=$e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMonthlyData({required String cacheKey}) async {
    await _ensureInitialized();
    try {
      await _box?.delete(cacheKey);
      debugPrint('[HomeCache] DELETE key=$cacheKey');
    } catch (e) {
      debugPrint('[HomeCache] DELETE failed key=$cacheKey error=$e');
      rethrow;
    }
  }

  Map<String, dynamic> _serializeSummary(
    DailyTransactionSummaryModel summary,
  ) {
    return {
      'date': summary.date,
      'totalIncome': summary.totalIncome,
      'totalExpense': summary.totalExpense,
      'transactions':
          summary.transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }
}
