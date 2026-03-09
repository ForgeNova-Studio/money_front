import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 회원가입 링크 위젯
///
/// 로그인 화면 하단에 위치하여 회원가입 화면으로 이동하는 기능을 제공합니다.
///
/// **주요 기능 (Key Features):**
/// - "모아모아가 처음이신가요?" 안내 문구와 회원가입 버튼 조합
///
/// **파라미터 (Parameters):**
/// - [onTap]: 회원가입 버튼 클릭 시 실행될 콜백
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// LinkRegister(
///   onTap: () => context.push(RouteNames.register),
/// )
/// ```
class LinkRegister extends StatelessWidget {
  final VoidCallback onTap;

  const LinkRegister({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '모아모아가 처음이신가요? ',
            style: TextStyle(
              fontSize: 15,
              color: context.appColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '회원가입',
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
