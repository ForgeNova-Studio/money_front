// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

// widgets
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/find_password_view_model.dart';

// screens
import 'package:moneyflow/features/auth/presentation/screens/reset_password_screen.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 이전 화면의 SnackBar 제거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  // 인증번호 전송
  Future<void> _handleSendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('이메일을 입력해주세요.'),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    try {
      // FindPasswordViewModel의 sendVerificationCode 메서드 호출
      await ref
          .read(findPasswordViewModelProvider.notifier)
          .sendVerificationCode(_emailController.text);

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('인증번호가 전송되었습니다.')),
          );
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // try-catch는 UnhandledException 방지용
    }
  }

  // 인증번호 검증
  void _handleVerifyCode() async {
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('인증번호를 입력해주세요.'),
          backgroundColor: context.appColors.warning,
        ));

      return;
    }

    // FindPasswordViewModel의 verifyCode 메서드 호출
    try {
      final isVerified = await ref
          .read(findPasswordViewModelProvider.notifier)
          .verifyCode(code: _verificationCodeController.text);

      if (mounted && isVerified) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('인증번호가 확인되었습니다.')),
          );
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // try-catch는 UnhandledException 방지용
    }
  }

  void _handleContinue() {
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('인증번호를 입력해주세요.'),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    // reset_password_screen으로 이동 (상태관리를 통해 email과 verificationCode 공유)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 상태 구독
    final authState = ref.watch(authViewModelProvider);
    final formState = ref.watch(findPasswordViewModelProvider);

    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 에러 발생 시
      if (next.errorMessage != null && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        // 에러 메시지 표시 후 초기화
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.appColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: context.appColors.backgroundWhite,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColors.textPrimary),
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
                _buildTitle(context),
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
                        enabled: !formState.isVerificationCodeSent,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: formState.isVerificationCodeSent ||
                                authState.isLoading
                            ? null
                            : _handleSendVerificationCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appColors.primary,
                          foregroundColor: context.appColors.textWhite,
                          disabledBackgroundColor: context.appColors.gray300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          formState.isVerificationCodeSent ? '전송완료' : '인증요청',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (formState.isVerificationCodeSent) ...[
                  const SizedBox(height: 12),
                  // 인증번호 입력 필드
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _verificationCodeController,
                          hintText: '인증번호',
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.number,
                          enabled: !formState.isEmailVerified,
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: formState.isEmailVerified ||
                                  authState.isLoading
                              ? null
                              : _handleVerifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.appColors.textPrimary,
                            foregroundColor: context.appColors.textWhite,
                            disabledBackgroundColor: context.appColors.gray300,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            formState.isEmailVerified ? '인증완료' : '인증확인',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // 인증번호 유효 시간 안내
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      '※ 인증번호는 10분간 유효합니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.appColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: formState.canContinue && !authState.isLoading
                        ? _handleContinue
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.primary,
                      foregroundColor: context.appColors.textWhite,
                      disabledBackgroundColor: context.appColors.primaryPale,
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
      ),
    );
  }
}

Widget _buildTitle(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '계정을 찾아볼까요?',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: context.appColors.textPrimary,
          height: 1.3,
        ),
      ),
      SizedBox(height: 12),
      Text(
        '가입하신 이메일을 입력하고\n인증번호를 확인해주세요.',
        style: TextStyle(
          fontSize: 16,
          color: context.appColors.textSecondary,
          height: 1.5,
        ),
      ),
    ],
  );
}
