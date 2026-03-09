import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';

/// 날짜별 알림 그룹 데이터
///
/// 알림 목록을 날짜별(오늘, 이번 주, 이전)로 그룹화하여 표시하기 위한 데이터 구조입니다.
class NotificationGroupData {
  final String title;
  final List<NotificationEntity> notifications;

  const NotificationGroupData({
    required this.title,
    required this.notifications,
  });
}

/// 알림 목록 날짜별 그룹화 함수
///
/// 주어진 알림 목록을 [오늘], [이번 주], [이전]으로 분류하여 그룹화된 리스트를 반환합니다.
///
/// - [notifications]: 그룹화할 알림 엔티티 리스트
///
/// Returns: 그룹화된 [NotificationGroupData] 리스트
List<NotificationGroupData> groupNotificationsByDate(
  List<NotificationEntity> notifications,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final weekAgo = today.subtract(const Duration(days: 7));

  final todayList = <NotificationEntity>[];
  final thisWeekList = <NotificationEntity>[];
  final olderList = <NotificationEntity>[];

  for (final notification in notifications) {
    final notificationDate = DateTime(
      notification.createdAt.year,
      notification.createdAt.month,
      notification.createdAt.day,
    );

    if (notificationDate == today) {
      todayList.add(notification);
    } else if (notificationDate.isAfter(weekAgo)) {
      thisWeekList.add(notification);
    } else {
      olderList.add(notification);
    }
  }

  final groups = <NotificationGroupData>[];
  if (todayList.isNotEmpty) {
    groups.add(
      NotificationGroupData(title: '오늘', notifications: todayList),
    );
  }
  if (thisWeekList.isNotEmpty) {
    groups.add(
      NotificationGroupData(title: '이번 주', notifications: thisWeekList),
    );
  }
  if (olderList.isNotEmpty) {
    groups.add(
      NotificationGroupData(title: '이전', notifications: olderList),
    );
  }

  return groups;
}
