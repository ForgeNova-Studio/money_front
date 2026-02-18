import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 관리자 알림 발송 FAB (Floating Action Button)
///
/// 확장 가능한 FAB로, 알림 발송 대상을 선택하는 메뉴를 제공합니다.
///
/// ## 주요 기능
/// - [onToggle]: FAB 확장/축소 토글
/// - [onSendToSpecificUser]: 특정 사용자에게 발송 메뉴 선택
/// - [onSendToAllUsers]: 전체 사용자에게 발송 메뉴 선택
/// - 로딩 상태 표시
///
/// ## 사용 예시
/// ```dart
/// AdminNotificationActionFab(
///   isExpanded: state.isFabExpanded,
///   isLoading: state.isSubmitting,
///   // ... callbacks
/// )
/// ```
class AdminNotificationActionFab extends StatelessWidget {
  final AppThemeColors appColors;
  final bool isExpanded;
  final bool isLoading;
  final VoidCallback onToggle;
  final VoidCallback onSendToSpecificUser;
  final VoidCallback onSendToAllUsers;

  const AdminNotificationActionFab({
    super.key,
    required this.appColors,
    required this.isExpanded,
    required this.isLoading,
    required this.onToggle,
    required this.onSendToSpecificUser,
    required this.onSendToAllUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpanded) ...[
          _FabMenuItem(
            label: '특정 사용자',
            icon: Icons.person_rounded,
            color: Colors.blue,
            onTap: isLoading ? null : onSendToSpecificUser,
          ),
          const SizedBox(height: 12),
          _FabMenuItem(
            label: '전체 사용자',
            icon: Icons.groups_rounded,
            color: Colors.green,
            onTap: isLoading ? null : onSendToAllUsers,
          ),
          const SizedBox(height: 16),
        ],
        FloatingActionButton(
          onPressed: isLoading ? null : onToggle,
          backgroundColor: isLoading ? appColors.gray300 : appColors.primary,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : AnimatedRotation(
                  turns: isExpanded ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.send_rounded, color: Colors.white),
                ),
        ),
      ],
    );
  }
}

/// FAB 메뉴 아이템 위젯
///
/// 확장된 FAB 메뉴의 개별 아이템을 표시합니다.
class _FabMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _FabMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
