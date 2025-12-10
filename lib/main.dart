// packages
import 'package:flutter/material.dart';
import 'package:moneyflow/presentation/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

// core
import 'package:moneyflow/core/providers/core_providers.dart';
import 'package:moneyflow/core/theme/theme.dart';

// provider
import 'package:provider/provider.dart';
import 'features/budget/presentation/providers/budget_provider.dart';
import 'features/expense/presentation/providers/expense_provider.dart';
import 'features/income/presentation/providers/income_provider.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';
import 'features/couple/presentation/providers/couple_provider.dart';

// screens
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/splash_screen.dart';

// viewmodels & states
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/states/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 locale 데이터 초기화 (TableCalendar 사용을 위해 필요)
  await initializeDateFormatting('ko_KR', null);

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    // Riverpod ProviderScope로 앱 전체를 감싸서 Riverpod 활성화
    // 기존 Provider와 병행 사용 가능
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MoneyFlowApp(),
    ),
  );
}

class MoneyFlowApp extends ConsumerWidget {
  const MoneyFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AuthViewModel의 상태 구독
    final authState = ref.watch(authViewModelProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => IncomeProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
        ChangeNotifierProvider(create: (_) => CoupleProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: MaterialApp(
        title: 'MoneyFlowTemp',
        debugShowCheckedModeBanner: false,

        // 테마 설정
        theme: buildLightTheme(),
        // darkTheme: buildDarkTheme(), // 다크모드 (선택사항)

        // 인증 상태에 따라 화면 분기
        home: _buildHomeScreen(authState),
      ),
    );
  }

  /// 인증 상태에 따라 적절한 화면 반환
  Widget _buildHomeScreen(AuthState authState) {
    // 로딩 중: 스플래시 화면
    if (authState.isLoading) {
      return const SplashScreen();
    }

    // 인증된 상태: 홈 화면
    if (authState.isAuthenticated && authState.user != null) {
      return const HomeScreen();
    }

    // 미인증 상태: 로그인 화면
    return const LoginScreen();
  }
}
