import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 비밀번호 찾기 화면의 타이틀 위젯
///
/// 화면 상단에 표시되는 제목과 부제목을 렌더링합니다.
///
/// **주요 기능 (Key Features):**
/// - "계정을 찾아볼까요?" 제목 표시
/// - 안내 문구 표시
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// Column(
///   children: [
///     const FindPasswordTitle(),
///     // ... other widgets
///   ],
/// )
/// ```
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
