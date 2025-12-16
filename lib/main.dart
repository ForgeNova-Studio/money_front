// packages
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// core
import 'package:moneyflow/core/providers/core_providers.dart';
import 'package:moneyflow/core/theme/theme.dart';
import 'package:moneyflow/core/router/router_provider.dart';

// features
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

void main() async {
  // Native Splash Screen 유지 (Flutter 엔진 초기화 중 표시)
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

class MoneyFlowApp extends ConsumerStatefulWidget {
  const MoneyFlowApp({super.key});

  @override
  ConsumerState<MoneyFlowApp> createState() => _MoneyFlowAppState();
}

class _MoneyFlowAppState extends ConsumerState<MoneyFlowApp> {
  @override
  void initState() {
    super.initState();

    // AuthViewModel 초기화 완료 후 Splash Screen 제거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _removeSplashWhenReady();
    });
  }

  void _removeSplashWhenReady() {
    // authState의 isLoading이 false가 될 때까지 대기 후 splash 제거
    ref.listenManual(
      authViewModelProvider.select((state) => state.isLoading),
      (previous, isLoading) {
        if (!isLoading) {
          // 인증 상태 확인 완료 → Splash 제거
          FlutterNativeSplash.remove();
        }
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
