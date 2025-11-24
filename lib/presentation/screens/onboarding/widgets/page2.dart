import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/presentation/screens/onboarding/widgets/onboarding_bottom_indicator.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key, required this.currentPage});

  final int currentPage;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _coinAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _coinAnimation = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
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

          // 상단 이미지 - 돼지 저금통 컨셉
          SizedBox(
            height: 300,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // 돼지 저금통 (네모로 표현)
                    Container(
                      width: 150,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPinkLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryPink,
                          width: 4,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.savings_rounded,
                          size: 60,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ),
                    // 동전 1 (왼쪽 위에서 떨어짐)
                    Positioned(
                      top: 50 + _coinAnimation.value,
                      left: 80,
                      child: const Icon(
                        Icons.monetization_on,
                        size: 30,
                        color: Colors.amber,
                      ),
                    ),
                    // 동전 2 (오른쪽 위에서 떨어짐)
                    Positioned(
                      top: 30 + _coinAnimation.value,
                      right: 80,
                      child: const Icon(
                        Icons.monetization_on,
                        size: 30,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          // 중단 큰 제목
          const Text(
            '함께 모으는 재미\n공동의 목표 달성',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 20),

          // 하단 작은 설명 글귀
          const Text(
            '작은 돈도 함께 모으면 큰 힘이 됩니다\n우리의 꿈을 위해 저축하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
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
