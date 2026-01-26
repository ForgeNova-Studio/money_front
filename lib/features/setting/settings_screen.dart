import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/states/auth_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '더보기',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        // 임시 주석
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
        //     onPressed: () {
        //       // TODO: 앱 설정 화면으로 이동
        //     },
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      body: SingleChildScrollView(
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
                  onTap: () => context.push(RouteNames.accountBookCreate),
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
                  onTap: () {
                    // TODO: 알림 설정 화면으로 이동
                  },
                ),
                _MenuItem(
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  label: '로그아웃',
                  onTap: () => _handleLogout(context, ref),
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
