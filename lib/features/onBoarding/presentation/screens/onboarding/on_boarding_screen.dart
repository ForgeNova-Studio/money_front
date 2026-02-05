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
import 'package:moamoa/features/onBoarding/presentation/widgets/page6.dart';
import 'package:moamoa/features/onBoarding/presentation/widgets/onboarding_bottom_indicator.dart';

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
                  Page1(),
                  Page2(),
                  Page3(),
                  Page4(),
                  Page5(
                    onNext: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Page6(),
                ],
              ),
            ),

            // 마지막 페이지(Page6)일 때만 '시작하기' 버튼 표시
            if (_currentPage == 5)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _completeOnboarding(context);
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

            // 페이지 인디케이터 (화면 제일 하단)
            Padding(
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              child: OnboardingBottomIndicator(
                currentPage: _currentPage,
                totalPage: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 온보딩 완료 처리
  void _completeOnboarding(BuildContext context) {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    sharedPreferences.setBool('has_seen_onboarding', true);
    context.go(RouteNames.login);
  }
}
