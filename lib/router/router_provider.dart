import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/router/app_router.dart';
import 'package:moneyflow/router/route_names.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/states/auth_state.dart';

/// GoRouter Provider
/// AuthViewModel의 상태를 watching하여 인증 상태 변화에 따라 자동 리다이렉션
final routerProvider = Provider<GoRouter>((ref) {
  // AuthViewModel의 상태를 읽기
  final authState = ref.read(authViewModelProvider);

  // authState 변화를 GoRouter에 알리기 위한 Notifier
  // isLoading 변화도 반영되도록 전체 상태를 전달
  final authStateNotifier = ValueNotifier<AuthState>(authState);

  if (kDebugMode) {
    debugPrint(
        '[RouterProvider] 초기 authState.isAuthenticated: ${authState.isAuthenticated}');
  }

  // authState 변화 감지하여 Notifier 업데이트
  ref.listen<AuthState>(authViewModelProvider, (previous, next) {
    if (kDebugMode) {
      debugPrint('[RouterProvider] authState 변화 감지! '
          'previous.isAuthenticated: ${previous?.isAuthenticated}, '
          'next.isAuthenticated: ${next.isAuthenticated}');
    }
    authStateNotifier.value = next;
    if (kDebugMode) {
      debugPrint(
          '[RouterProvider] authStateNotifier 업데이트 완료: ${authStateNotifier.value.isAuthenticated}');
    }
  });

  // Provider dispose 시 Notifier도 dispose
  ref.onDispose(() {
    authStateNotifier.dispose();
  });

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode, // 디버그 로그 활성화
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
      final isRoot = currentLocation == '/';

      // 디버그 로그
      if (kDebugMode) {
        debugPrint('[GoRouter Redirect] location: $currentLocation, '
            'isLoading: $isLoading, isAuthenticated: $isAuthenticated, '
            'hasUser: $hasUser, isGoingToAuth: $isGoingToAuth, isRoot: $isRoot');
      }

      // Priority 1: 로딩 중일 때는 redirect 하지 않음
      // (초기화가 완료되면 자동으로 redirect 실행됨)
      if (isLoading) {
        if (kDebugMode) {
          debugPrint('[GoRouter Redirect] 로딩 중 - redirect 안 함');
        }
        return null;
      }

      // Priority 2: Root 경로(/) 처리
      if (isRoot) {
        if (isAuthenticated && hasUser) {
          if (kDebugMode) {
            debugPrint('[GoRouter Redirect] Root - 인증된 사용자 → /home');
          }
          return RouteNames.home;
        } else {
          if (kDebugMode) {
            debugPrint('[GoRouter Redirect] Root - 미인증 사용자 → /login');
          }
          return RouteNames.login;
        }
      }

      // Priority 2-1: Splash 경로 처리
      if (currentLocation == RouteNames.splash) {
        if (isAuthenticated && hasUser) {
          if (kDebugMode) {
            debugPrint('[GoRouter Redirect] Splash - 인증된 사용자 → /home');
          }
          return RouteNames.home;
        } else {
          if (kDebugMode) {
            debugPrint('[GoRouter Redirect] Splash - 미인증 사용자 → /login');
          }
          return RouteNames.login;
        }
      }

      // Priority 3: 인증된 사용자 → public 화면 접근 시 홈으로 리다이렉션
      if (isAuthenticated && hasUser) {
        // 인증된 사용자가 로그인/회원가입 등의 화면에 접근하려는 경우
        if (isGoingToAuth) {
          if (kDebugMode) {
            debugPrint('[GoRouter Redirect] 인증된 사용자 → /home으로 리다이렉션');
          }
          return RouteNames.home;
        }
        // 이미 protected 화면에 있으면 그대로 유지
        if (kDebugMode) {
          debugPrint('[GoRouter Redirect] 인증된 사용자 - protected 화면 유지');
        }
        return null;
      }

      // Priority 4: 미인증 사용자 → protected 화면 접근 시 로그인으로 리다이렉션
      if (!isAuthenticated) {
        // 이미 public 화면(로그인/회원가입 등)에 있으면 그대로 유지
        if (isGoingToAuth) {
          if (kDebugMode) {
            debugPrint('[GoRouter Redirect] 미인증 사용자 - public 화면 유지');
          }
          return null;
        }
        // Protected 화면에 접근하려는 경우 로그인 화면으로
        if (kDebugMode) {
          debugPrint('[GoRouter Redirect] 미인증 사용자 → /login으로 리다이렉션');
        }
        return RouteNames.login;
      }

      // 기본값: 리다이렉션 없음
      if (kDebugMode) {
        debugPrint('[GoRouter Redirect] 기본 - redirect 안 함');
      }
      return null;
    },

    // ==================== 라우트 설정 ====================
    routes: AppRouter.routes,

    // ==================== 에러 처리 ====================
    errorBuilder: AppRouter.errorBuilder,
  );
});
