import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/couple_provider.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// 커플 가입 화면
///
/// 기능:
/// - 초대 코드 입력
/// - 초대 코드 유효성 검사
/// - 커플 가입 처리
class CoupleJoinScreen extends StatefulWidget {
  const CoupleJoinScreen({super.key});

  @override
  State<CoupleJoinScreen> createState() => _CoupleJoinScreenState();
}

class _CoupleJoinScreenState extends State<CoupleJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeController = TextEditingController();

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  String? _validateInviteCode(String? value) {
    if (value == null || value.isEmpty) {
      return '초대 코드를 입력하세요';
    }
    if (value.length < 6) {
      return '초대 코드는 최소 6자 이상이어야 합니다';
    }
    // 영숫자만 허용
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return '초대 코드는 영문자와 숫자만 포함할 수 있습니다';
    }
    return null;
  }

  Future<void> _handleJoin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final coupleProvider = context.read<CoupleProvider>();
    final inviteCode = _inviteCodeController.text.trim();

    await coupleProvider.joinCouple(inviteCode);

    if (!mounted) return;

    if (coupleProvider.status == CoupleStatus.success) {
      final partnerNickname = coupleProvider.couple?.user1.nickname ?? '파트너';

      // 성공 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: context.appColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: context.appColors.success,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '커플 연동 완료!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 12),
              Text(
                '$partnerNickname님과 커플 연동이 완료되었습니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 화면 닫기
              },
              child: Text('확인'),
            ),
          ],
        ),
      );
    } else if (coupleProvider.status == CoupleStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(coupleProvider.errorMessage ?? '커플 가입에 실패했습니다'),
          backgroundColor: context.appColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text('커플 가입'),
        backgroundColor: context.appColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                // 아이콘
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: context.appColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 60,
                    color: context.appColors.primary,
                  ),
                ),
                SizedBox(height: 32),

                // 설명 텍스트
                Text(
                  '파트너와 연동하기',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  '파트너에게 받은 초대 코드를 입력하세요.\n커플 연동 후 함께 가계부를 관리할 수 있습니다.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 초대 코드 입력 필드
                CustomTextField(
                  label: '초대 코드',
                  hintText: '초대 코드를 입력하세요',
                  controller: _inviteCodeController,
                  validator: _validateInviteCode,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 32),

                // 가입 버튼
                Consumer<CoupleProvider>(
                  builder: (context, coupleProvider, child) {
                    final isLoading =
                        coupleProvider.status == CoupleStatus.loading;

                    return ElevatedButton.icon(
                      onPressed: isLoading ? null : _handleJoin,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.link),
                      label: Text(isLoading ? '처리 중...' : '커플 연동하기'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    );
                  },
                ),

                SizedBox(height: 48),

                // 안내 사항
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.05),
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
                color: context.appColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                '안내 사항',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.primary,
                    ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildInfoItem('초대 코드는 7일간 유효합니다'),
          _buildInfoItem('이미 다른 커플에 연동되어 있다면 가입할 수 없습니다'),
          _buildInfoItem('커플 연동 후에는 설정에서 언제든지 해제할 수 있습니다'),
          _buildInfoItem('커플 모드에서는 파트너의 지출도 함께 확인할 수 있습니다'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
