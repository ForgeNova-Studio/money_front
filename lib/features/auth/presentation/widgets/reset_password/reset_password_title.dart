import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class ResetPasswordTitle extends StatelessWidget {
  const ResetPasswordTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}
