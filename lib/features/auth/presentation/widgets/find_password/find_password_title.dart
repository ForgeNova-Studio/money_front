import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class FindPasswordTitle extends StatelessWidget {
  const FindPasswordTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '계정을 찾아볼까요?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.appColors.textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '가입하신 이메일을 입력하고\n인증번호를 확인해주세요.',
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
