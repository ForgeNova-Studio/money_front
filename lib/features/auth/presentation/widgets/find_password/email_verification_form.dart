import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/find_password_view_model.dart';

class EmailVerificationForm extends ConsumerStatefulWidget {
  final TextEditingController emailController;
  final TextEditingController verificationCodeController;
  final FocusNode verificationCodeFocusNode;
  final VoidCallback onSendVerificationCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onContinue;

  const EmailVerificationForm({
    super.key,
    required this.emailController,
    required this.verificationCodeController,
    required this.verificationCodeFocusNode,
    required this.onSendVerificationCode,
    required this.onVerifyCode,
    required this.onContinue,
  });

  @override
  ConsumerState<EmailVerificationForm> createState() =>
      _EmailVerificationFormState();
}

class _EmailVerificationFormState extends ConsumerState<EmailVerificationForm> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final formState = ref.watch(findPasswordViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이메일 입력 필드
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                controller: widget.emailController,
                hintText: '이메일',
                keyboardType: TextInputType.emailAddress,
                enabled: !formState.isVerificationCodeSent,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed:
                    formState.isVerificationCodeSent || authState.isLoading
                        ? null
                        : widget.onSendVerificationCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor: colorScheme.surfaceContainerHighest,
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
                  controller: widget.verificationCodeController,
                  focusNode: widget.verificationCodeFocusNode,
                  hintText: '인증번호',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                  enabled: !formState.isEmailVerified,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: formState.isEmailVerified || authState.isLoading
                      ? null
                      : widget.onVerifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.inverseSurface,
                    foregroundColor: colorScheme.onInverseSurface,
                    disabledBackgroundColor:
                        colorScheme.surfaceContainerHighest,
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

          const SizedBox(height: 8),

          // 인증번호 유효 시간 안내
          Padding(
            padding: const EdgeInsets.only(left: 4),
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

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: formState.canContinue && !authState.isLoading
                ? widget.onContinue
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.primaryContainer,
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
    );
  }
}
