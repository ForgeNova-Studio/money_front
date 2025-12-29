// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_monthly_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeTransactionModel _$HomeTransactionModelFromJson(
        Map<String, dynamic> json) =>
    _HomeTransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$HomeTransactionModelToJson(
        _HomeTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'category': instance.category,
      'type': instance.type,
    };

_DailyTransactionSummaryModel _$DailyTransactionSummaryModelFromJson(
        Map<String, dynamic> json) =>
    _DailyTransactionSummaryModel(
      date: DateTime.parse(json['date'] as String),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => HomeTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyTransactionSummaryModelToJson(
        _DailyTransactionSummaryModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'transactions': instance.transactions,
    };
