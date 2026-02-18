import 'package:flutter/material.dart';

extension NotificationTypeUiX on String {
  IconData get notificationTypeIcon {
    switch (toUpperCase()) {
      case 'NOTICE':
        return Icons.campaign_rounded;
      case 'PERSONAL':
        return Icons.person_rounded;
      case 'UPDATE':
        return Icons.system_update_rounded;
      case 'EVENT':
        return Icons.celebration_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get notificationTypeColor {
    switch (toUpperCase()) {
      case 'NOTICE':
        return Colors.orange;
      case 'PERSONAL':
        return Colors.blue;
      case 'UPDATE':
        return Colors.green;
      case 'EVENT':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String get notificationTypeLabel {
    switch (toUpperCase()) {
      case 'NOTICE':
        return '공지';
      case 'PERSONAL':
        return '개인';
      case 'UPDATE':
        return '업데이트';
      case 'EVENT':
        return '이벤트';
      default:
        return '알림';
    }
  }
}
