import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/couple/presentation/viewmodels/couple_view_model.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;
import 'package:moamoa/features/common/widgets/default_layout.dart';

class CoupleInviteScreen extends ConsumerStatefulWidget {
  const CoupleInviteScreen({super.key});

  @override
  ConsumerState<CoupleInviteScreen> createState() => _CoupleInviteScreenState();
}

class _CoupleInviteScreenState extends ConsumerState<CoupleInviteScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 초대 코드 생성
    Future.microtask(() {
      ref.read(coupleViewModelProvider.notifier).generateInviteCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coupleViewModelProvider);

    return DefaultLayout(
      title: '파트너 초대',
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
            return;
          }
          context.go(RouteNames.settings);
        },
      ),
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? _ErrorView(
                  message: state.errorMessage!,
                  onRetry: () => ref
                      .read(coupleViewModelProvider.notifier)
                      .generateInviteCode(),
                )
              : _InviteCodeView(state: state),
    );
  }
}

class _InviteCodeView extends StatelessWidget {
  final CoupleState state;

  const _InviteCodeView({required this.state});

  @override
  Widget build(BuildContext context) {
    final inviteInfo = state.inviteInfo;
    final colorScheme = Theme.of(context).colorScheme;

    if (inviteInfo == null) {
      return const Center(child: Text('초대 코드를 생성할 수 없습니다.'));
    }

    final inviteCode = inviteInfo.inviteCode;
    final expiresAt = inviteInfo.expiresAt;
    final remainingTime = expiresAt.difference(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // 아이콘
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard,
              color: Colors.pink.shade400,
              size: 48,
            ),
          ),

          const SizedBox(height: 32),

          // 안내 텍스트
          Text(
            '파트너에게 아래 코드를 공유하세요',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '코드 입력 후 연동이 완료됩니다',
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 40),

          // 초대 코드 박스
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade100,
                  Colors.pink.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.pink.shade200,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '초대 코드',
                  style: TextStyle(
                    color: Colors.pink.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  inviteCode,
                  style: TextStyle(
                    color: Colors.pink.shade900,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatRemainingTime(remainingTime),
                    style: TextStyle(
                      color: remainingTime.inHours < 1
                          ? Colors.red
                          : Colors.pink.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 복사 및 공유 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyCode(context, inviteCode),
                  icon: const Icon(Icons.copy, size: 20),
                  label: const Text('복사'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink,
                    side: const BorderSide(color: Colors.pink),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareCode(inviteCode),
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('공유하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 안내 사항
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.appColors.textTertiary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '안내',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoItem('초대 코드는 24시간 동안 유효합니다'),
                const SizedBox(height: 6),
                _buildInfoItem('파트너가 코드를 입력하면 자동으로 연동됩니다'),
                const SizedBox(height: 6),
                _buildInfoItem('코드는 1회만 사용할 수 있습니다'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('초대 코드가 복사되었습니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareCode(String code) {
    SharePlus.instance.share(
      ShareParams(
        text: '모아모아에서 함께 가계부를 관리해요!\n\n초대 코드: $code\n\n앱에서 초대 코드를 입력해주세요.',
        subject: '모아모아 커플 초대',
      ),
    );
  }

  String _formatRemainingTime(Duration duration) {
    if (duration.isNegative) {
      return '만료됨';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours시간 $minutes분 남음';
    } else if (minutes > 0) {
      return '$minutes분 남음';
    } else {
      return '곧 만료됩니다';
    }
  }

  Widget _buildInfoItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade300,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
