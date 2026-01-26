// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) =>
    _ExpenseModel(
      expenseId: json['expenseId'] as String?,
      userId: json['userId'] as String?,
      accountBookId: json['accountBookId'] as String?,
      fundingSource: json['fundingSource'] as String?,
      amount: (json['amount'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String?,
      merchant: json['merchant'] as String?,
      memo: json['memo'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAutoCategorized: json['isAutoCategorized'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      'expenseId': instance.expenseId,
      'userId': instance.userId,
      'accountBookId': instance.accountBookId,
      'fundingSource': instance.fundingSource,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'category': instance.category,
      'merchant': instance.merchant,
      'memo': instance.memo,
      'paymentMethod': instance.paymentMethod,
      'imageUrl': instance.imageUrl,
      'isAutoCategorized': instance.isAutoCategorized,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
