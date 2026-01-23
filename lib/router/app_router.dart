import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/features/common/widgets/app_shell.dart';

// Splash Screen
import 'package:moamoa/features/common/screens/splash_screen.dart';
import 'package:moamoa/features/setting/settings_screen.dart';

// Auth Screens
import 'package:moamoa/features/auth/presentation/screens/login_screen.dart';
import 'package:moamoa/features/auth/presentation/screens/register_screen.dart';
import 'package:moamoa/features/auth/presentation/screens/find_password_screen.dart';
import 'package:moamoa/features/auth/presentation/screens/reset_password_screen.dart';

// Onboarding Screens
import 'package:moamoa/features/onBoarding/presentation/screens/onboarding/on_boarding_screen.dart';

// Main Screens
import 'package:moamoa/features/home/presentation/screens/home_screen.dart';

// Analysis Screens
import 'package:moamoa/features/statistics/presentation/screens/statistics_screen.dart';

// Asset Screens
import 'package:moamoa/features/assets/presentation/screens/asset_screen.dart';

// AccountBook Screens
import 'package:moamoa/features/account_book/presentation/screens/account_book_create_screen.dart';

// Expense Screens
import 'package:moamoa/features/expense/presentation/screens/add_expense_screen.dart';

// Income Screens
import 'package:moamoa/features/income/presentation/screens/add_income_screen.dart';

// Statistics Screens

// Budget & Couple Screens

// OCR Screens
import 'package:moamoa/features/ocr/presentation/screens/ocr_test_screen.dart';

// Budget Screens
import 'package:moamoa/features/budget/presentation/screens/budget_settings_screen.dart';
import 'package:moamoa/features/budget/presentation/screens/initial_balance_settings_screen.dart';

/// 앱 라우트 설정 클래스
class AppRouter {
  AppRouter._();

  /// 모든 라우트 정의
  static List<RouteBase> get routes => [
        // ==================== Root Route ====================
        // Note: Root 경로(/)는 router_provider.dart의 redirect에서 처리됨
        // Hot reload나 일시적인 상황을 위해 SplashScreen 표시
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),

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
          path: RouteNames.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
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
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.home,
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.statistics,
                  name: 'statistics',
                  builder: (context, state) => const StatisticsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.assets,
                  name: 'assets',
                  builder: (context, state) => const AssetScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.settings,
                  name: 'settings',
                  builder: (context, state) => SettingsScreen(),
                ),
              ],
            ),
          ],
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
        GoRoute(
          path: '/expenses/:id/edit',
          name: 'editExpense',
          builder: (context, state) {
            final expenseId = state.pathParameters['id'];
            return AddExpenseScreen(expenseId: expenseId);
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
        GoRoute(
          path: '/incomes/:id/edit',
          name: 'editIncome',
          builder: (context, state) {
            final incomeId = state.pathParameters['id'];
            return AddIncomeScreen(incomeId: incomeId);
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

        // ==================== Couple Routes ====================
        // GoRoute(
        //   path: RouteNames.coupleInvite,
        //   name: 'coupleInvite',
        //   builder: (context, state) => const CoupleInviteScreen(),
        // ),
        // GoRoute(
        //   path: RouteNames.coupleJoin,
        //   name: 'coupleJoin',
        //   builder: (context, state) => const CoupleJoinScreen(),
        // ),

        // ==================== OCR Route ====================
        GoRoute(
          path: RouteNames.ocrTest,
          name: 'ocrTest',
          builder: (context, state) => const OcrTestScreen(),
        ),

        // ==================== AccountBook Routes ====================
        GoRoute(
          path: RouteNames.accountBookCreate,
          name: 'accountBookCreate',
          builder: (context, state) => const AccountBookCreateScreen(),
        ),

        // ==================== Budget Settings Routes ====================
        GoRoute(
          path: RouteNames.budgetSettings,
          name: 'budgetSettings',
          builder: (context, state) => const BudgetSettingsScreen(),
        ),
        GoRoute(
          path: RouteNames.initialBalanceSettings,
          name: 'initialBalanceSettings',
          builder: (context, state) => const InitialBalanceSettingsScreen(),
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
