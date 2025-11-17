import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/income_provider.dart';
import 'providers/statistics_provider.dart';
import 'providers/couple_provider.dart';
import 'providers/budget_provider.dart';
import 'screens/auth/login_screen.dart';

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
        locale: const Locale('ko', 'KR'), // 기본 언어를 한국어로 설정

        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          textTheme: GoogleFonts.notoSansTextTheme().copyWith(
            displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            displayMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            displaySmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            headlineMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
