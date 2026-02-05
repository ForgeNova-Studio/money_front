import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_report_entity.freezed.dart';
part 'monthly_report_entity.g.dart';

/// 월간 리포트 엔티티
@freezed
sealed class MonthlyReportEntity with _$MonthlyReportEntity {
  const factory MonthlyReportEntity({
    required int year,
    required int month,
    required int totalExpense,
    required int totalIncome,
    required int netIncome,
    int? previousMonthExpense,
    double? changePercent,
    required List<CategoryBreakdownEntity> categoryBreakdown,
    required List<TopExpenseEntity> topExpenses,
    TopMerchantEntity? topMerchant,
    BudgetSummaryEntity? budget,
  }) = _MonthlyReportEntity;

  factory MonthlyReportEntity.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportEntityFromJson(json);
}

/// 카테고리별 지출
@freezed
sealed class CategoryBreakdownEntity with _$CategoryBreakdownEntity {
  const factory CategoryBreakdownEntity({
    required String category,
    required int amount,
    required int percentage,
  }) = _CategoryBreakdownEntity;

  factory CategoryBreakdownEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownEntityFromJson(json);
}

/// TOP 지출 항목
@freezed
sealed class TopExpenseEntity with _$TopExpenseEntity {
  const factory TopExpenseEntity({
    String? merchant,
    required int amount,
    required DateTime date,
    String? category,
  }) = _TopExpenseEntity;

  factory TopExpenseEntity.fromJson(Map<String, dynamic> json) =>
      _$TopExpenseEntityFromJson(json);
}

/// 가장 많이 방문한 가맹점
@freezed
sealed class TopMerchantEntity with _$TopMerchantEntity {
  const factory TopMerchantEntity({
    required String name,
    required int visitCount,
  }) = _TopMerchantEntity;

  factory TopMerchantEntity.fromJson(Map<String, dynamic> json) =>
      _$TopMerchantEntityFromJson(json);
}

/// 예산 요약
@freezed
sealed class BudgetSummaryEntity with _$BudgetSummaryEntity {
  const factory BudgetSummaryEntity({
    required int targetAmount,
    required int currentSpending,
    required int usagePercentage,
  }) = _BudgetSummaryEntity;

  factory BudgetSummaryEntity.fromJson(Map<String, dynamic> json) =>
      _$BudgetSummaryEntityFromJson(json);
}
