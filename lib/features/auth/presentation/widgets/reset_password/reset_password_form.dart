import 'package:flutter/material.dart';
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/widgets/password_rule_checklist.dart';

/// 비밀번호 재설정 폼 위젯
///
/// 새로운 비밀번호를 입력하고 확인하는 폼입니다.
///
/// **주요 기능 (Key Features):**
/// - 새 비밀번호 및 확인 비밀번호 입력
/// - 비밀번호 가시성 토글
/// - 실시간 비밀번호 규칙 검사 (`PasswordRuleChecklist`)
/// - 비밀번호 일치 여부 등에 따른 에러 표시
/// - 비밀번호 변경 요청 버튼
///
/// **파라미터 (Parameters):**
/// - [passwordController]: 새 비밀번호 입력 컨트롤러
/// - [confirmPasswordController]: 비밀번호 확인 입력 컨트롤러
/// - [password]: 현재 입력된 비밀번호 (규칙 검사용)
/// - [confirmPassword]: 현재 입력된 비밀번호 확인 (일치 검사용)
/// - [confirmError]: 비밀번호 확인 에러 메시지
/// - [onPasswordChanged]: 비밀번호 변경 콜백
/// - [onConfirmPasswordChanged]: 비밀번호 확인 변경 콜백
/// - [onSubmit]: 변경 요청 콜백
/// - [isLoading]: 로딩 상태
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// ResetPasswordForm(
///   passwordController: _pwController,
///   confirmPasswordController: _confirmController,
///   // ... other params
///   onSubmit: _resetPassword,
/// )
/// ```
class ResetPasswordForm extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String password;
  final String confirmPassword;
  final String? confirmError;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const ResetPasswordForm({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.password,
    required this.confirmPassword,
    required this.confirmError,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

/// [ResetPasswordForm]의 상태 관리 클래스
///
/// 비밀번호 입력 필드의 가시성 상태를 관리합니다.
class _ResetPasswordFormState extends State<ResetPasswordForm> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CustomTextField(
          controller: widget.passwordController,
          hintText: '새 비밀번호',
          isPassword: true,
          isPasswordVisible: _isPasswordVisible,
          onChanged: widget.onPasswordChanged,
          onVisibilityToggle: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: widget.confirmPasswordController,
          hintText: '새 비밀번호 확인',
          isPassword: true,
          isPasswordVisible: _isConfirmPasswordVisible,
          errorText: widget.confirmError,
          onChanged: widget.onConfirmPasswordChanged,
          onVisibilityToggle: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 8),
        PasswordRuleChecklist(
          password: widget.password,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.primaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: widget.isLoading
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
    );
  }
}
