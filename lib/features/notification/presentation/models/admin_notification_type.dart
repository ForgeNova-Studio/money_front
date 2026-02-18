import 'package:flutter/material.dart';

/// 관리자 알림 유형 열거형
///
/// 관리자가 발송할 수 있는 알림의 종류를 정의합니다.
///
/// ## 종류
/// - [notice]: 공지사항
/// - [update]: 업데이트 소식
/// - [event]: 이벤트 알림
/// - [personal]: 개인 알림
enum AdminNotificationType {
  notice,
  update,
  event,
  personal,
}

extension AdminNotificationTypeX on AdminNotificationType {
  String get apiValue {
    switch (this) {
      case AdminNotificationType.notice:
        return 'NOTICE';
      case AdminNotificationType.update:
        return 'UPDATE';
      case AdminNotificationType.event:
        return 'EVENT';
      case AdminNotificationType.personal:
        return 'PERSONAL';
    }
  }

  String get label {
    switch (this) {
      case AdminNotificationType.notice:
        return '공지';
      case AdminNotificationType.update:
        return '업데이트';
      case AdminNotificationType.event:
        return '이벤트';
      case AdminNotificationType.personal:
        return '개인';
    }
  }

  IconData get icon {
    switch (this) {
      case AdminNotificationType.notice:
        return Icons.campaign_rounded;
      case AdminNotificationType.update:
        return Icons.system_update_rounded;
      case AdminNotificationType.event:
        return Icons.celebration_rounded;
      case AdminNotificationType.personal:
        return Icons.person_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AdminNotificationType.notice:
        return Colors.orange;
      case AdminNotificationType.update:
        return Colors.green;
      case AdminNotificationType.event:
        return Colors.purple;
      case AdminNotificationType.personal:
        return Colors.blue;
    }
  }
}
