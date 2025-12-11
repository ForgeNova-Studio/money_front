import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/core/router/app_router.dart';
import 'package:moneyflow/core/router/route_names.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/states/auth_state.dart';

/// GoRouter Provider
/// AuthViewModel의 상태를 watching하여 인증 상태 변화에 따라 자동 리다이렉션
final routerProvider = Provider<GoRouter>((ref) {
  // AuthViewModel의 상태를 읽기
  final authState = ref.watch(authViewModelProvider);

  // authState 변화를 GoRouter에 알리기 위한 Notifier
  final authStateNotifier = ValueNotifier<bool>(authState.isAuthenticated);

  // authState 변화 감지하여 Notifier 업데이트
  ref.listen<AuthState>(authViewModelProvider, (previous, next) {
    authStateNotifier.value = next.isAuthenticated;
  });

  // Provider dispose 시 Notifier도 dispose
  ref.onDispose(() {
    authStateNotifier.dispose();
  });

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // 디버그 로그 활성화
    refreshListenable: authStateNotifier, // authState 변화 시 라우터 새로고침

    // ==================== Redirect 로직 ====================
    redirect: (context, state) {
      // 현재 authState 읽기 (ref.read 사용)
      final currentAuthState = ref.read(authViewModelProvider);
      final isLoading = currentAuthState.isLoading;
      final isAuthenticated = currentAuthState.isAuthenticated;
      final hasUser = currentAuthState.user != null;

      final currentLocation = state.matchedLocation;

      // Public 화면 확인
      final isGoingToAuth = RouteNames.isAuthRoute(currentLocation);
      final isOnSplash = currentLocation == RouteNames.splash;

      // Priority 1: 로딩 중 → 스플래시 화면
      if (isLoading) {
        // 이미 스플래시 화면이면 그대로 유지
        if (isOnSplash) return null;
        // 다른 화면이면 스플래시로 리다이렉션
        return RouteNames.splash;
      }

      // Priority 2: 인증된 사용자 → public 화면 접근 시 홈으로 리다이렉션
      if (isAuthenticated && hasUser) {
        // 인증된 사용자가 로그인/회원가입 등의 화면에 접근하려는 경우
        if (isGoingToAuth || isOnSplash) {
          return RouteNames.home;
        }
        // 이미 protected 화면에 있으면 그대로 유지
        return null;
      }

      // Priority 3: 미인증 사용자 → protected 화면 접근 시 로그인으로 리다이렉션
      if (!isAuthenticated) {
        // 이미 public 화면(로그인/회원가입 등)에 있으면 그대로 유지
        if (isGoingToAuth) {
          return null;
        }
        // Protected 화면에 접근하려는 경우 로그인 화면으로
        return RouteNames.login;
      }

      // 기본값: 리다이렉션 없음
      return null;
    },

    // ==================== 라우트 설정 ====================
    routes: AppRouter.routes,

    // ==================== 에러 처리 ====================
    errorBuilder: AppRouter.errorBuilder,
  );
});
