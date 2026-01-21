// packages
import 'package:flutter/material.dart';

// core
import 'package:moamoa/core/constants/app_constants.dart';

// widgets
import 'package:moamoa/features/onBoarding/presentation/widgets/onboarding_bottom_indicator.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key, required this.currentPage});

  final int currentPage;

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _syncAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _syncAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
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

          // 상단 이미지 - 동기화 컨셉
          SizedBox(
            height: 300,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // 왼쪽 폰 (네모)
                    Positioned(
                      left: 40,
                      child: Container(
                        width: 80,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.appColors.gray400,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: context.appColors.gray400,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    // 오른쪽 폰 (네모)
                    Positioned(
                      right: 40,
                      child: Container(
                        width: 80,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.appColors.gray400,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline,
                            color: context.appColors.gray400,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    // 동기화 아이콘 (왔다 갔다)
                    Transform.translate(
                      offset: Offset(_syncAnimation.value, 0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: context.appColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.appColors.primary.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sync_alt,
                          color: Colors.white,
                          size: 30,
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
            '실시간 공유\n언제 어디서나 투명하게',
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
            '서로의 금융 생활을 실시간으로 확인하고\n더 투명한 관계를 만들어보세요',
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
