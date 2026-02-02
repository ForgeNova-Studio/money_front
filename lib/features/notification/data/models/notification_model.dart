import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 알림 응답 모델
@freezed
sealed class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String notificationId,
    required String title,
    required String message,
    required String type,
    required bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// 알림 생성 요청 모델 (관리자용)
@freezed
sealed class NotificationRequestModel with _$NotificationRequestModel {
  const factory NotificationRequestModel({
    required String targetUserId,
    required String title,
    required String message,
    @Default('PERSONAL') String type,
  }) = _NotificationRequestModel;

  factory NotificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestModelFromJson(json);
}

/// 읽지 않은 알림 개수 응답
@freezed
sealed class UnreadCountModel with _$UnreadCountModel {
  const factory UnreadCountModel({
    required int count,
  }) = _UnreadCountModel;

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountModelFromJson(json);
}
