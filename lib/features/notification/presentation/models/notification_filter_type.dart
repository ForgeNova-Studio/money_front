import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

enum NotificationFilterType {
  all,
  notice,
  personal,
  update,
  event,
}

extension NotificationFilterTypeX on NotificationFilterType {
  String? get rawType {
    switch (this) {
      case NotificationFilterType.all:
        return null;
      case NotificationFilterType.notice:
        return 'NOTICE';
      case NotificationFilterType.personal:
        return 'PERSONAL';
      case NotificationFilterType.update:
        return 'UPDATE';
      case NotificationFilterType.event:
        return 'EVENT';
    }
  }

  String get label {
    switch (this) {
      case NotificationFilterType.all:
        return '전체';
      case NotificationFilterType.notice:
        return '공지';
      case NotificationFilterType.personal:
        return '개인';
      case NotificationFilterType.update:
        return '업데이트';
      case NotificationFilterType.event:
        return '이벤트';
    }
  }

  Color color(AppThemeColors appColors) {
    switch (this) {
      case NotificationFilterType.all:
        return appColors.primary;
      case NotificationFilterType.notice:
        return Colors.orange;
      case NotificationFilterType.personal:
        return Colors.blue;
      case NotificationFilterType.update:
        return Colors.green;
      case NotificationFilterType.event:
        return Colors.purple;
    }
  }

  bool matches(String type) {
    if (this == NotificationFilterType.all) return true;
    return type.toUpperCase() == rawType;
  }
}
