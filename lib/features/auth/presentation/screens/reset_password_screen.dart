// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core

import 'package:moamoa/core/validators/input_validator.dart';
import 'package:moamoa/router/route_names.dart';

// widgets
import 'package:moamoa/features/auth/presentation/widgets/reset_password/reset_password_title.dart';
import 'package:moamoa/features/auth/presentation/widgets/reset_password/reset_password_form.dart';
import 'package:moamoa/features/auth/presentation/widgets/auth_ui_event_listener.dart';

// viewmodels
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/find_password_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

/// 비밀번호 재설정 화면
///
/// 이메일 인증 완료 후, 새로운 비밀번호를 설정하는 화면입니다.
///
/// **주요 기능 (Key Features):**
/// - 새로운 비밀번호 입력 및 확인
/// - 비밀번호 복잡도 유효성 검사 (`InputValidator`)
/// - 비밀번호 재설정 요청 (`_handleResetPassword`)
/// - 재설정 완료 후 로그인 화면으로 이동
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
/// );
/// ```
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

/// [ResetPasswordScreen]의 상태 관리 클래스
///
/// 비밀번호 입력 필드 관리 및 유효성 검사 로직을 수행합니다.
class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _password = '';
  String _confirmPassword = '';
  String? _confirmError;

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final result =
        await ref.read(findPasswordViewModelProvider.notifier).resetPassword(
              newPassword: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            );

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

    context.showToast('비밀번호가 성공적으로 변경되었습니다.');
    context.go(RouteNames.login);
  }

  void _updatePassword(String value) {
    setState(() {
      _password = value;
      _confirmError = _resolveConfirmError(
        password: value,
        confirmPassword: _confirmPassword,
      );
    });
  }

  void _updateConfirmPassword(String value) {
    setState(() {
      _confirmPassword = value;
      _confirmError = _resolveConfirmError(
        password: _password,
        confirmPassword: value,
      );
    });
  }

  String? _resolveConfirmError({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return null;
    }

    final isPasswordValid = InputValidator.isValidPassword(
      password,
      requireUppercase: true,
      requireSpecialChar: true,
    );
    if (!isPasswordValid) {
      return null;
    }

    return password == confirmPassword ? null : '비밀번호가 일치하지 않습니다.';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ViewModel 상태 구독
    final authState = ref.watch(authViewModelProvider);

    return AuthUiEventListener(
      child: PopScope(
        canPop: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              backgroundColor: colorScheme.surface,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const ResetPasswordTitle(),
                    const SizedBox(height: 40),
                    ResetPasswordForm(
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      password: _password,
                      confirmPassword: _confirmPassword,
                      confirmError: _confirmError,
                      onPasswordChanged: _updatePassword,
                      onConfirmPasswordChanged: _updateConfirmPassword,
                      onSubmit: _handleResetPassword,
                      isLoading: authState.isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
