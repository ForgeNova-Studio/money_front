import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 비밀번호 재설정 화면 타이틀 위젯
///
/// 화면 상단에 "비밀번호 재설정" 제목과 안내 문구를 표시합니다.
///
/// **주요 기능 (Key Features):**
/// - 제목과 부제목 텍스트 렌더링
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// const ResetPasswordTitle();
/// ```
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
