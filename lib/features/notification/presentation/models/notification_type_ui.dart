import 'package:flutter/material.dart';

/// 알림 유형 UI 확장
///
/// 알림 유형 문자열(String)을 UI 표시에 적합한 아이콘, 색상, 라벨로 변환하는 기능을 제공합니다.
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
