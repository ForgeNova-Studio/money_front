import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:moamoa/core/validators/input_validator.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/widgets/password_rule_checklist.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

/// 비밀번호 변경 화면 (로그인 상태)
///
/// 설정 > 내 정보 > 비밀번호 변경에서 접근합니다.
/// 현재 비밀번호 확인 후 새 비밀번호로 변경합니다.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _newPassword = '';
  String _confirmPassword = '';
  String? _confirmError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      context.showErrorToast(
        '현재 비밀번호를 입력해주세요.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      context.showErrorToast(
        '새 비밀번호를 입력해주세요.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final passwordError = InputValidator.getPasswordErrorMessage(
      newPassword,
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

    if (newPassword != confirmPassword) {
      context.showErrorToast(
        '새 비밀번호가 일치하지 않습니다.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (currentPassword == newPassword) {
      context.showErrorToast(
        '현재 비밀번호와 동일한 비밀번호입니다.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      await ref.read(authViewModelProvider.notifier).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );

      if (mounted) {
        context.showToast('비밀번호가 변경되었습니다.');
        context.pop();
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리
    }
  }

  void _updateNewPassword(String value) {
    setState(() {
      _newPassword = value;
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
        password: _newPassword,
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
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null && !next.isLoading) {
        context.showErrorToast(next.errorMessage!);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return DefaultLayout(
      title: '비밀번호 변경',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // 현재 비밀번호
              Text(
                '현재 비밀번호',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _currentPasswordController,
                hintText: '현재 비밀번호 입력',
                isPassword: true,
                isPasswordVisible: _isCurrentPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 32),
              // 새 비밀번호
              Text(
                '새 비밀번호',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _newPasswordController,
                hintText: '새 비밀번호 입력',
                isPassword: true,
                isPasswordVisible: _isNewPasswordVisible,
                onChanged: _updateNewPassword,
                onVisibilityToggle: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
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
                password: _newPassword,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleChangePassword,
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
