import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/config/admin_config.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/states/auth_state.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/notification/presentation/viewmodels/notification_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final notificationState = ref.watch(notificationViewModelProvider);
    final unreadCount = notificationState.unreadCount;

    return DefaultLayout(
      title: '더보기',
      automaticallyImplyLeading: false,
      actions: [
        // 공지사항 리스트 버튼
        _NotificationIconButton(
          unreadCount: unreadCount,
          onTap: () => context.push(RouteNames.notifications),
        ),
        const SizedBox(width: 16),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Section
            _ProfileCard(authState: authState),
            const SizedBox(height: 16),

            // 2. 가계부 서비스 Section
            _MenuSection(
              title: '가계부 서비스',
              items: [
                _MenuItem(
                  icon: Icons.book_outlined,
                  iconColor: Colors.blue,
                  label: '가계부 관리',
                  onTap: () => context.push(RouteNames.accountBookList),
                ),
                _MenuItem(
                  icon: Icons.calculate_outlined,
                  iconColor: Colors.orange,
                  label: 'N빵 정산',
                  onTap: () {
                    // TODO: 정산 화면으로 이동
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('정산 기능 준비 중입니다.')),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.calendar_month_outlined,
                  iconColor: Colors.green,
                  label: '고정비 관리',
                  onTap: () {
                    // TODO: 고정비 관리 화면으로 이동
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('고정비 관리 기능 준비 중입니다.')),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.bar_chart_outlined,
                  iconColor: Colors.purple,
                  label: '통계',
                  onTap: () => context.push(RouteNames.statistics),
                ),
                _MenuItem(
                  icon: Icons.auto_awesome,
                  iconColor: Colors.amber,
                  label: '월간 리포트',
                  onTap: () {
                    final now = DateTime.now();
                    // 이번 달 1일 이전이면 전월 리포트, 아니면 이번 달 리포트
                    final reportMonth = now.day <= 7 
                        ? (now.month == 1 ? 12 : now.month - 1)
                        : now.month;
                    final reportYear = now.day <= 7 && now.month == 1
                        ? now.year - 1
                        : now.year;
                    context.push('${RouteNames.monthlyReport}?year=$reportYear&month=$reportMonth');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. 연결 서비스 Section
            _MenuSection(
              title: '연결 서비스',
              items: [
                _MenuItem(
                  icon: Icons.favorite_outline,
                  iconColor: Colors.pink,
                  label: '커플 연동',
                  onTap: () => context.push(RouteNames.couple),
                ),
                _MenuItem(
                  icon: Icons.receipt_long_outlined,
                  iconColor: Colors.teal,
                  label: '영수증 스캔',
                  onTap: () => context.push(RouteNames.ocrTest),
                ),
                _MenuItem(
                  icon: Icons.auto_awesome_outlined,
                  iconColor: Colors.indigo,
                  label: '자동 가계부 (iOS)',
                  onTap: () => context.push(RouteNames.shortcutsGuide),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. 내 정보 Section
            _MenuSection(
              title: '내 정보',
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  iconColor: colorScheme.onSurface,
                  label: '프로필 수정',
                  onTap: () {
                    // TODO: 프로필 수정 화면으로 이동
                  },
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  iconColor: colorScheme.onSurface,
                  label: '알림 설정',
                  onTap: () => _handleNotificationSettings(context),
                ),
                _MenuItem(
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  label: '로그아웃',
                  onTap: () => _handleLogout(context, ref),
                ),
              ],
            ),

            // 5. 관리자 메뉴 (히든 - 관리자 계정만 표시)
            if (AdminConfig.isAdmin(authState.user?.email))
              Column(
                children: [
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: '관리자',
                    items: [
                      _MenuItem(
                        icon: Icons.admin_panel_settings,
                        iconColor: Colors.red,
                        label: '공지 작성',
                        onTap: () => context.push(RouteNames.adminNotification),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 32),

            // 5. App Info
            Center(
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final info = snapshot.data;
                  final label = info == null
                      ? '${AppConstants.appName}'
                      : '${info.appName} v${info.version}';
                  return Text(
                    label,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await ref.read(authViewModelProvider.notifier).logout();
        if (context.mounted) {
          context.go(RouteNames.login);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그아웃 실패: $e')),
          );
        }
      }
    }
  }

  /// 알림 설정 처리
  Future<void> _handleNotificationSettings(BuildContext context) async {
    // OneSignal 권한 상태 확인
    final permission = await OneSignal.Notifications.permission;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림 설정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  permission
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: permission ? Colors.green : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    permission ? '푸시 알림이 활성화되어 있습니다.' : '푸시 알림이 비활성화되어 있습니다.',
                    style: TextStyle(
                      color: permission ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '알림 설정을 변경하려면 기기 설정에서 변경해주세요.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // 권한이 없는 경우(Never Prompted 포함) 먼저 권한 요청을 시도
              // Never Prompted 상태라면 시스템 팝업이 표시됨 -> OS에 앱 등록
              if (!permission) {
                debugPrint('권한이 없습니다.');
                // fallbackToSettings: false로 설정하여 OneSignal 기본 다이얼로그(영어) 비활성화
                // 거부 시 아래 openAppSettings()로 우리가 직접 제어
                final result =
                    await OneSignal.Notifications.requestPermission(false);
                // 팝업에서 '허용'을 눌렀다면 굳이 설정 화면으로 보낼 필요 없음
                if (result) return;
              }

              // '거부'했거나 이미 거부된 상태라면 OS 설정 화면으로 이동
              await openAppSettings();
            },
            child: const Text('설정 열기'),
          ),
        ],
      ),
    );
  }
}

/// 프로필 카드 위젯
class _ProfileCard extends StatelessWidget {
  final AuthState authState;

  const _ProfileCard({required this.authState});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = authState.user;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 32,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.email ?? '사용자',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '프리미엄',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

/// 메뉴 섹션 위젯
class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: items.map((item) => _MenuItemTile(item: item)).toList(),
          ),
        ),
      ],
    );
  }
}

/// 메뉴 아이템
class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}

/// 메뉴 아이템 타일 위젯
class _MenuItemTile extends StatelessWidget {
  final _MenuItem item;

  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              item.label,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 알림 아이콘 버튼 (읽지 않은 알림 뱃지 포함)
class _NotificationIconButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationIconButton({
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
