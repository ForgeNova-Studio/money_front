import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';
import 'package:moamoa/features/notification/presentation/models/notification_type_ui.dart';

/// 알림 상세 내용 바텀 시트
///
/// 목록에서 알림을 선택했을 때 상세 내용을 보여주는 모달 시트입니다.
///
/// ## 주요 기능
/// - 알림 유형별 색상 및 아이콘 표시
/// - 알림 제목, 내용, 날짜 상세 표시
/// - 확인 버튼을 통한 닫기 기능
///
/// ## 사용 예시
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => NotificationDetailSheet(notification: notification),
/// );
/// ```
class NotificationDetailSheet extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDetailSheet({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final typeColor = notification.type.notificationTypeColor;

    return Container(
      decoration: BoxDecoration(
        color: appColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: appColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  typeColor.withValues(alpha: 0.15),
                  typeColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: typeColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            notification.type.notificationTypeIcon,
                            size: 14,
                            color: typeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.type.notificationTypeLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: appColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: appColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 15,
                    color: appColors.textPrimary,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: appColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return DateFormat('M월 d일').format(date);
  }
}
