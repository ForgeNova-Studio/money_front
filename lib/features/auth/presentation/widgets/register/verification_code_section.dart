import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';

/// 인증번호 입력 섹션 위젯
///
/// 회원가입 화면에서 이메일 인증번호를 입력하고 확인하는 영역입니다.
///
/// **주요 기능 (Key Features):**
/// - 인증번호 입력 필드
/// - 인증 확인 버튼
/// - 인증번호 유효 시간 안내 문구
/// - "메일이 오지 않나요?" 도움말 링크
///
/// **파라미터 (Parameters):**
/// - [controller]: 인증번호 입력 필드 컨트롤러
/// - [focusNode]: 인증번호 입력 필드 포커스 노드
/// - [onVerify]: 인증 확인 버튼 클릭 콜백
/// - [onEmailNotReceived]: "메일이 오지 않나요?" 링크 클릭 콜백 (선택적)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// VerificationCodeSection(
///   controller: _codeController,
///   focusNode: _codeFocusNode,
///   onVerify: () => viewModel.verifyCode(_codeController.text),
///   onEmailNotReceived: _showHelpDialog,
/// )
/// ```
class VerificationCodeSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onVerify;

  const VerificationCodeSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onVerify,
    this.onEmailNotReceived,
  });

  final VoidCallback? onEmailNotReceived;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller,
                focusNode: focusNode,
                hintText: '인증번호',
                icon: Icons.lock_outline,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: onVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.inverseSurface,
                  foregroundColor: colorScheme.onInverseSurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  '인증확인',
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
        if (onEmailNotReceived != null) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onEmailNotReceived,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.appColors.textSecondary,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  '메일이 오지 않나요?',
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appColors.textSecondary,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
