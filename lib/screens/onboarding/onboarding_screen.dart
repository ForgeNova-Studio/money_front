import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moneyflow/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    // 3초 뒤 다음 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return const LoginScreen();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // FadeIn for next screen
          final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut));

          // FadeOut for current screen
          final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
          );

          return FadeTransition(
            opacity: fadeIn, // LoginScreen: fade in
            child: FadeTransition(
              opacity: fadeOut, // OnBoarding: fade out
              child: child,
            ),
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(63, 82, 160, 1),
      body: Stack(children: [
        Center(
          child: LottieBuilder.asset('assets/animation/programmer_and_cat.json',
              width: 300, height: 300),
        ),
      ]),
    );
  }
}
