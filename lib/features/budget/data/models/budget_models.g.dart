// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetResponseModel _$BudgetResponseModelFromJson(Map<String, dynamic> json) =>
    _BudgetResponseModel(
      budgetId: json['budgetId'] as String,
      userId: json['userId'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentSpending: (json['currentSpending'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      usagePercentage: (json['usagePercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetResponseModelToJson(
        _BudgetResponseModel instance) =>
    <String, dynamic>{
      'budgetId': instance.budgetId,
      'userId': instance.userId,
      'year': instance.year,
      'month': instance.month,
      'targetAmount': instance.targetAmount,
      'currentSpending': instance.currentSpending,
      'remainingAmount': instance.remainingAmount,
      'usagePercentage': instance.usagePercentage,
    };

_AssetResponseModel _$AssetResponseModelFromJson(Map<String, dynamic> json) =>
    _AssetResponseModel(
      accountBookId: json['accountBookId'] as String,
      accountBookName: json['accountBookName'] as String,
      currentTotalAssets: (json['currentTotalAssets'] as num).toDouble(),
      initialBalance: (json['initialBalance'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      periodIncome: (json['periodIncome'] as num).toDouble(),
      periodExpense: (json['periodExpense'] as num).toDouble(),
      periodNetIncome: (json['periodNetIncome'] as num).toDouble(),
    );

Map<String, dynamic> _$AssetResponseModelToJson(_AssetResponseModel instance) =>
    <String, dynamic>{
      'accountBookId': instance.accountBookId,
      'accountBookName': instance.accountBookName,
      'currentTotalAssets': instance.currentTotalAssets,
      'initialBalance': instance.initialBalance,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'periodIncome': instance.periodIncome,
      'periodExpense': instance.periodExpense,
      'periodNetIncome': instance.periodNetIncome,
    };
