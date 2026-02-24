// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core

// viewmodels
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_ui_event_view_model.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/find_password_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

// screens
import 'package:moamoa/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:moamoa/features/auth/presentation/widgets/find_password/find_password_title.dart';
import 'package:moamoa/features/auth/presentation/widgets/find_password/email_verification_form.dart';

/// 비밀번호 찾기(이메일 인증) 화면
///
/// 사용자가 비밀번호를 재설정하기 위해 이메일 인증을 수행하는 화면입니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일 입력 및 인증번호 전송 (`_handleSendVerificationCode`)
/// - 인증번호 입력 및 검증 (`_handleVerifyCode`)
/// - 인증 완료 후 비밀번호 재설정 화면(`ResetPasswordScreen`)으로 이동 (`_handleContinue`)
/// - `FindPasswordViewModel`을 통한 비즈니스 로직 처리
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// context.push(RouteNames.findPassword);
/// // or
/// const FindPasswordScreen();
/// ```
class FindPasswordScreen extends ConsumerStatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

/// [FindPasswordScreen]의 상태 관리 클래스
///
/// 이메일 및 인증번호 입력 필드의 컨트롤러를 관리하고,
/// ViewModel과 상호작용하여 인증 로직을 수행합니다.
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
    final result = await ref
        .read(findPasswordViewModelProvider.notifier)
        .requestVerificationCode(_emailController.text);

    if (!mounted) return;
    if (!result.success) {
      if (result.message != null) {
        context.showErrorToast(
          result.message!,
          duration: const Duration(seconds: 2),
        );
      }
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('인증번호가 전송되었습니다.')),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
      }
    });
  }

  // 인증번호 검증
  Future<void> _handleVerifyCode() async {
    final result = await ref
        .read(findPasswordViewModelProvider.notifier)
        .confirmVerificationCode(_verificationCodeController.text);

    if (!mounted) return;
    if (!result.success) {
      if (result.message != null) {
        context.showErrorToast(
          result.message!,
          duration: const Duration(seconds: 2),
        );
      }
      return;
    }

    context.showToast('인증번호가 확인되었습니다.');
  }

  void _handleContinue() {
    final result = ref
        .read(findPasswordViewModelProvider.notifier)
        .validateContinue(_verificationCodeController.text);

    if (!result.success) {
      if (result.message != null) {
        context.showErrorToast(
          result.message!,
          duration: const Duration(seconds: 2),
        );
      }
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
    // 인증 UI 이벤트 감지
    ref.listen(authUiEventViewModelProvider, (previous, next) {
      if (next == null) return;

      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      if (!isCurrent) return;

      if (next.type == AuthUiEventType.showErrorToast) {
        context.showErrorToast(next.message);
      }

      ref.read(authUiEventViewModelProvider.notifier).consume();
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
