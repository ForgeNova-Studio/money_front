import 'package:flutter/material.dart';

import 'package:moneyflow/core/providers/core_providers.dart';
import 'package:moneyflow/core/theme/theme.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/budget/presentation/providers/budget_provider.dart';
import 'features/expense/presentation/providers/expense_provider.dart';
import 'features/income/presentation/providers/income_provider.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';
import 'features/couple/presentation/providers/couple_provider.dart';

import 'package:moneyflow/presentation/screens/onboarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MoneyFlowApp extends StatelessWidget {
  const MoneyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        home: const OnboardingScreen(),
      ),
    );
  }
}
