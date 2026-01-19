// packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// core
import 'package:moneyflow/features/common/providers/app_init_provider.dart';
import 'package:moneyflow/core/theme/theme.dart';
import 'package:moneyflow/router/router_provider.dart';

// features
import 'package:moneyflow/features/common/screens/splash_screen.dart';

void main() {
  /// Native Splash Screen 유지 (Flutter 엔진 초기화 중 표시)
  /// - 이 코드가 실행되면, 앱의 네이티브 스플래시 화면이 자동으로 사라지지 않고
  ///   필요한 모든 비동기 작업이 끝날 때까지 스플래시 화면이 유지된다.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    const ProviderScope(
      child: AppBootstrap(),
    ),
  );

  // Flutter 스플래시가 표시되도록 네이티브 스플래시 제거
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
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

      // Localization 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en'),
      ],
    );
  }
}

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key});

  static bool _firstFrameLogged = false;

  String _resolveInitErrorMessage(Object error) {
    if (error is TimeoutException) {
      return '네트워크가 지연되고 있습니다. 다시 시도해주세요.';
    }
    if (error is SocketException) {
      return '네트워크 연결을 확인해주세요.';
    }
    if (kDebugMode) {
      return error.toString();
    }
    return '잠시 후 다시 시도해주세요.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = buildLightTheme();
    final initState = ref.watch(appInitializationProvider);

    return initState.when(
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const SplashScreen(),
      ),
      error: (error, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '초기화에 실패했습니다.\n${_resolveInitErrorMessage(error)}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(appInitializationProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_firstFrameLogged) return;
          _firstFrameLogged = true;
          final elapsedMs =
              DateTime.now().difference(appStartTime).inMilliseconds;
          logStartupDebug('first_frame_ms=$elapsedMs');
          logStartupProfile('first_frame_ms=$elapsedMs');
          logStartupRelease('first_frame_ms=$elapsedMs');
        });
        return const MoneyFlowApp();
      },
    );
  }
}
