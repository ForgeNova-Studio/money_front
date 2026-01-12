// packages
import 'package:flutter/material.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

// widgets
import 'package:moneyflow/features/onBoarding/presentation/widgets/onboarding_bottom_indicator.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key, required this.currentPage});

  final int currentPage;

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _leftCircleAnimation;
  late Animation<double> _rightCircleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _leftCircleAnimation = Tween<double>(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rightCircleAnimation = Tween<double>(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // 상단 이미지 - 동그라미 합쳐지는 애니메이션
          SizedBox(
            height: 300,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // 왼쪽 동그라미 (핑크)
                    Positioned(
                      left: ((MediaQuery.of(context).size.width - 64) / 2 -
                              50 +
                              15) *
                          _leftCircleAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              context.appColors.primaryDark,
                              context.appColors.primary,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 오른쪽 동그라미 (밝은 핑크)
                    Positioned(
                      right: ((MediaQuery.of(context).size.width - 64) / 2 -
                              50 +
                              15) *
                          _rightCircleAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              context.appColors.primary,
                              context.appColors.primaryLight,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 40),

          // 중단 큰 제목
          Text(
            '함께라서 더 쉬운\n돈 관리',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
              height: 1.3,
            ),
          ),

          SizedBox(height: 20),

          // 하단 작은 설명 글귀
          Text(
            '부부와 커플을 위한 스마트 가계부\n함께 기록하고, 함께 관리하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: context.appColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // 페이지 인디케이터
          OnboardingBottomIndicator(
            currentPage: widget.currentPage,
            totalPage: 5,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
