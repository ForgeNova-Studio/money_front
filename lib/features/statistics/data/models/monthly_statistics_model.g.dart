// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryBreakdownModel _$CategoryBreakdownModelFromJson(
        Map<String, dynamic> json) =>
    _CategoryBreakdownModel(
      category: json['category'] as String,
      amount: json['amount'] as num,
      percentage: json['percentage'] as num,
    );

Map<String, dynamic> _$CategoryBreakdownModelToJson(
        _CategoryBreakdownModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'percentage': instance.percentage,
    };

_ComparisonDataModel _$ComparisonDataModelFromJson(Map<String, dynamic> json) =>
    _ComparisonDataModel(
      diff: json['diff'] as num,
      diffPercentage: json['diffPercentage'] as num,
    );

Map<String, dynamic> _$ComparisonDataModelToJson(
        _ComparisonDataModel instance) =>
    <String, dynamic>{
      'diff': instance.diff,
      'diffPercentage': instance.diffPercentage,
    };

_MonthlyStatisticsModel _$MonthlyStatisticsModelFromJson(
        Map<String, dynamic> json) =>
    _MonthlyStatisticsModel(
      accountBookId: json['accountBookId'] as String,
      accountBookName: json['accountBookName'] as String,
      totalAmount: json['totalAmount'] as num,
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>)
          .map(
              (e) => CategoryBreakdownModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      comparisonWithLastMonth: ComparisonDataModel.fromJson(
          json['comparisonWithLastMonth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonthlyStatisticsModelToJson(
        _MonthlyStatisticsModel instance) =>
    <String, dynamic>{
      'accountBookId': instance.accountBookId,
      'accountBookName': instance.accountBookName,
      'totalAmount': instance.totalAmount,
      'categoryBreakdown': instance.categoryBreakdown,
      'comparisonWithLastMonth': instance.comparisonWithLastMonth,
    };
