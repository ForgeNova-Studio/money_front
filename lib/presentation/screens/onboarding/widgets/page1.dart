import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryPinkDark,
                              AppColors.primaryPink,
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryPink,
                              AppColors.primaryPinkLight,
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

          const SizedBox(height: 40),

          // 중단 큰 제목
          const Text(
            '함께라서 더 쉬운\n돈 관리',
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
            '부부와 커플을 위한 스마트 가계부\n함께 기록하고, 함께 관리하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // 페이지 인디케이터 (설명 아래로 이동)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: widget.currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: widget.currentPage == index
                      ? AppColors.primaryPink
                      : AppColors.gray200,
                ),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
