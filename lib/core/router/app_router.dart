import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/core/router/route_names.dart';

// Splash Screen
import 'package:moneyflow/presentation/screens/splash_screen.dart';

// Auth Screens
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/register_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/find_password_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/reset_password_screen.dart';

// Main Screens
import 'package:moneyflow/features/home/presentation/screens/home_screen.dart';

// Expense Screens
import 'package:moneyflow/features/expense/presentation/screens/add_expense_screen.dart';

// Income Screens
import 'package:moneyflow/features/income/presentation/screens/add_income_screen.dart';

// Statistics Screens
import 'package:moneyflow/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:moneyflow/features/statistics/presentation/screens/weekly_statistics_screen.dart';

// Budget & Couple Screens
import 'package:moneyflow/features/budget/presentation/screens/budget_setting_screen.dart';
import 'package:moneyflow/features/couple/presentation/screens/couple_invite_screen.dart';
import 'package:moneyflow/features/couple/presentation/screens/couple_join_screen.dart';

// OCR Screens
import 'package:moneyflow/features/ocr/presentation/screens/ocr_test_screen.dart';

/// 앱 라우트 설정 클래스
class AppRouter {
  AppRouter._();

  /// 모든 라우트 정의
  static List<RouteBase> get routes => [
        // ==================== Root Route ====================
        // Note: Root 경로(/)의 redirect는 router_provider.dart에서 처리됨
        // 인증 상태에 따라 /home 또는 /login으로 자동 리다이렉션

        // ==================== Splash Route ====================
        GoRoute(
          path: RouteNames.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // ==================== Public Routes (인증 불필요) ====================
        GoRoute(
          path: RouteNames.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteNames.register,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: RouteNames.findPassword,
          name: 'findPassword',
          builder: (context, state) => const FindPasswordScreen(),
        ),
        GoRoute(
          path: RouteNames.resetPassword,
          name: 'resetPassword',
          builder: (context, state) {
            // ResetPasswordScreen은 email 파라미터가 필요없음
            return const ResetPasswordScreen();
          },
        ),

        // ==================== Protected Routes (인증 필요) ====================

        // Main Home
        GoRoute(
          path: RouteNames.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // ==================== Expense Routes ====================
        GoRoute(
          path: RouteNames.addExpense,
          name: 'addExpense',
          builder: (context, state) {
            final initialDate = state.extra as DateTime?;
            return AddExpenseScreen(initialDate: initialDate);
          },
        ),

        // ==================== Income Routes ====================
        // GoRoute(
        //   path: RouteNames.incomes,
        //   name: 'incomes',
        //   builder: (context, state) => const IncomeListScreen(),
        // ),
        GoRoute(
          path: RouteNames.addIncome,
          name: 'addIncome',
          builder: (context, state) {
            final initialDate = state.extra as DateTime?;
            return AddIncomeScreen(initialDate: initialDate);
          },
        ),
        // GoRoute(
        //   path: '/incomes/:id',
        //   name: 'incomeDetail',
        //   builder: (context, state) {
        //     // extra로 IncomeModel 전달받기
        //     final income = state.extra as IncomeModel?;
        //     if (income == null) {
        //       return Scaffold(
        //         body: Center(
        //           child: Text('잘못된 접근입니다.'),
        //         ),
        //       );
        //     }
        //     return IncomeDetailScreen(income: income);
        //   },
        // ),
        // GoRoute(
        //   path: '/incomes/:id/edit',
        //   name: 'editIncome',
        //   builder: (context, state) {
        //     // extra로 IncomeModel 전달받기
        //     final income = state.extra as IncomeModel?;
        //     if (income == null) {
        //       return Scaffold(
        //         body: Center(
        //           child: Text('잘못된 접근입니다.'),
        //         ),
        //       );
        //     }
        //     return EditIncomeScreen(income: income);
        //   },
        // ),

        // ==================== Statistics Routes ====================
        GoRoute(
          path: RouteNames.statistics,
          name: 'statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: RouteNames.weeklyStatistics,
          name: 'weeklyStatistics',
          builder: (context, state) => const WeeklyStatisticsScreen(),
        ),

        // ==================== Budget Route ====================
        GoRoute(
          path: RouteNames.budget,
          name: 'budget',
          builder: (context, state) => const BudgetSettingScreen(),
        ),

        // ==================== Couple Routes ====================
        GoRoute(
          path: RouteNames.coupleInvite,
          name: 'coupleInvite',
          builder: (context, state) => const CoupleInviteScreen(),
        ),
        GoRoute(
          path: RouteNames.coupleJoin,
          name: 'coupleJoin',
          builder: (context, state) => const CoupleJoinScreen(),
        ),

        // ==================== OCR Route ====================
        GoRoute(
          path: RouteNames.ocrTest,
          name: 'ocrTest',
          builder: (context, state) => const OcrTestScreen(),
        ),
      ];

  /// 에러 화면 빌더
  static Widget errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('페이지를 찾을 수 없습니다'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '요청하신 페이지를 찾을 수 없습니다.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Path: ${state.uri}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 홈 화면으로 이동
                context.go(RouteNames.home);
              },
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
