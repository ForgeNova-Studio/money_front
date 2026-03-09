// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/statistics/domain/entities/category_monthly_comparison.dart';

part 'category_monthly_comparison_model.freezed.dart';
part 'category_monthly_comparison_model.g.dart';

/// 카테고리별 비교 모델
/// 백엔드 BigDecimal 호환을 위해 num 타입 사용
@freezed
sealed class CategoryComparisonModel with _$CategoryComparisonModel {
  const CategoryComparisonModel._();

  const factory CategoryComparisonModel({
    required String category,
    required num currentAmount, // BigDecimal 호환
    required num previousAmount, // BigDecimal 호환
    required num diff, // BigDecimal 호환
    num? diffPercentage, // 전월 0원이면 null
  }) = _CategoryComparisonModel;

  factory CategoryComparisonModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryComparisonModelFromJson(json);

  /// Domain Entity로 변환
  CategoryComparison toEntity() {
    return CategoryComparison(
      category: category,
      currentAmount: currentAmount.toInt(),
      previousAmount: previousAmount.toInt(),
      diff: diff.toInt(),
      diffPercentage: diffPercentage?.toDouble(),
    );
  }
}

/// 카테고리별 전월 대비 변화 응답 모델
@freezed
sealed class CategoryMonthlyComparisonModel
    with _$CategoryMonthlyComparisonModel {
  const CategoryMonthlyComparisonModel._();

  const factory CategoryMonthlyComparisonModel({
    required String accountBookId,
    required String accountBookName,
    required int year,
    required int month,
    required num currentMonthTotal, // BigDecimal 호환
    required num previousMonthTotal, // BigDecimal 호환
    required List<CategoryComparisonModel> categories,
  }) = _CategoryMonthlyComparisonModel;

  factory CategoryMonthlyComparisonModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryMonthlyComparisonModelFromJson(json);

  /// Domain Entity로 변환
  CategoryMonthlyComparison toEntity() {
    return CategoryMonthlyComparison(
      accountBookId: accountBookId,
      accountBookName: accountBookName,
      year: year,
      month: month,
      currentMonthTotal: currentMonthTotal.toInt(),
      previousMonthTotal: previousMonthTotal.toInt(),
      categories: categories.map((e) => e.toEntity()).toList(),
    );
  }
}
