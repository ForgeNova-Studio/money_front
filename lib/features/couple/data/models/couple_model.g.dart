// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoupleModel _$CoupleModelFromJson(Map<String, dynamic> json) => _CoupleModel(
      coupleId: json['coupleId'] as String,
      user1: json['user1'] == null
          ? null
          : CoupleUserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: json['user2'] == null
          ? null
          : CoupleUserModel.fromJson(json['user2'] as Map<String, dynamic>),
      inviteCode: json['inviteCode'] as String?,
      codeExpiresAt: json['codeExpiresAt'] == null
          ? null
          : DateTime.parse(json['codeExpiresAt'] as String),
      linked: json['linked'] as bool,
      linkedAt: json['linkedAt'] == null
          ? null
          : DateTime.parse(json['linkedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CoupleModelToJson(_CoupleModel instance) =>
    <String, dynamic>{
      'coupleId': instance.coupleId,
      'user1': instance.user1,
      'user2': instance.user2,
      'inviteCode': instance.inviteCode,
      'codeExpiresAt': instance.codeExpiresAt?.toIso8601String(),
      'linked': instance.linked,
      'linkedAt': instance.linkedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

_CoupleUserModel _$CoupleUserModelFromJson(Map<String, dynamic> json) =>
    _CoupleUserModel(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$CoupleUserModelToJson(_CoupleUserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'email': instance.email,
    };

_InviteModel _$InviteModelFromJson(Map<String, dynamic> json) => _InviteModel(
      inviteCode: json['inviteCode'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$InviteModelToJson(_InviteModel instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'message': instance.message,
    };

_JoinCoupleRequest _$JoinCoupleRequestFromJson(Map<String, dynamic> json) =>
    _JoinCoupleRequest(
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$JoinCoupleRequestToJson(_JoinCoupleRequest instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
    };
