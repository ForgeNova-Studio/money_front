import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';
import 'package:moamoa/features/notification/presentation/providers/notification_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_view_model.g.dart';

/// 알림 화면 상태
class NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.currentPage = 0,
    this.errorMessage,
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  @override
  NotificationState build() {
    // 초기 데이터 로드
    Future.microtask(() {
      loadNotifications();
      loadUnreadCount();
    });
    return const NotificationState(isLoading: true);
  }

  /// 알림 목록 조회
  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final notifications = await repository.getNotifications(page: 0);
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
        currentPage: 0,
        hasMore: notifications.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '알림을 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 추가 로드 (페이징)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final nextPage = state.currentPage + 1;
      final moreNotifications =
          await repository.getNotifications(page: nextPage);
      state = state.copyWith(
        notifications: [...state.notifications, ...moreNotifications],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: moreNotifications.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// 읽지 않은 알림 개수 조회
  Future<void> loadUnreadCount() async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final count = await repository.getUnreadCount();
      state = state.copyWith(unreadCount: count);
    } catch (_) {}
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notificationId);

      // 로컬 상태 업데이트
      final updatedList = state.notifications.map((n) {
        if (n.id == notificationId && !n.isRead) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }
        return n;
      }).toList();

      state = state.copyWith(
        notifications: updatedList,
        unreadCount: (state.unreadCount - 1).clamp(0, 9999),
      );
    } catch (_) {}
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadNotifications();
    await loadUnreadCount();
  }
}
