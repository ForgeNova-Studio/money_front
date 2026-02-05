// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_monthly_comparison_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryComparisonModel _$CategoryComparisonModelFromJson(
        Map<String, dynamic> json) =>
    _CategoryComparisonModel(
      category: json['category'] as String,
      currentAmount: json['currentAmount'] as num,
      previousAmount: json['previousAmount'] as num,
      diff: json['diff'] as num,
      diffPercentage: json['diffPercentage'] as num?,
    );

Map<String, dynamic> _$CategoryComparisonModelToJson(
        _CategoryComparisonModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'currentAmount': instance.currentAmount,
      'previousAmount': instance.previousAmount,
      'diff': instance.diff,
      'diffPercentage': instance.diffPercentage,
    };

_CategoryMonthlyComparisonModel _$CategoryMonthlyComparisonModelFromJson(
        Map<String, dynamic> json) =>
    _CategoryMonthlyComparisonModel(
      accountBookId: json['accountBookId'] as String,
      accountBookName: json['accountBookName'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      currentMonthTotal: json['currentMonthTotal'] as num,
      previousMonthTotal: json['previousMonthTotal'] as num,
      categories: (json['categories'] as List<dynamic>)
          .map((e) =>
              CategoryComparisonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryMonthlyComparisonModelToJson(
        _CategoryMonthlyComparisonModel instance) =>
    <String, dynamic>{
      'accountBookId': instance.accountBookId,
      'accountBookName': instance.accountBookName,
      'year': instance.year,
      'month': instance.month,
      'currentMonthTotal': instance.currentMonthTotal,
      'previousMonthTotal': instance.previousMonthTotal,
      'categories': instance.categories,
    };
