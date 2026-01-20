import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

/// Flutter Splash Screen
///
/// 앱 시작 시 잠깐 표시되는 로딩 화면.
/// 실제 화면 전환은 GoRouter의 redirect 로직이 처리합니다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 96,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              '모아모아',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 28),
            SizedBox(
              width: 72,
              height: 72,
              child: Lottie.asset(
                'assets/animation/Trail_loading.json',
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
