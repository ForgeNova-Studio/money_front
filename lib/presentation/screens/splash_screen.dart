import 'package:flutter/foundation.dart';
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


      // 초기화 완료 후 자동으로 다음 화면으로 이동
      // GoRouter의 redirect 로직이 인증 상태에 따라 자동으로 처리
      if (mounted) {
        // Root 경로로 이동하면 router_provider의 redirect가 동작
        context.go('/');
      }
    } catch (e) {
      // 초기화 중 에러 발생 시 처리
      if (kDebugMode) {
        debugPrint('[SplashScreen] 초기화 에러: $e');
      }

      if (mounted) {
        // 에러 발생 시 로그인 화면으로 이동
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 96,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'MoneyFlow',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 28),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
