import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';
import 'package:moamoa/features/notification/presentation/viewmodels/notification_view_model.dart';

/// 알림 목록 화면
class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 알림 목록 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModelProvider);
    final viewModel = ref.read(notificationViewModelProvider.notifier);

    return DefaultLayout(
      title: '알림',
      titleSpacing: 16,
      backgroundColor: context.appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      // 읽지 않은 개수 뱃지
      actions: state.unreadCount > 0
          ? [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.appColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${state.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]
          : null,
      child: _buildBody(context, state, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationState state,
    NotificationViewModel viewModel,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage!,
              style: TextStyle(color: context.appColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.refresh,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return _buildEmptyState(context);
    }

    // 날짜별 그룹핑
    final grouped = _groupByDate(state.notifications);

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        // 로딩 중이거나, 로딩이 끝났으면 안내 메시지를 위해 +1
        itemCount: grouped.length + 1,
        itemBuilder: (context, index) {
          // 마지막 아이템 (로딩 인디케이터 또는 안내 메시지)
          if (index == grouped.length) {
            if (state.hasMore) {
              viewModel.loadMore();
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              // 더 이상 불러올 데이터가 없으면 안내 메시지 표시
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: context.appColors.backgroundGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: context.appColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '공지는 최대 30일동안 보관되며 이후 사라집니다.',
                      style: TextStyle(
                        color: context.appColors.textTertiary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          final group = grouped[index];
          return _NotificationGroup(
            title: group.title,
            notifications: group.notifications,
            onNotificationTap: (notification) =>
                _showNotificationDetail(context, notification, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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

  /// 날짜별로 알림 그룹핑
  List<_NotificationGroupData> _groupByDate(
      List<NotificationEntity> notifications) {
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

    final groups = <_NotificationGroupData>[];
    if (todayList.isNotEmpty) {
      groups.add(_NotificationGroupData(title: '오늘', notifications: todayList));
    }
    if (thisWeekList.isNotEmpty) {
      groups.add(
          _NotificationGroupData(title: '이번 주', notifications: thisWeekList));
    }
    if (olderList.isNotEmpty) {
      groups.add(_NotificationGroupData(title: '이전', notifications: olderList));
    }

    return groups;
  }

  void _showNotificationDetail(
    BuildContext context,
    NotificationEntity notification,
    NotificationViewModel viewModel,
  ) {
    // 읽음 처리
    if (!notification.isRead) {
      viewModel.markAsRead(notification.id);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _NotificationDetailSheet(notification: notification),
    );
  }
}

/// 알림 그룹 데이터
class _NotificationGroupData {
  final String title;
  final List<NotificationEntity> notifications;

  _NotificationGroupData({required this.title, required this.notifications});
}

/// 알림 그룹 위젯
class _NotificationGroup extends StatelessWidget {
  final String title;
  final List<NotificationEntity> notifications;
  final void Function(NotificationEntity) onNotificationTap;

  const _NotificationGroup({
    required this.title,
    required this.notifications,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 타이틀
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 16, top: 16, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: appColors.textSecondary,
            ),
          ),
        ),
        // 알림 카드들
        Container(
          decoration: BoxDecoration(
            color: appColors.backgroundGray,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: notifications.asMap().entries.map((entry) {
              final index = entry.key;
              final notification = entry.value;
              final isLast = index == notifications.length - 1;

              return Column(
                children: [
                  _NotificationTile(
                    notification: notification,
                    onTap: () => onNotificationTap(notification),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: appColors.gray200,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// 알림 타일 위젯
class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 80, // 고정 높이
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 수직 중앙 정렬
          children: [
            // 알림 아이콘
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getTypeColor(notification.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(notification.type),
                color: _getTypeColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // 내용
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                      color: appColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: appColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 읽지 않음 표시 (빨간 점)
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toUpperCase()) {
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

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
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
}

/// 알림 상세 바텀시트 (모던 디자인)
class _NotificationDetailSheet extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationDetailSheet({required this.notification});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final typeColor = _getTypeColor(notification.type);

    return Container(
      decoration: BoxDecoration(
        color: appColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: appColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 헤더 영역 (타입 아이콘 + 색상 배경)
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
                // 타입 뱃지 + 날짜
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
                            _getTypeIcon(notification.type),
                            size: 14,
                            color: typeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getTypeLabel(notification.type),
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
                // 제목
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

          // 내용 영역
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
                // 닫기 버튼
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

  IconData _getTypeIcon(String type) {
    switch (type.toUpperCase()) {
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

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
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

  String _getTypeLabel(String type) {
    switch (type.toUpperCase()) {
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
