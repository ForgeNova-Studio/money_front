import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';
import 'package:moamoa/features/notification/presentation/models/notification_filter_type.dart';
import 'package:moamoa/features/notification/presentation/models/notification_group_data.dart';
import 'package:moamoa/features/notification/presentation/viewmodels/notification_view_model.dart';
import 'package:moamoa/features/notification/presentation/widgets/notification_list/notification_detail_sheet.dart';
import 'package:moamoa/features/notification/presentation/widgets/notification_list/notification_empty_state.dart';
import 'package:moamoa/features/notification/presentation/widgets/notification_list/notification_filter_tabs.dart';
import 'package:moamoa/features/notification/presentation/widgets/notification_list/notification_group_section.dart';

/// 알림 목록 화면
class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  NotificationFilterType _selectedFilter = NotificationFilterType.all;

  @override
  void initState() {
    super.initState();
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
      child: Column(
        children: [
          NotificationFilterTabs(
            selectedType: _selectedFilter,
            onChanged: (type) => setState(() => _selectedFilter = type),
          ),
          Expanded(child: _buildBody(context, state, viewModel)),
        ],
      ),
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
      return _buildErrorState(context, state.errorMessage!, viewModel.refresh);
    }

    final filteredNotifications = state.notifications
        .where((notification) => _selectedFilter.matches(notification.type))
        .toList();

    if (filteredNotifications.isEmpty) {
      return const NotificationEmptyState();
    }

    final grouped = groupNotificationsByDate(filteredNotifications);

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: grouped.length + 1,
        itemBuilder: (context, index) {
          if (index == grouped.length) {
            return _buildListFooter(context, state, viewModel);
          }

          final group = grouped[index];
          return NotificationGroupSection(
            title: group.title,
            notifications: group.notifications,
            onNotificationTap: (notification) =>
                _showNotificationDetail(context, notification, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    Future<void> Function() onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(color: context.appColors.error),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildListFooter(
    BuildContext context,
    NotificationState state,
    NotificationViewModel viewModel,
  ) {
    if (state.hasMore) {
      viewModel.loadMore();
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

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

  void _showNotificationDetail(
    BuildContext context,
    NotificationEntity notification,
    NotificationViewModel viewModel,
  ) {
    if (!notification.isRead) {
      viewModel.markAsRead(notification.id);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationDetailSheet(notification: notification),
    );
  }
}
