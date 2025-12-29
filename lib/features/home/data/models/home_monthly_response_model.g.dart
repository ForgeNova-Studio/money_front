// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_monthly_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeTransactionModel _$HomeTransactionModelFromJson(
        Map<String, dynamic> json) =>
    _HomeTransactionModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      title: json['title'] as String,
      category: json['category'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$HomeTransactionModelToJson(
        _HomeTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'title': instance.title,
      'category': instance.category,
      'time': instance.time,
    };

_DailyTransactionSummaryModel _$DailyTransactionSummaryModelFromJson(
        Map<String, dynamic> json) =>
    _DailyTransactionSummaryModel(
      date: json['date'] as String,
      totalIncome: (json['totalIncome'] as num).toInt(),
      totalExpense: (json['totalExpense'] as num).toInt(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => HomeTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyTransactionSummaryModelToJson(
        _DailyTransactionSummaryModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'transactions': instance.transactions,
    };
