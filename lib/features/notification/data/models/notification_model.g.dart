// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      notificationId: json['notificationId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };

_NotificationRequestModel _$NotificationRequestModelFromJson(
        Map<String, dynamic> json) =>
    _NotificationRequestModel(
      targetUserId: json['targetUserId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String? ?? 'PERSONAL',
    );

Map<String, dynamic> _$NotificationRequestModelToJson(
        _NotificationRequestModel instance) =>
    <String, dynamic>{
      'targetUserId': instance.targetUserId,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
    };

_UnreadCountModel _$UnreadCountModelFromJson(Map<String, dynamic> json) =>
    _UnreadCountModel(
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$UnreadCountModelToJson(_UnreadCountModel instance) =>
    <String, dynamic>{
      'count': instance.count,
    };
