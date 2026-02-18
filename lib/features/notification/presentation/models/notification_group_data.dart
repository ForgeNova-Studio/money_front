import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';

class NotificationGroupData {
  final String title;
  final List<NotificationEntity> notifications;

  const NotificationGroupData({
    required this.title,
    required this.notifications,
  });
}

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
