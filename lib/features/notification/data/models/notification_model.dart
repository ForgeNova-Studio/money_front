import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 알림 응답 모델
///
/// API로부터 수신한 알림 데이터를 담는 객체입니다.
///
/// ## 주요 필드
/// - [notificationId]: 알림 고유 ID
/// - [title]: 알림 제목
/// - [message]: 알림 내용
/// - [type]: 알림 유형 (예: NOTICE, PERSONAL)
/// - [isRead]: 읽음 여부
@freezed
sealed class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String notificationId,
    required String title,
    required String message,
    required String type,
    required bool isRead,
    DateTime? createdAt, // TODO: 백엔드 saveAndFlush 배포 후 required로 원복
    DateTime? readAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// 알림 생성 요청 모델 (관리자용)
///
/// 새로운 알림을 생성할 때 서버로 전송하는 데이터 모델입니다.
///
/// ## 주요 필드
/// - [targetEmail]: 수신자 이메일
/// - [title]: 알림 제목
/// - [message]: 알림 내용
/// - [type]: 알림 유형 (기본값: PERSONAL)
@freezed
sealed class NotificationRequestModel with _$NotificationRequestModel {
  const factory NotificationRequestModel({
    required String targetEmail,
    required String title,
    required String message,
    @Default('PERSONAL') String type,
  }) = _NotificationRequestModel;

  factory NotificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestModelFromJson(json);
}

/// 읽지 않은 알림 개수 응답 모델
///
/// 읽지 않은 알림의 총 개수를 담고 있습니다.
@freezed
sealed class UnreadCountModel with _$UnreadCountModel {
  const factory UnreadCountModel({
    required int count,
  }) = _UnreadCountModel;

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountModelFromJson(json);
}
