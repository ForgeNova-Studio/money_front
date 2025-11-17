import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/color_constants.dart';
import '../../providers/couple_provider.dart';

/// 커플 초대 화면
///
/// 기능:
/// - 초대 코드 생성
/// - 초대 코드 표시 및 복사
/// - 초대 코드 공유 (KakaoTalk, 문자 등)
/// - 초대 코드 만료 시간 표시
class CoupleInviteScreen extends StatefulWidget {
  const CoupleInviteScreen({super.key});

  @override
  State<CoupleInviteScreen> createState() => _CoupleInviteScreenState();
}

class _CoupleInviteScreenState extends State<CoupleInviteScreen> {
  @override
  void initState() {
    super.initState();
    // 기존 초대 코드가 있으면 표시하기 위해 현재 커플 정보 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoupleProvider>().loadCurrentCouple();
    });
  }

  Future<void> _generateInviteCode() async {
    final coupleProvider = context.read<CoupleProvider>();
    await coupleProvider.generateInviteCode();

    if (mounted && coupleProvider.status == CoupleStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('초대 코드가 생성되었습니다'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted && coupleProvider.status == CoupleStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(coupleProvider.errorMessage ?? '초대 코드 생성에 실패했습니다'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('초대 코드가 클립보드에 복사되었습니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareInviteCode(String code) {
    final message = '''
MoneyFlow 커플 연동 초대

초대 코드: $code

MoneyFlow 앱에서 위 초대 코드를 입력하여 커플 연동을 완료하세요!
초대 코드는 7일 후 만료됩니다.
''';
    Share.share(message);
  }

  String _formatExpiryTime(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.isNegative) {
      return '만료됨';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}일 후 만료';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 후 만료';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 후 만료';
    } else {
      return '곧 만료';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('커플 초대'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<CoupleProvider>(
          builder: (context, coupleProvider, child) {
            final isLoading = coupleProvider.status == CoupleStatus.loading;
            final inviteResponse = coupleProvider.inviteResponse;
            final couple = coupleProvider.couple;

            // 이미 커플 연동이 완료된 경우
            if (couple != null && couple.linked) {
              return _buildAlreadyLinkedView(couple.user2?.nickname ?? '파트너');
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // 아이콘
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 설명 텍스트
                  Text(
                    '파트너 초대하기',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '초대 코드를 생성하여 파트너에게 공유하세요.\n파트너가 코드를 입력하면 커플 연동이 완료됩니다.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 초대 코드 표시 또는 생성 버튼
                  if (inviteResponse != null || (couple != null && couple.inviteCode != null))
                    _buildInviteCodeCard(
                      code: inviteResponse?.inviteCode ?? couple!.inviteCode!,
                      expiresAt: inviteResponse?.expiresAt ?? couple!.codeExpiresAt!,
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _generateInviteCode,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.add_circle_outline),
                      label: Text(isLoading ? '생성 중...' : '초대 코드 생성'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                  if (inviteResponse != null || (couple != null && couple.inviteCode != null)) ...[
                    const SizedBox(height: 16),
                    // 새로운 코드 생성 버튼
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _generateInviteCode,
                      icon: const Icon(Icons.refresh),
                      label: const Text('새 초대 코드 생성'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],

                  const SizedBox(height: 48),

                  // 안내 사항
                  _buildInfoCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInviteCodeCard({required String code, required DateTime expiresAt}) {
    final isExpired = expiresAt.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isExpired ? AppColors.error.withValues(alpha: 0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpired ? AppColors.error : AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '초대 코드',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          // 초대 코드 (크고 굵게)
          Text(
            code,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: isExpired ? AppColors.error : AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          // 만료 시간
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isExpired
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatExpiryTime(expiresAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isExpired ? AppColors.error : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          // 복사 및 공유 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isExpired ? null : () => _copyToClipboard(code),
                  icon: const Icon(Icons.copy, size: 20),
                  label: const Text('복사'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isExpired ? null : () => _shareInviteCode(code),
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('공유'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '안내 사항',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem('초대 코드는 7일간 유효합니다'),
          _buildInfoItem('한 번에 한 명의 파트너만 연동 가능합니다'),
          _buildInfoItem('파트너가 코드를 입력하면 자동으로 연동됩니다'),
          _buildInfoItem('새 코드를 생성하면 이전 코드는 무효화됩니다'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlreadyLinkedView(String partnerNickname) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '커플 연동 완료',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '$partnerNickname님과 이미 연동되어 있습니다',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
