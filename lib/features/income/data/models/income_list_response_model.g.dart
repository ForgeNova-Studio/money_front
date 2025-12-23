// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncomeListResponseModel _$IncomeListResponseModelFromJson(
        Map<String, dynamic> json) =>
    _IncomeListResponseModel(
      incomes: (json['incomes'] as List<dynamic>)
          .map((e) => IncomeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$IncomeListResponseModelToJson(
        _IncomeListResponseModel instance) =>
    <String, dynamic>{
      'incomes': instance.incomes,
      'totalAmount': instance.totalAmount,
      'count': instance.count,
    };
