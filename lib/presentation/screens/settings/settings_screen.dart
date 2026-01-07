import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';

import '../../../features/couple/presentation/providers/couple_provider.dart';
import '../../../features/couple/presentation/screens/couple_invite_screen.dart';
import '../../../features/couple/presentation/screens/couple_join_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';

/// 설정 화면
///
/// 기능:
/// - 커플 모드 토글
/// - 현재 커플 정보 표시
/// - 커플 초대/가입
/// - 커플 연동 해제
/// - 로그아웃
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // 현재 커플 정보 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoupleProvider>().loadCurrentCouple();
    });
  }

  Future<void> _handleUnlinkCouple() async {
    // 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('커플 연동 해제'),
        content: Text(
          '정말 커플 연동을 해제하시겠습니까?\n해제 후에도 각자의 지출 데이터는 유지됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: context.appColors.error,
            ),
            child: Text('해제'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final coupleProvider = context.read<CoupleProvider>();
    await coupleProvider.unlinkCouple();

    if (!mounted) return;

    if (coupleProvider.status == CoupleStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('커플 연동이 해제되었습니다'),
          backgroundColor: context.appColors.success,
        ),
      );
    } else if (coupleProvider.status == CoupleStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(coupleProvider.errorMessage ?? '커플 연동 해제에 실패했습니다'),
          backgroundColor: context.appColors.error,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그아웃'),
        content: Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: context.appColors.error,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // await context.read<AuthProvider>().logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: context.appColors.background,
        elevation: 0,
      ),
      body: Consumer<CoupleProvider>(
        builder: (context, coupleProvider, child) {
          final couple = coupleProvider.couple;
          final isLinked = couple?.linked ?? false;

          return ListView(
            children: [
              // 커플 모드 섹션
              _buildSectionHeader('커플 모드'),
              _buildCoupleStatusCard(couple, isLinked),
              const SizedBox(height: 8),

              if (!isLinked) ...[
                // 커플 연동되지 않은 경우
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: '파트너 초대하기',
                  subtitle: '초대 코드를 생성하여 파트너에게 공유',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoupleInviteScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.link,
                  title: '커플 가입하기',
                  subtitle: '파트너의 초대 코드로 연동',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoupleJoinScreen(),
                      ),
                    );
                  },
                ),
              ] else ...[
                // 커플 연동된 경우
                _buildMenuItem(
                  icon: Icons.link_off,
                  title: '커플 연동 해제',
                  subtitle: '파트너와의 연동을 해제합니다',
                  iconColor: context.appColors.error,
                  onTap: _handleUnlinkCouple,
                ),
              ],

              SizedBox(height: 24),

              // 계정 섹션
              _buildSectionHeader('계정'),
              _buildMenuItem(
                icon: Icons.logout,
                title: '로그아웃',
                iconColor: context.appColors.error,
                onTap: _handleLogout,
              ),

              const SizedBox(height: 24),

              // 앱 정보
              _buildSectionHeader('앱 정보'),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: '버전',
                subtitle: '1.0.0',
                onTap: null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: context.appColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildCoupleStatusCard(dynamic couple, bool isLinked) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isLinked
                      ? context.appColors.success.withValues(alpha: 0.1)
                      : context.appColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isLinked ? Icons.favorite : Icons.favorite_border,
                  color: isLinked ? context.appColors.success : context.appColors.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLinked ? '커플 연동 중' : '커플 미연동',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (isLinked && couple != null) ...[
                      SizedBox(height: 4),
                      Text(
                        '${couple.user1.nickname} & ${couple.user2?.nickname ?? '나'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isLinked)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.appColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '활성',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
          if (!isLinked) ...[
            SizedBox(height: 12),
            Text(
              '파트너와 연동하여 함께 가계부를 관리하세요',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: context.appColors.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (iconColor ?? context.appColors.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? context.appColors.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: context.appColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
