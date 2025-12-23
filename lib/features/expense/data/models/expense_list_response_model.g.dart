// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseListResponseModel _$ExpenseListResponseModelFromJson(
        Map<String, dynamic> json) =>
    _ExpenseListResponseModel(
      expenses: (json['expenses'] as List<dynamic>)
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$ExpenseListResponseModelToJson(
        _ExpenseListResponseModel instance) =>
    <String, dynamic>{
      'expenses': instance.expenses,
      'totalAmount': instance.totalAmount,
      'count': instance.count,
    };
