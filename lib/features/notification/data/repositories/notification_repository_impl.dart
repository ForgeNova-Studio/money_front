import 'package:moamoa/features/notification/data/datasources/remote/notification_remote_datasource.dart';
import 'package:moamoa/features/notification/data/models/notification_model.dart';
import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';

/// 알림 Repository
abstract class NotificationRepository {
  /// 알림 목록 조회
  Future<List<NotificationEntity>> getNotifications({
    int page = 0,
    int size = 20,
  });

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId);

  /// 읽지 않은 알림 개수 조회
  Future<int> getUnreadCount();

  /// 알림 발송 (관리자용 - 특정 사용자 이메일)
  Future<NotificationEntity> createNotification({
    required String targetEmail,
    required String title,
    required String message,
    String type = 'PERSONAL',
  });

  /// 전체 사용자에게 공지 발송 (관리자용)
  Future<void> sendNotificationToAll({
    required String title,
    required String message,
    String type = 'NOTICE',
  });
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 0,
    int size = 20,
  }) async {
    final models = await _remoteDataSource.getNotifications(
      page: page,
      size: size,
    );
    return models.map(_toEntity).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<int> getUnreadCount() async {
    return _remoteDataSource.getUnreadCount();
  }

  @override
  Future<NotificationEntity> createNotification({
    required String targetEmail,
    required String title,
    required String message,
    String type = 'PERSONAL',
  }) async {
    final request = NotificationRequestModel(
      targetEmail: targetEmail,
      title: title,
      message: message,
      type: type,
    );
    final model = await _remoteDataSource.createNotification(request);
    return _toEntity(model);
  }

  @override
  Future<void> sendNotificationToAll({
    required String title,
    required String message,
    String type = 'NOTICE',
  }) async {
    await _remoteDataSource.sendNotificationToAll(
      title: title,
      message: message,
      type: type,
    );
  }

  NotificationEntity _toEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.notificationId,
      title: model.title,
      message: model.message,
      type: model.type,
      isRead: model.isRead,
      createdAt: model.createdAt ??
          DateTime.now(), // TODO: 백엔드 saveAndFlush 배포 후 ?? 제거
      readAt: model.readAt,
    );
  }
}
