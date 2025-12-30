// packages
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

// core
import 'package:moneyflow/core/providers/core_providers.dart';
import 'package:moneyflow/core/theme/theme.dart';
import 'package:moneyflow/core/router/router_provider.dart';

// features
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

// OCR
import 'package:moneyflow/features/ocr/data/datasources/memory/global_brand_source.dart';
import 'package:moneyflow/features/ocr/data/datasources/local/user_brand_source.dart';
import 'package:moneyflow/features/ocr/presentation/providers/ocr_providers.dart';

void main() async {
  /// Native Splash Screen 유지 (Flutter 엔진 초기화 중 표시)
  /// - 이 코드가 실행되면, 앱의 네이티브 스플래시 화면이 자동으로 사라지지 않고
  ///   필요한 모든 비동기 작업이 끝날 때까지 스플래시 화면이 유지된다.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 한국어 locale 데이터 초기화 (TableCalendar 사용을 위해 필요)
  await initializeDateFormatting('ko_KR', null);

  // SharedPreferences 인스턴스 생성
  final sharedPreferences = await SharedPreferences.getInstance();

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // OCR 초기화 (비동기 데이터 로딩)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  // 1. Hive 초기화
  await Hive.initFlutter();

  // 2. GlobalBrandSource 초기화 (JSON 로딩)
  final globalBrandSource = GlobalBrandSource();
  await globalBrandSource.initialize();

  // 3. UserBrandSource 초기화 (Hive Box 열기)
  final userBrandSource = UserBrandSource();
  await userBrandSource.init();

  // Riverpod 컨테이너 생성 및 초기화
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      // OCR DataSource 주입
      globalBrandSourceProvider.overrideWithValue(globalBrandSource),
      userBrandSourceProvider.overrideWithValue(userBrandSource),
    ],
  );

  /// 앱 시작 전, 비동기 초기화 (예: 사용자 인증 상태 확인)
  /// - AuthViewModel이 처음으로 생성되고 초기화 로직이 실행
  await container.read(authViewModelProvider.notifier).isInitialized;

  // 초기화 완료 후 스플래시 스크린 제거
  FlutterNativeSplash.remove();

  runApp(
    // 미리 생성한 컨테이너를 앱에 제공
    UncontrolledProviderScope(
      container: container,
      child: const MoneyFlowApp(),
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

