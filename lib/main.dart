import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:moneyflow/core/theme/theme.dart';
import 'package:moneyflow/presentation/screens/home/home_screen.dart';
import 'package:moneyflow/presentation/screens/onboarding/on_boarding_screen.dart';

import 'package:provider/provider.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/budget/presentation/providers/budget_provider.dart';
import 'features/expense/presentation/providers/expense_provider.dart';
import 'features/income/presentation/providers/income_provider.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';
import 'features/couple/presentation/providers/couple_provider.dart';

void main() async {
  // intl 패키지를 사용하는 위젯에서 한국어 등의 로케일을 사용하려면
  // 앱 시작 전에 initializeDateFormatting()을 호출해야 함
  await initializeDateFormatting();

  runApp(const MoneyFlowApp());
}

class MoneyFlowApp extends StatelessWidget {
  const MoneyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        // home: const OnboardingScreen(),
        home: const HomeScreen(),
      ),
    );
  }
}
