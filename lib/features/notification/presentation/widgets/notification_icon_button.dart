import 'package:flutter/material.dart';

/// 알림 아이콘 버튼 (읽지 않은 알림 뱃지 포함)
///
/// AppBar 등에서 사용할 수 있는 알림 아이콘 버튼입니다.
/// 읽지 않은 알림 개수가 0보다 크면 빨간색 뱃지로 개수를 표시합니다.
///
/// 사용 예시:
/// ```dart
/// NotificationIconButton(
///   unreadCount: 5,
///   onTap: () => context.push(RouteNames.notifications),
/// )
/// ```
class NotificationIconButton extends StatelessWidget {
  /// 읽지 않은 알림 개수
  final int unreadCount;

  /// 버튼 탭 시 콜백
  final VoidCallback onTap;

  const NotificationIconButton({
    super.key,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: colorScheme.onSurface,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
