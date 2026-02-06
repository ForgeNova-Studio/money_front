// packages
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// core
import 'package:moamoa/core/constants/app_constants.dart';

/// 다섯 번째 온보딩 슬라이드 - 알림 권한 요청
/// (기존 Page6의 내용 이동)
class Page5 extends StatefulWidget {
  final VoidCallback onNext; // 다음 페이지로 이동 콜백

  const Page5({
    super.key,
    required this.onNext,
  });

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bellAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // 벨 흔들림 애니메이션
    _bellAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 펄스 애니메이션
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
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

  Future<void> _requestNotificationPermission() async {
    // OneSignal 권한 요청
    await OneSignal.Notifications.requestPermission(true);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // 상단 이미지 - 알림 벨 애니메이션
          SizedBox(
            height: 300,
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _bellAnimation.value,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 중단 큰 제목
          Text(
            '중요한 소식을\n놓치지 마세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 20),

          // 하단 작은 설명 글귀
          Text(
            '푸시 알림을 통해 지출 리마인더,\n공지사항 등 다양한 알림을 받아보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: context.appColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          // 알림 허용 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _requestNotificationPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                '알림 허용하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 나중에 버튼
          TextButton(
            onPressed: widget.onNext,
            child: Text(
              '나중에',
              style: TextStyle(
                fontSize: 16,
                color: context.appColors.textSecondary,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
