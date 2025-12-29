// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_monthly_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeMonthlyResponseModel _$HomeMonthlyResponseModelFromJson(
        Map<String, dynamic> json) =>
    _HomeMonthlyResponseModel(
      expenses: (json['expenses'] as List<dynamic>?)
              ?.map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      incomes: (json['incomes'] as List<dynamic>?)
              ?.map((e) => IncomeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HomeMonthlyResponseModelToJson(
        _HomeMonthlyResponseModel instance) =>
    <String, dynamic>{
      'expenses': instance.expenses,
      'incomes': instance.incomes,
    };
