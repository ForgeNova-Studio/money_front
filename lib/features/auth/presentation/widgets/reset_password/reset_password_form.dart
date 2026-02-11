import 'package:flutter/material.dart';
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/widgets/password_rule_checklist.dart';

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
