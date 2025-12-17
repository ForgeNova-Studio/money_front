import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/core/router/route_names.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

/// Flutter Splash Screen
///
/// 앱 초기화 작업을 수행하고 완료 후 자동으로 다음 화면으로 이동
/// - 인증 상태 확인 및 초기화
/// - 필요한 비동기 작업 처리
/// - 로딩 인디케이터로 사용자에게 피드백 제공
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 초기화 작업 시작
    _initializeApp();
  }

  /// 앱 초기화 로직
  ///
  /// 실무에서는 다음과 같은 작업들을 수행:
  /// - 사용자 인증 상태 확인
  /// - 필요한 데이터 프리로드
  /// - 앱 설정 로드
  /// - 원격 설정 fetch (예: Firebase Remote Config)
  Future<void> _initializeApp() async {
    try {
      // AuthViewModel의 초기화 완료 대기
      await ref.read(authViewModelProvider.notifier).isInitialized;

      // ============================================================
      // [테스트용] 2초 딜레이 - 스플래시 화면 확인용
      // 실제 배포 시에는 아래 라인을 주석 처리하거나 제거하세요
      // ============================================================
      // await Future.delayed(const Duration(seconds: 2));

      // 초기화 완료 후 자동으로 다음 화면으로 이동
      // GoRouter의 redirect 로직이 인증 상태에 따라 자동으로 처리
      if (mounted) {
        // Root 경로로 이동하면 router_provider의 redirect가 동작
        context.go('/');
      }
    } catch (e) {
      // 초기화 중 에러 발생 시 처리
      debugPrint('[SplashScreen] 초기화 에러: $e');

      if (mounted) {
        // 에러 발생 시 로그인 화면으로 이동
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 인증 상태 감시 (디버그용)
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 또는 브랜드 이미지
            // TODO: 실제 로고 이미지로 교체
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 120,
              color: Colors.white,
            ),

            const SizedBox(height: 24),

            // 앱 이름
            Text(
              'MoneyFlow',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 48),

            // 로딩 인디케이터
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),

            const SizedBox(height: 16),

            // 로딩 텍스트
            Text(
              '초기화 중...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            // 디버그 정보 (개발 중에만 표시)
            if (authState.isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  '인증 상태 확인 중',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
