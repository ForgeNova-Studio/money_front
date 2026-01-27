import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/couple/presentation/viewmodels/couple_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

class CoupleScreen extends ConsumerWidget {
  const CoupleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coupleViewModelProvider);

    return DefaultLayout(
      title: '커플 연동',
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
          : state.isLinked
              ? _LinkedCoupleView(state: state)
              : _NotLinkedView(),
    );
  }
}

/// 커플 연동된 상태 화면
class _LinkedCoupleView extends ConsumerWidget {
  final CoupleState state;

  const _LinkedCoupleView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couple = state.couple!;
    final partner = couple.user2 ?? couple.user1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 파트너 정보 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
            ),
            child: Column(
              children: [
                // 하트 아이콘
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pink.shade400,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '연동 완료',
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  partner?.displayName ?? '파트너',
                  style: TextStyle(
                    color: Colors.pink.shade900,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (partner?.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    partner!.email!,
                    style: TextStyle(
                      color: Colors.pink.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (couple.linkedAt != null)
                  Text(
                    '연동일: ${_formatDate(couple.linkedAt!)}',
                    style: TextStyle(
                      color: Colors.pink.shade500,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 안내 텍스트
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.appColors.textTertiary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '커플 연동 시 가계부를 함께 관리할 수 있어요.',
                    style: TextStyle(
                      color: context.appColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 연동 해제 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showUnlinkDialog(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '연동 해제',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showUnlinkDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('연동 해제'),
        content: const Text('정말 커플 연동을 해제하시겠습니까?\n해제 후에도 기존 데이터는 유지됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('해제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success =
          await ref.read(coupleViewModelProvider.notifier).unlinkCouple();
      if (context.mounted) {
        if (success) {
          // 가계부 목록 새로고침 (비활성화된 커플 가계부 제외)
          ref.invalidate(accountBooksProvider);

          // 홈 화면 데이터 새로고침
          ref.read(homeViewModelProvider.notifier).refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('커플 연동이 해제되었습니다.')),
          );
        } else {
          final error = ref.read(coupleViewModelProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? '오류가 발생했습니다.')),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// 커플 연동 안된 상태 화면
class _NotLinkedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // 일러스트
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              color: Colors.pink.shade300,
              size: 60,
            ),
          ),

          const SizedBox(height: 32),

          // 타이틀
          Text(
            '파트너와 함께\n가계부를 관리해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '초대 코드를 공유하거나 받아서 연동하세요',
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 48),

          // 초대하기 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(RouteNames.coupleInvite),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '파트너 초대하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 코드 입력하기 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push(RouteNames.coupleJoin),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.pink,
                side: const BorderSide(color: Colors.pink),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.input, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '초대 코드 입력하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48),

          // 안내 텍스트
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
                      Icons.lightbulb_outline,
                      color: context.appColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '커플 연동 안내',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoItem('초대 코드는 24시간 동안 유효해요'),
                const SizedBox(height: 8),
                _buildInfoItem('연동 후 공유 가계부를 함께 관리할 수 있어요'),
                const SizedBox(height: 8),
                _buildInfoItem('언제든지 연동을 해제할 수 있어요'),
              ],
            ),
          ),
        ],
      ),
    );
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
