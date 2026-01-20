// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/core/validators/input_validator.dart';
import 'package:moneyflow/router/route_names.dart';

// widgets
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moneyflow/features/auth/presentation/widgets/password_rule_checklist.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/find_password_view_model.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _password = '';
  String _confirmPassword = '';
  String? _confirmError;

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('비밀번호를 입력해주세요.'),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    final passwordError = InputValidator.getPasswordErrorMessage(
      password,
      requireUppercase: true,
      requireSpecialChar: true,
    );
    if (passwordError.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(passwordError),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('비밀번호가 일치하지 않습니다.'),
            backgroundColor: context.appColors.warning,
          ),
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('비밀번호가 성공적으로 변경되었습니다.'),
              backgroundColor: context.appColors.success,
            ),
          );

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
                Text(
                  '비밀번호 재설정',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '새로운 비밀번호를 입력해주세요.',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.appColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _passwordController,
                  hintText: '새 비밀번호',
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onChanged: _updatePassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: '새 비밀번호 확인',
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  errorText: _confirmError,
                  onChanged: _updateConfirmPassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 8),
                PasswordRuleChecklist(
                  password: _password,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        authState.isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor: colorScheme.primaryContainer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: authState.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Text(
                            '비밀번호 변경',
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
    ),
    );
  }
}
