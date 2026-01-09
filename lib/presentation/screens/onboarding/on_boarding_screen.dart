// packages
import 'package:flutter/material.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

// widgets
import 'package:moneyflow/presentation/widgets/onboarding/page1.dart';
import 'package:moneyflow/presentation/widgets/onboarding/page2.dart';
import 'package:moneyflow/presentation/widgets/onboarding/page3.dart';
import 'package:moneyflow/presentation/widgets/onboarding/page4.dart';
import 'package:moneyflow/presentation/widgets/onboarding/page5.dart';

// screens
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // 슬라이드 콘텐츠
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  Page1(currentPage: _currentPage),
                  Page2(currentPage: _currentPage),
                  Page3(currentPage: _currentPage),
                  Page4(currentPage: _currentPage),
                  Page5(currentPage: _currentPage),
                ],
              ),
            ),

            // 하단 시작하기 버튼
            Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.primary,
                    foregroundColor: context.appColors.textWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
