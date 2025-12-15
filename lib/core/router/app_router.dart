import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/core/router/route_names.dart';

// Auth Screens
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/register_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/find_password_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:moneyflow/presentation/screens/home/home_screen.dart'
    show HomeScreen;

// Main Screens
import 'package:moneyflow/presentation/screens/home/home_screen_2.dart';

// Expense Screens
import 'package:moneyflow/features/expense/presentation/screens/expense_list_screen.dart';
import 'package:moneyflow/features/expense/presentation/screens/add_expense_screen.dart';
import 'package:moneyflow/features/expense/presentation/screens/expense_detail_screen.dart';
import 'package:moneyflow/features/expense/presentation/screens/edit_expense_screen.dart';

// Income Screens
import 'package:moneyflow/features/income/presentation/screens/income_list_screen.dart';
import 'package:moneyflow/features/income/presentation/screens/add_income_screen.dart';
import 'package:moneyflow/features/income/presentation/screens/income_detail_screen.dart';
import 'package:moneyflow/features/income/presentation/screens/edit_income_screen.dart';

// Statistics Screens
import 'package:moneyflow/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:moneyflow/features/statistics/presentation/screens/weekly_statistics_screen.dart';

// Budget & Couple Screens
import 'package:moneyflow/features/budget/presentation/screens/budget_setting_screen.dart';
import 'package:moneyflow/features/couple/presentation/screens/couple_invite_screen.dart';
import 'package:moneyflow/features/couple/presentation/screens/couple_join_screen.dart';

// Models (for extra parameter)
import 'package:moneyflow/features/expense/domain/entities/expense_model.dart';
import 'package:moneyflow/features/income/domain/entities/income_model.dart';

/// 앱 라우트 설정 클래스
class AppRouter {
  AppRouter._();

  /// 모든 라우트 정의
  static List<RouteBase> get routes => [
        // ==================== Root Route ====================
        // Note: Root 경로(/)의 redirect는 router_provider.dart에서 처리됨
        // 인증 상태에 따라 /home 또는 /login으로 자동 리다이렉션

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
          // builder: (context, state) => const HomeScreen2(),
        ),

        // ==================== Expense Routes ====================
        GoRoute(
          path: RouteNames.expenses,
          name: 'expenses',
          builder: (context, state) => const ExpenseListScreen(),
        ),
        GoRoute(
          path: RouteNames.addExpense,
          name: 'addExpense',
          builder: (context, state) => const AddExpenseScreen(),
        ),
        GoRoute(
          path: '/expenses/:id',
          name: 'expenseDetail',
          builder: (context, state) {
            // extra로 ExpenseModel 전달받기
            final expense = state.extra as ExpenseModel?;
            if (expense == null) {
              // Deep Link 등으로 직접 접근 시 에러 처리
              return Scaffold(
                body: Center(
                  child: Text('잘못된 접근입니다.'),
                ),
              );
            }
            return ExpenseDetailScreen(expense: expense);
          },
        ),
        GoRoute(
          path: '/expenses/:id/edit',
          name: 'editExpense',
          builder: (context, state) {
            // extra로 ExpenseModel 전달받기
            final expense = state.extra as ExpenseModel?;
            if (expense == null) {
              return Scaffold(
                body: Center(
                  child: Text('잘못된 접근입니다.'),
                ),
              );
            }
            return EditExpenseScreen(expense: expense);
          },
        ),

        // ==================== Income Routes ====================
        GoRoute(
          path: RouteNames.incomes,
          name: 'incomes',
          builder: (context, state) => const IncomeListScreen(),
        ),
        GoRoute(
          path: RouteNames.addIncome,
          name: 'addIncome',
          builder: (context, state) => const AddIncomeScreen(),
        ),
        GoRoute(
          path: '/incomes/:id',
          name: 'incomeDetail',
          builder: (context, state) {
            // extra로 IncomeModel 전달받기
            final income = state.extra as IncomeModel?;
            if (income == null) {
              return Scaffold(
                body: Center(
                  child: Text('잘못된 접근입니다.'),
                ),
              );
            }
            return IncomeDetailScreen(income: income);
          },
        ),
        GoRoute(
          path: '/incomes/:id/edit',
          name: 'editIncome',
          builder: (context, state) {
            // extra로 IncomeModel 전달받기
            final income = state.extra as IncomeModel?;
            if (income == null) {
              return Scaffold(
                body: Center(
                  child: Text('잘못된 접근입니다.'),
                ),
              );
            }
            return EditIncomeScreen(income: income);
          },
        ),

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
