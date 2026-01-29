import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';

class AssetSummary {
  /// 총 자산 금액
  final int totalAmount;

  /// 전월 대비 변화 금액
  final int previousMonthDiff;

  /// 카테고리별 요약
  final List<CategoryBreakdown> categoryBreakdowns;

  const AssetSummary({
    required this.totalAmount,
    this.previousMonthDiff = 0,
    this.categoryBreakdowns = const [],
  });

  /// 전월 대비 변화율 (%)
  double get changePercent {
    final previousTotal = totalAmount - previousMonthDiff;
    if (previousTotal == 0) return 0;
    return (previousMonthDiff / previousTotal) * 100;
  }

  /// 증가 여부
  bool get isPositive => previousMonthDiff >= 0;

  AssetSummary copyWith({
    int? totalAmount,
    int? previousMonthDiff,
    List<CategoryBreakdown>? categoryBreakdowns,
  }) {
    return AssetSummary(
      totalAmount: totalAmount ?? this.totalAmount,
      previousMonthDiff: previousMonthDiff ?? this.previousMonthDiff,
      categoryBreakdowns: categoryBreakdowns ?? this.categoryBreakdowns,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssetSummary &&
        other.totalAmount == totalAmount &&
        other.previousMonthDiff == previousMonthDiff &&
        _listEquals(other.categoryBreakdowns, categoryBreakdowns);
  }

  @override
  int get hashCode =>
      totalAmount.hashCode ^
      previousMonthDiff.hashCode ^
      Object.hashAll(categoryBreakdowns);
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// 카테고리별 자산 요약
class CategoryBreakdown {
  /// 카테고리
  final AssetCategory category;

  /// 금액
  final int amount;

  /// 전체 대비 비율 (%)
  final double percent;

  const CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percent,
  });

  CategoryBreakdown copyWith({
    AssetCategory? category,
    int? amount,
    double? percent,
  }) {
    return CategoryBreakdown(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      percent: percent ?? this.percent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryBreakdown &&
        other.category == category &&
        other.amount == amount &&
        other.percent == percent;
  }

  @override
  int get hashCode => category.hashCode ^ amount.hashCode ^ percent.hashCode;
}
