import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';

part 'asset_summary.freezed.dart';

/// 자산 요약 정보
@freezed
sealed class AssetSummary with _$AssetSummary {
  const AssetSummary._();

  const factory AssetSummary({
    /// 총 자산 금액
    required int totalAmount,

    /// 전월 대비 변화 금액
    @Default(0) int previousMonthDiff,

    /// 카테고리별 요약
    @Default([]) List<CategoryBreakdown> categoryBreakdowns,
  }) = _AssetSummary;

  /// 전월 대비 변화율 (%)
  double get changePercent {
    final previousTotal = totalAmount - previousMonthDiff;
    if (previousTotal == 0) return 0;
    return (previousMonthDiff / previousTotal) * 100;
  }

  /// 증가 여부
  bool get isPositive => previousMonthDiff >= 0;
}

/// 카테고리별 자산 요약
@freezed
sealed class CategoryBreakdown with _$CategoryBreakdown {
  const CategoryBreakdown._();

  const factory CategoryBreakdown({
    /// 카테고리
    required AssetCategory category,

    /// 금액
    required int amount,

    /// 전체 대비 비율 (%)
    required double percent,
  }) = _CategoryBreakdown;
}
