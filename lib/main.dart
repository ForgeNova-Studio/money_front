// packages
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// core
import 'package:moamoa/features/common/providers/app_init_provider.dart';
import 'package:moamoa/core/theme/theme.dart';
import 'package:moamoa/router/router_provider.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:go_router/go_router.dart';

// features
import 'package:moamoa/features/common/screens/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  /// Native Splash Screen 유지 (Flutter 엔진 초기화 중 표시)
  /// - 이 코드가 실행되면, 앱의 네이티브 스플래시 화면이 자동으로 사라지지 않고
  ///   필요한 모든 비동기 작업이 끝날 때까지 스플래시 화면이 유지된다.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// dotenv 파일 불러오기
  /// - 주요 api 주소, 앱 키 등 환경 변수 설정
  await dotenv.load(fileName: ".env");

  // 카카오 네이티브 앱키
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  // Sentry 초기화 (임시: Debug 모드에서도 테스트 가능)
  // TODO: 테스트 후 kReleaseMode 체크 원복!
  final sentryDsn = dotenv.env['SENTRY_DSN'] ?? '';
  
  if (sentryDsn.isNotEmpty) {  // 원래: sentryDsn.isNotEmpty && kReleaseMode
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.environment = 'production';
        options.release = dotenv.env['APP_VERSION'] ?? '1.0.0';
        // 무료 플랜 최적화
        options.tracesSampleRate = 0.1; // 10% 트랜잭션 샘플링
        options.sampleRate = 1.0; // 에러는 100% 캡쳐
        options.attachScreenshot = false; // 스크린샷 비활성화
        options.sendDefaultPii = false; // 민감 정보 전송 안함
        
        // 불필요한 에러 필터링
        options.beforeSend = (event, hint) {
          final exception = event.throwable;
          if (exception == null) return event;
          
          final message = exception.toString().toLowerCase();
          
          // 네트워크 에러 무시
          if (message.contains('socketexception') ||
              message.contains('connection refused') ||
              message.contains('connection reset') ||
              message.contains('connection timed out') ||
              message.contains('network is unreachable') ||
              message.contains('no internet') ||
              message.contains('failed host lookup')) {
            return null;
          }
          
          // 인증 에러 무시 (401, 403)
          if (message.contains('401') ||
              message.contains('403') ||
              message.contains('unauthorized') ||
              message.contains('forbidden') ||
              message.contains('token') && message.contains('expired')) {
            return null;
          }
          
          // 사용자가 취소한 작업 무시
          if (message.contains('cancelled') ||
              message.contains('canceled') ||
              message.contains('user denied')) {
            return null;
          }
          
          return event;
        };
      },
      appRunner: () => _initializeApp(),
    );
  } else {
    _initializeApp();
  }
}

void _initializeApp() {
  runApp(
    const ProviderScope(
      child: AppBootstrap(),
    ),
  );

  // Push Notification 설정
  // verbose 로깅 활성화 (프로덕션에서 제거)
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // Initialize with your OneSignal App ID
  late String oneSignalAppId;
  if (kDebugMode) {
    oneSignalAppId = dotenv.env['ONESIGNAL_APP_ID_DEV']!;
    debugPrint('ONESIGNAL_APP_ID_DEV: $oneSignalAppId');
  } else {
    oneSignalAppId = dotenv.env['ONESIGNAL_APP_ID_REAL']!;
    debugPrint('ONESIGNAL_APP_ID_REAL: $oneSignalAppId');
  }
  OneSignal.initialize(oneSignalAppId);

  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(false);

  // 푸시 알림 클릭 시 알림 리스트 화면으로 이동
  OneSignal.Notifications.addClickListener((event) {
    debugPrint('[OneSignal] Notification clicked: ${event.notification.title}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        GoRouter.of(context).push(RouteNames.notifications);
      }
    });
  });

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
      title: '모아모아',
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
