import 'package:flutter/material.dart';

/// 로그인 화면 타이틀 위젯
///
/// 화면 상단에 앱의 로고나 대표 아이콘을 표시합니다.
///
/// **주요 기능 (Key Features):**
/// - 지갑 아이콘(`Icons.account_balance_wallet_rounded`) 중앙 배치
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// const LoginTitle();
/// ```
class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 80,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
