import 'package:flutter/material.dart';

import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';

/// 이메일 인증 요청 행 위젯
///
/// 이메일 입력 필드와 인증 요청 버튼을 가로로 배치한 위젯입니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일 입력 및 수정
/// - 인증 번호 전송 요청 버튼
/// - 인증 완료 상태에 따른 UI 변경 (버튼 비활성화, 텍스트 변경)
///
/// **파라미터 (Parameters):**
/// - [controller]: 이메일 입력 필드 컨트롤러
/// - [isEmailVerified]: 이메일 인증 완료 여부
/// - [onRequest]: 인증 요청 버튼 클릭 시 콜백
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// EmailVerificationRow(
///   controller: emailController,
///   isEmailVerified: state.isEmailVerified,
///   onRequest: () => viewModel.sendVerificationCode(email),
/// )
/// ```
class EmailVerificationRow extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmailVerified;
  final VoidCallback onRequest;

  const EmailVerificationRow({
    super.key,
    required this.controller,
    required this.isEmailVerified,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextField(
            controller: controller,
            hintText: '이메일',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: !isEmailVerified,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isEmailVerified ? null : onRequest,
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
              isEmailVerified ? '인증완료' : '인증요청',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
