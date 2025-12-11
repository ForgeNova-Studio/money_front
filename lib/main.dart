// packages
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

// core
import 'package:moneyflow/core/providers/core_providers.dart';
import 'package:moneyflow/core/theme/theme.dart';
import 'package:moneyflow/core/router/router_provider.dart';

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
    // GoRouter 인스턴스 가져오기
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'MoneyFlowTemp',
      debugShowCheckedModeBanner: false,

      // 테마 설정
      theme: buildLightTheme(),
      // darkTheme: buildDarkTheme(), // 다크모드 (선택사항)

      // GoRouter 설정
      routerConfig: router,
    );
  }
}
