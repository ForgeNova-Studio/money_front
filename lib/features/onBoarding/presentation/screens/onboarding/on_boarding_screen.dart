// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// widgets
import 'package:moamoa/features/onBoarding/presentation/widgets/page1.dart';
import 'package:moamoa/features/onBoarding/presentation/widgets/page2.dart';
import 'package:moamoa/features/onBoarding/presentation/widgets/page3.dart';
import 'package:moamoa/features/onBoarding/presentation/widgets/page4.dart';
import 'package:moamoa/features/onBoarding/presentation/widgets/page5.dart';

// providers
import 'package:moamoa/features/common/providers/storage_providers.dart';

// routes
import 'package:moamoa/router/route_names.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                    final sharedPreferences =
                        ref.read(sharedPreferencesProvider);
                    sharedPreferences.setBool('has_seen_onboarding', true);
                    context.go(RouteNames.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
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
