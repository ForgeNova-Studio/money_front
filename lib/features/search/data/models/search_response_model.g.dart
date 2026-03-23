// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResponseModel _$SearchResponseModelFromJson(Map<String, dynamic> json) =>
    _SearchResponseModel(
      transactions: (json['transactions'] as List<dynamic>)
          .map(
              (e) => SearchTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$SearchResponseModelToJson(
        _SearchResponseModel instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
    };

_SearchTransactionModel _$SearchTransactionModelFromJson(
        Map<String, dynamic> json) =>
    _SearchTransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      title: json['title'] as String,
      category: json['category'] as String,
      memo: json['memo'] as String?,
      date: json['date'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$SearchTransactionModelToJson(
        _SearchTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'title': instance.title,
      'category': instance.category,
      'memo': instance.memo,
      'date': instance.date,
      'time': instance.time,
    };
