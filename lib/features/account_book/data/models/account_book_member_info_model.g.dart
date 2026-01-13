// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book_member_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountBookMemberInfoModel _$AccountBookMemberInfoModelFromJson(
        Map<String, dynamic> json) =>
    _AccountBookMemberInfoModel(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$AccountBookMemberInfoModelToJson(
        _AccountBookMemberInfoModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'email': instance.email,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };
