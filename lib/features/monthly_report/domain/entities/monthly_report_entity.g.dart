// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyReportEntity _$MonthlyReportEntityFromJson(Map<String, dynamic> json) =>
    _MonthlyReportEntity(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalExpense: (json['totalExpense'] as num).toInt(),
      totalIncome: (json['totalIncome'] as num).toInt(),
      netIncome: (json['netIncome'] as num).toInt(),
      previousMonthExpense: (json['previousMonthExpense'] as num?)?.toInt(),
      changePercent: (json['changePercent'] as num?)?.toDouble(),
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>)
          .map((e) =>
              CategoryBreakdownEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      topExpenses: (json['topExpenses'] as List<dynamic>)
          .map((e) => TopExpenseEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      topMerchant: json['topMerchant'] == null
          ? null
          : TopMerchantEntity.fromJson(
              json['topMerchant'] as Map<String, dynamic>),
      budget: json['budget'] == null
          ? null
          : BudgetSummaryEntity.fromJson(
              json['budget'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonthlyReportEntityToJson(
        _MonthlyReportEntity instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'totalExpense': instance.totalExpense,
      'totalIncome': instance.totalIncome,
      'netIncome': instance.netIncome,
      'previousMonthExpense': instance.previousMonthExpense,
      'changePercent': instance.changePercent,
      'categoryBreakdown': instance.categoryBreakdown,
      'topExpenses': instance.topExpenses,
      'topMerchant': instance.topMerchant,
      'budget': instance.budget,
    };

_CategoryBreakdownEntity _$CategoryBreakdownEntityFromJson(
        Map<String, dynamic> json) =>
    _CategoryBreakdownEntity(
      category: json['category'] as String,
      amount: (json['amount'] as num).toInt(),
      percentage: (json['percentage'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryBreakdownEntityToJson(
        _CategoryBreakdownEntity instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'percentage': instance.percentage,
    };

_TopExpenseEntity _$TopExpenseEntityFromJson(Map<String, dynamic> json) =>
    _TopExpenseEntity(
      merchant: json['merchant'] as String?,
      amount: (json['amount'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$TopExpenseEntityToJson(_TopExpenseEntity instance) =>
    <String, dynamic>{
      'merchant': instance.merchant,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'category': instance.category,
    };

_TopMerchantEntity _$TopMerchantEntityFromJson(Map<String, dynamic> json) =>
    _TopMerchantEntity(
      name: json['name'] as String,
      visitCount: (json['visitCount'] as num).toInt(),
    );

Map<String, dynamic> _$TopMerchantEntityToJson(_TopMerchantEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'visitCount': instance.visitCount,
    };

_BudgetSummaryEntity _$BudgetSummaryEntityFromJson(Map<String, dynamic> json) =>
    _BudgetSummaryEntity(
      targetAmount: (json['targetAmount'] as num).toInt(),
      currentSpending: (json['currentSpending'] as num).toInt(),
      usagePercentage: (json['usagePercentage'] as num).toInt(),
    );

Map<String, dynamic> _$BudgetSummaryEntityToJson(
        _BudgetSummaryEntity instance) =>
    <String, dynamic>{
      'targetAmount': instance.targetAmount,
      'currentSpending': instance.currentSpending,
      'usagePercentage': instance.usagePercentage,
    };
