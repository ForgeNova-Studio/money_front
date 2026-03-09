import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 비밀번호 찾기 링크 위젯
///
/// 사용자가 비밀번호를 잊었을 때 비밀번호 찾기 화면으로 이동할 수 있는 링크를 제공합니다.
///
/// **주요 기능 (Key Features):**
/// - 텍스트 버튼 형태의 링크 표시
/// - 밑줄 스타일 적용
///
/// **파라미터 (Parameters):**
/// - [onTap]: 링크 클릭 시 실행될 콜백 (화면 이동 등)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// LinkFindPassword(
///   onTap: () => context.push(RouteNames.findPassword),
/// )
/// ```
class LinkFindPassword extends StatelessWidget {
  final VoidCallback onTap;

  const LinkFindPassword({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onTap,
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
            '비밀번호를 잊으셨나요?',
            style: TextStyle(
              fontSize: 15,
              color: context.appColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
