import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';

/// 회원가입 화면 타이틀 위젯
///
/// 화면 상단에 "회원가입" 제목과 간단한 설명을 표시합니다.
///
/// **주요 기능 (Key Features):**
/// - 제목과 부제목 텍스트 렌더링
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// const RegisterTitle();
/// ```
class RegisterTitle extends StatelessWidget {
  const RegisterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '회원가입',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: context.appColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '새로운 계정을 생성합니다.',
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
