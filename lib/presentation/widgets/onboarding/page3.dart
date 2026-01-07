// packages
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

// widgets
import 'package:moneyflow/presentation/widgets/onboarding/onboarding_bottom_indicator.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key, required this.currentPage});

  final int currentPage;

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _chartAnimation;
  late Animation<int> _moneyAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();

    _chartAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _moneyAnimation = IntTween(begin: 0, end: 999999).animate(
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

          // 상단 이미지 - 링 차트 컨셉
          SizedBox(
            height: 300,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // 링 차트
                    CustomPaint(
                      size: Size(200, 200),
                      painter: RingChartPainter(
                        progress: _chartAnimation.value,
                        backgroundColor: context.appColors.gray200,
                      ),
                    ),
                    // 중앙 금액 텍스트
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${NumberFormat('#,###').format(_moneyAnimation.value)}원',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '모인 금액',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 40),

          // 중단 큰 제목
          Text(
            '빈틈 없는 관리\n서로의 지출을 한눈에',
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
            '어디에 얼마나 썼는지 투명하게\n더 나은 소비 습관을 만들어보세요',
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
}

class RingChartPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;

  RingChartPainter({
    required this.progress,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // 배경 링 (회색)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    if (progress > 0) {
      final rect = Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      );

      // 1. 기본 아크 그리기 (파랑/오렌지)
      final leftPaint = Paint()
        ..color = const Color(0xffF5A4B3) // Soft Blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final rightPaint = Paint()
        ..color = const Color(0xffB8A5D6) // Soft Orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      // 오른쪽 아크 (반시계)
      canvas.drawArc(
        rect,
        math.pi / 2,
        -math.pi * progress,
        false,
        rightPaint,
      );

      // 왼쪽 아크 (시계)
      canvas.drawArc(
        rect,
        math.pi / 2,
        math.pi * progress,
        false,
        leftPaint,
      );

      // 2. 완료 시 페이드 효과로 그라디언트 덮어쓰기
      // 진행률 0.8부터 1.0까지 서서히 나타남
      if (progress > 0.8) {
        final fadeOpacity = ((progress - 0.8) / 0.2).clamp(0.0, 1.0);

        final gradient = SweepGradient(
          startAngle: math.pi / 2,
          endAngle: 5 * math.pi / 2,
          tileMode: TileMode.clamp,
          colors: [
            const Color(0xffB8A5D6).withOpacity(fadeOpacity), // Right Color
            const Color(0xffF5A4B3).withOpacity(fadeOpacity), // Left Color
          ],
        );

        final completePaint = Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;

        // 전체 원을 덮어쓰는 대신, 현재 그려진 아크 위에 덧칠
        // 오른쪽 아크 덧칠
        canvas.drawArc(
          rect,
          math.pi / 2,
          -math.pi * progress,
          false,
          completePaint,
        );

        // 왼쪽 아크 덧칠
        canvas.drawArc(
          rect,
          math.pi / 2,
          math.pi * progress,
          false,
          completePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant RingChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
