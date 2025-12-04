import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moneyflow/features/auth/presentation/screens/reset_password_screen.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  bool _isVerificationCodeSent = false;
  bool _isEmailVerified = false;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _handleSendVerificationCode() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일을 입력해주세요.')),
      );
      return;
    }

    // TODO: 이메일 인증번호 발송 로직 구현
    setState(() {
      _isVerificationCodeSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('인증번호가 발송되었습니다.')),
    );
  }

  void _handleVerifyCode() {
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증번호를 입력해주세요.')),
      );
      return;
    }

    // TODO: 인증번호 확인 로직 구현
    // 임시로 '123456'이면 성공으로 처리
    if (_verificationCodeController.text == '123456') {
      setState(() {
        _isEmailVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증번호가 올바르지 않습니다. (테스트: 123456)')),
      );
    }
  }

  void _handleContinue() {
    if (_isEmailVerified) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                '계정을 찾아볼까요?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '가입하신 이메일을 입력하고\n인증번호를 확인해주세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // 이메일 입력 필드
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: '이메일',
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isEmailVerified,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _isEmailVerified ? null : _handleSendVerificationCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        foregroundColor: AppColors.textWhite,
                        disabledBackgroundColor: AppColors.gray300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        _isEmailVerified ? '인증완료' : '인증요청',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (_isVerificationCodeSent && !_isEmailVerified) ...[
                const SizedBox(height: 12),
                // 인증번호 입력 필드
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _verificationCodeController,
                        hintText: '인증번호',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleVerifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary,
                          foregroundColor: AppColors.textWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          '인증확인',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isEmailVerified ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: AppColors.textWhite,
                    disabledBackgroundColor: AppColors.primaryPinkPale,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '계속하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
