import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moneyflow/core/theme/theme.dart';
import 'package:moneyflow/presentation/screens/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/budget/presentation/providers/budget_provider.dart';
import 'features/expense/presentation/providers/expense_provider.dart';
import 'features/income/presentation/providers/income_provider.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';
import 'features/couple/presentation/providers/couple_provider.dart';

void main() {
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
        title: 'MoneyFlow',
        debugShowCheckedModeBanner: false,

        // 테마 설정
        theme: buildLightTheme(),
        // darkTheme: buildDarkTheme(), // 다크모드 (선택사항)

        // 다국어 지원 설정
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'), // 한국어
          Locale('en', 'US'), // 영어
        ],
        locale: const Locale('ko', 'KR'), // 기본 언어

        // 시작 화면
        home: const SplashScreen(),
      ),
    );
  }
}
