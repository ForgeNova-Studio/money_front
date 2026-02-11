import 'package:flutter/material.dart';

// LoginScreen 타이틀 위젯
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
