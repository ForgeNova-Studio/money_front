// packages
import 'package:flutter/material.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

// widgets
import 'package:moneyflow/presentation/widgets/onboarding/onboarding_bottom_indicator.dart';

/// 두 번째 온보딩 슬라이드 - 영수증 스캔 애니메이션
class Page5 extends StatefulWidget {
  final int currentPage;

  const Page5({super.key, required this.currentPage});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _tag1Animation;
  late Animation<double> _tag2Animation;
  late Animation<double> _tag3Animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // 스캔 빔 애니메이션 (위아래 이동)
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 태그 나타나기 애니메이션 (순차적)
    _tag1Animation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOut),
      ),
    );

    _tag2Animation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );

    _tag3Animation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
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

          // 상단 이미지 - 영수증 스캔 애니메이션
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 영수증
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => _buildReceipt(),
                ),

                // 카테고리 태그들 (오른쪽에 배치)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        _buildTag(
                          text: '🍔 식비',
                          top: 60,
                          right: 0,
                          color: context.appColors.error,
                          animation: _tag1Animation,
                        ),
                        _buildTag(
                          text: '🚕 교통',
                          top: 140,
                          right: -80,
                          color: context.appColors.info,
                          animation: _tag2Animation,
                        ),
                        _buildTag(
                          text: '☕ 카페',
                          top: 220,
                          right: -70,
                          color: context.appColors.warning,
                          animation: _tag3Animation,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // 중단 큰 제목
          Text(
            '사진 한 장으로 끝나는\n지출 기록',
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
            '영수증을 찍으면 자동으로\n분류되고 저장됩니다',
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

          Spacer(),
        ],
      ),
    );
  }

  /// 영수증 위젯
  Widget _buildReceipt() {
    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.gray100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 영수증 라인들
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildReceiptLine(0.8),
                const SizedBox(height: 8),
                _buildReceiptLine(0.6),
                const SizedBox(height: 8),
                _buildReceiptLine(0.9),
                const SizedBox(height: 8),
                _buildReceiptLine(0.7),
                const SizedBox(height: 8),
                _buildReceiptLine(0.85),
                const SizedBox(height: 8),
                _buildReceiptLine(0.75),
                SizedBox(height: 8),
                _buildReceiptLine(0.65),
                SizedBox(height: 8),
                _buildReceiptLine(0.8),
              ],
            ),
          ),

          // 스캔 빔
          Positioned(
            top: _scanAnimation.value * 280,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    context.appColors.info,
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.info.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 영수증 라인 (텍스트 시뮬레이션)
  Widget _buildReceiptLine(double widthFactor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 160 * widthFactor,
        height: 8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.appColors.gray200, context.appColors.gray50],
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// 카테고리 태그
  Widget _buildTag({
    required String text,
    required double top,
    required double right,
    required Color color,
    required Animation<double> animation,
  }) {
    return Positioned(
      top: top,
      right: right,
      child: Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(-50 * (1 - animation.value), 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color == context.appColors.warning
                    ? context.appColors.textPrimary
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
