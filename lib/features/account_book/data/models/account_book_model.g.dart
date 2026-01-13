// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountBookModel _$AccountBookModelFromJson(Map<String, dynamic> json) =>
    _AccountBookModel(
      accountBookId: json['accountBookId'] as String?,
      name: json['name'] as String,
      bookType: json['bookType'] as String,
      coupleId: json['coupleId'] as String?,
      memberCount: (json['memberCount'] as num?)?.toInt(),
      description: json['description'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) =>
              AccountBookMemberInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountBookModelToJson(_AccountBookModel instance) =>
    <String, dynamic>{
      'accountBookId': instance.accountBookId,
      'name': instance.name,
      'bookType': instance.bookType,
      'coupleId': instance.coupleId,
      'memberCount': instance.memberCount,
      'description': instance.description,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'members': instance.members,
    };
