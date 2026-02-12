import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 로그인 화면 구분선 위젯
///
/// 소셜 로그인 버튼들과 이메일 로그인/회원가입 섹션을 구분하는 수평선입니다.
/// 중앙에 "or" 텍스트를 포함하고 있습니다.
///
/// **주요 기능 (Key Features):**
/// - 좌우 Divider와 중앙 텍스트("or") 배치
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// Column(
///   children: [
///     // ... widgets
///     const LoginDivider(),
///     // ... widgets
///   ],
/// )
/// ```
class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
