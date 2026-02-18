import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 알림 목록 빈 상태 위젯
///
/// 표시할 알림이 없을 때 보여주는 플레이스홀더 화면입니다.
///
/// ## 주요 기능
/// - 중앙 정렬된 아이콘 및 메시지 표시
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: context.appColors.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            '알림이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: context.appColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
