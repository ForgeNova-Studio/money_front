import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';
import 'package:moamoa/features/assets/domain/entities/asset_overview.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) {
    final asInt = int.tryParse(value);
    if (asInt != null) return asInt;
    final asDouble = double.tryParse(value);
    if (asDouble != null) return asDouble.round();
  }
  return 0;
}

double _asDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

DateTime? _asDateTime(dynamic value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

class AssetResponseModel {
  final String id;
  final String name;
  final String category;
  final int amount;
  final String? memo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AssetResponseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    this.memo,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) {
    return AssetResponseModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? 'OTHER').toString(),
      amount: _asInt(json['amount']),
      memo: json['memo']?.toString(),
      createdAt: _asDateTime(json['createdAt']),
      updatedAt: _asDateTime(json['updatedAt']),
    );
  }

  Asset toEntity() {
    return Asset(
      id: id,
      name: name,
      category: AssetCategory.fromCode(category),
      amount: amount,
      memo: memo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class CategoryBreakdownModel {
  final String category;
  final int amount;
  final double percent;

  const CategoryBreakdownModel({
    required this.category,
    required this.amount,
    required this.percent,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      category: (json['category'] ?? 'OTHER').toString(),
      amount: _asInt(json['amount']),
      percent: _asDouble(json['percent']),
    );
  }

  CategoryBreakdown toEntity() {
    return CategoryBreakdown(
      category: AssetCategory.fromCode(category),
      amount: amount,
      percent: percent,
    );
  }
}

class AssetSummaryResponseModel {
  final int totalAmount;
  final int previousMonthDiff;
  final List<CategoryBreakdownModel> categoryBreakdowns;
  final List<AssetResponseModel> assets;

  const AssetSummaryResponseModel({
    required this.totalAmount,
    required this.previousMonthDiff,
    required this.categoryBreakdowns,
    required this.assets,
  });

  factory AssetSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    final categoryBreakdownsRaw = json['categoryBreakdowns'];
    final assetsRaw = json['assets'];

    return AssetSummaryResponseModel(
      totalAmount: _asInt(json['totalAmount']),
      previousMonthDiff: _asInt(json['previousMonthDiff']),
      categoryBreakdowns: categoryBreakdownsRaw is List
          ? categoryBreakdownsRaw
              .whereType<Map<String, dynamic>>()
              .map((e) => CategoryBreakdownModel.fromJson(e))
              .toList()
          : const [],
      assets: assetsRaw is List
          ? assetsRaw
              .whereType<Map<String, dynamic>>()
              .map((e) => AssetResponseModel.fromJson(e))
              .toList()
          : const [],
    );
  }

  AssetOverview toEntity() {
    final summary = AssetSummary(
      totalAmount: totalAmount,
      previousMonthDiff: previousMonthDiff,
      categoryBreakdowns:
          categoryBreakdowns.map((b) => b.toEntity()).toList(),
    );

    return AssetOverview(
      summary: summary,
      assets: assets.map((a) => a.toEntity()).toList(),
    );
  }
}

