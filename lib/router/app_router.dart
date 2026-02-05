// ==================== Flutter & Packages ====================
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==================== Router ====================
import 'package:moamoa/router/route_names.dart';

// ==================== Common ====================
import 'package:moamoa/features/common/widgets/app_shell.dart';
import 'package:moamoa/features/common/screens/splash_screen.dart';

// ==================== Auth ====================
import 'package:moamoa/features/auth/presentation/screens/login_screen.dart';
import 'package:moamoa/features/auth/presentation/screens/register_screen.dart';
import 'package:moamoa/features/auth/presentation/screens/find_password_screen.dart';
import 'package:moamoa/features/auth/presentation/screens/reset_password_screen.dart';

// ==================== Onboarding ====================
import 'package:moamoa/features/onBoarding/presentation/screens/onboarding/on_boarding_screen.dart';

// ==================== Home ====================
import 'package:moamoa/features/home/presentation/screens/home_screen.dart';

// ==================== Statistics ====================
import 'package:moamoa/features/statistics/presentation/screens/statistics_screen.dart';

// ==================== Assets ====================
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/presentation/screens/asset_screen.dart';
import 'package:moamoa/features/assets/presentation/screens/add_asset_screen.dart';

// ==================== AccountBook ====================
import 'package:moamoa/features/account_book/presentation/screens/account_book_create_screen.dart';
import 'package:moamoa/features/account_book/presentation/screens/account_book_list_screen.dart';
import 'package:moamoa/features/account_book/presentation/screens/account_book_detail_screen.dart';
import 'package:moamoa/features/account_book/presentation/screens/account_book_edit_screen.dart';

// ==================== Expense ====================
import 'package:moamoa/features/expense/presentation/screens/add_expense_screen.dart';

// ==================== Income ====================
import 'package:moamoa/features/income/presentation/screens/add_income_screen.dart';

// ==================== Couple ====================
import 'package:moamoa/features/couple/presentation/screens/couple_screen.dart';
import 'package:moamoa/features/couple/presentation/screens/couple_invite_screen.dart';
import 'package:moamoa/features/couple/presentation/screens/couple_join_screen.dart';

// ==================== OCR ====================
import 'package:moamoa/features/ocr/presentation/screens/ocr_test_screen.dart';

// ==================== Budget ====================
import 'package:moamoa/features/budget/presentation/screens/budget_settings_screen.dart';
import 'package:moamoa/features/budget/presentation/screens/initial_balance_settings_screen.dart';

// ==================== Notification ====================
import 'package:moamoa/features/notification/presentation/screens/notification_list_screen.dart';
import 'package:moamoa/features/notification/presentation/screens/admin_notification_screen.dart';

// ==================== SMS Import ====================
import 'package:moamoa/features/sms_import/presentation/screens/pending_expenses_review_screen.dart';

// ==================== Shortcuts Guide ====================
import 'package:moamoa/features/shortcuts_guide/presentation/screens/shortcuts_guide_screen.dart';

// ==================== Settings ====================
import 'package:moamoa/features/setting/settings_screen.dart';

// Monthly Report Screens
import 'package:moamoa/features/monthly_report/presentation/screens/monthly_report_screen.dart';

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
        GoRoute(
          path: RouteNames.couple,
          name: 'couple',
          builder: (context, state) => const CoupleScreen(),
        ),
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

        // ==================== AccountBook Routes ====================
        GoRoute(
          path: RouteNames.accountBookList,
          name: 'accountBookList',
          builder: (context, state) => const AccountBookListScreen(),
        ),
        GoRoute(
          path: RouteNames.accountBookDetailPath,
          name: RouteNames.accountBookDetail,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return AccountBookDetailScreen(accountBookId: id);
          },
        ),
        GoRoute(
          path: RouteNames.accountBookEditPath,
          name: RouteNames.accountBookEdit,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return AccountBookEditScreen(accountBookId: id);
          },
        ),
        GoRoute(
          path: RouteNames.accountBookCreate,
          name: 'accountBookCreate',
          builder: (context, state) => const AccountBookCreateScreen(),
        ),

        // ==================== Asset Routes ====================
        GoRoute(
          path: RouteNames.addAsset,
          name: 'addAsset',
          builder: (context, state) {
            final asset = state.extra as Asset?;
            return AddAssetScreen(asset: asset);
          },
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

        // ==================== SMS Import Routes ====================
        GoRoute(
          path: RouteNames.smsImport,
          name: 'smsImport',
          builder: (context, state) => const PendingExpensesReviewScreen(),
        ),

        // ==================== Shortcuts Guide Routes ====================
        GoRoute(
          path: RouteNames.shortcutsGuide,
          name: 'shortcutsGuide',
          builder: (context, state) => const ShortcutsGuideScreen(),
        ),

        // ==================== Notification Routes ====================
        GoRoute(
          path: RouteNames.notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationListScreen(),
        ),
        GoRoute(
          path: RouteNames.adminNotification,
          name: 'adminNotification',
          builder: (context, state) => const AdminNotificationScreen(),
        ),

        // ==================== Report Routes ====================
        GoRoute(
          path: RouteNames.monthlyReport,
          name: 'monthlyReport',
          builder: (context, state) {
            final year = int.tryParse(state.uri.queryParameters['year'] ?? '') ?? DateTime.now().year;
            final month = int.tryParse(state.uri.queryParameters['month'] ?? '') ?? DateTime.now().month;
            return MonthlyReportScreen(year: year, month: month);
          },
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
