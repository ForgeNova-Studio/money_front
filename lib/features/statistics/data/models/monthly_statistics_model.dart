// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/statistics/domain/entities/category_breakdown.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';

part 'monthly_statistics_model.freezed.dart';
part 'monthly_statistics_model.g.dart';

/// 카테고리별 지출 모델
/// 백엔드 BigDecimal 호환을 위해 num 타입 사용
@freezed
sealed class CategoryBreakdownModel with _$CategoryBreakdownModel {
  const CategoryBreakdownModel._();

  const factory CategoryBreakdownModel({
    required String category,
    required num amount, // BigDecimal 호환
    required num percentage, // BigDecimal 호환
  }) = _CategoryBreakdownModel;

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownModelFromJson(json);

  /// Domain Entity로 변환
  CategoryBreakdown toEntity() {
    return CategoryBreakdown(
      category: category,
      amount: amount.toInt(),
      percentage: percentage.toInt(),
    );
  }
}

/// 전월 대비 비교 모델
@freezed
sealed class ComparisonDataModel with _$ComparisonDataModel {
  const ComparisonDataModel._();

  const factory ComparisonDataModel({
    required num diff, // BigDecimal 호환
    required num diffPercentage,
  }) = _ComparisonDataModel;

  factory ComparisonDataModel.fromJson(Map<String, dynamic> json) =>
      _$ComparisonDataModelFromJson(json);

  /// Domain으로 변환
  ComparisonData toEntity() {
    return ComparisonData(
      diff: diff.toInt(),
      diffPercentage: diffPercentage.toDouble(),
    );
  }
}

/// 월간 통계 모델
@freezed
sealed class MonthlyStatisticsModel with _$MonthlyStatisticsModel {
  const MonthlyStatisticsModel._();

  const factory MonthlyStatisticsModel({
    required String accountBookId,
    required String accountBookName,
    required num totalAmount, // BigDecimal 호환
    required List<CategoryBreakdownModel> categoryBreakdown,
    required ComparisonDataModel comparisonWithLastMonth,
  }) = _MonthlyStatisticsModel;

  factory MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatisticsModelFromJson(json);

  /// Domain Entity로 변환
  MonthlyStatistics toEntity() {
    return MonthlyStatistics(
      accountBookId: accountBookId,
      accountBookName: accountBookName,
      totalAmount: totalAmount.toInt(),
      categoryBreakdown: categoryBreakdown.map((e) => e.toEntity()).toList(),
      comparisonWithLastMonth: comparisonWithLastMonth.toEntity(),
    );
  }
}
