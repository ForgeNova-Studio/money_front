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

// viewmodels
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/find_password_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

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
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      context.showErrorToast(
        '비밀번호를 입력해주세요.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final passwordError = InputValidator.getPasswordErrorMessage(
      password,
      requireUppercase: true,
      requireSpecialChar: true,
    );
    if (passwordError.isNotEmpty) {
      context.showErrorToast(
        passwordError,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (password != confirmPassword) {
      context.showErrorToast(
        '비밀번호가 일치하지 않습니다.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // FindPasswordViewModel에서 email 가져오기
      final email = ref.read(findPasswordViewModelProvider).email;

      // AuthViewModel의 resetPassword 메서드 호출
      await ref.read(authViewModelProvider.notifier).resetPassword(
            email: email,
            newPassword: _passwordController.text,
          );

      if (mounted) {
        context.showToast('비밀번호가 성공적으로 변경되었습니다.');

        // 로그인 화면으로 이동 (스택 초기화)
        context.go(RouteNames.login);
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // try-catch는 UnhandledException 방지용
    }
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

    return PopScope(
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
    );
  }
}
