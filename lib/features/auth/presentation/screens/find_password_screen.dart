// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core

// viewmodels
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/find_password_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

// screens
import 'package:moamoa/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:moamoa/features/auth/presentation/widgets/find_password/find_password_title.dart';
import 'package:moamoa/features/auth/presentation/widgets/find_password/email_verification_form.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _verificationCodeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 이전 화면의 SnackBar 제거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.hideToast();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _verificationCodeFocusNode.dispose();
    super.dispose();
  }

  // 인증번호 전송
  Future<void> _handleSendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      context.showErrorToast(
        '이메일을 입력해주세요.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // FindPasswordViewModel의 sendVerificationCode 메서드 호출
      await ref
          .read(findPasswordViewModelProvider.notifier)
          .sendVerificationCode(_emailController.text);

      if (mounted) {
        // ScaffoldMessenger.of(context)
        //   ..hideCurrentSnackBar()
        //   ..showSnackBar(
        //     SnackBar(content: Text('인증번호가 전송되었습니다.')),
        //   );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('인증번호 안내'),
            content: const Text(
              '이메일 발송 서비스 준비 중입니다.\n\n인증번호: 000000\n\n위 인증번호를 입력해주세요.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
          }
        });
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // try-catch는 UnhandledException 방지용
    }
  }

  // 인증번호 검증
  void _handleVerifyCode() async {
    if (_verificationCodeController.text.isEmpty) {
      context.showErrorToast(
        '인증번호를 입력해주세요.',
        duration: const Duration(seconds: 2),
      );

      return;
    }

    // FindPasswordViewModel의 verifyCode 메서드 호출
    try {
      final isVerified = await ref
          .read(findPasswordViewModelProvider.notifier)
          .verifyCode(code: _verificationCodeController.text);

      if (mounted && isVerified) {
        context.showToast('인증번호가 확인되었습니다.');
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // try-catch는 UnhandledException 방지용
    }
  }

  void _handleContinue() {
    if (_verificationCodeController.text.isEmpty) {
      context.showErrorToast(
        '인증번호를 입력해주세요.',
        duration: const Duration(seconds: 2),
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
    final colorScheme = Theme.of(context).colorScheme;
    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 에러 발생 시
      if (next.errorMessage != null && !next.isLoading) {
        context.showErrorToast(next.errorMessage!);
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
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
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
                const FindPasswordTitle(),
                const SizedBox(height: 40),

                // 이메일 입력 및 인증 폼
                EmailVerificationForm(
                  emailController: _emailController,
                  verificationCodeController: _verificationCodeController,
                  verificationCodeFocusNode: _verificationCodeFocusNode,
                  onSendVerificationCode: _handleSendVerificationCode,
                  onVerifyCode: _handleVerifyCode,
                  onContinue: _handleContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
