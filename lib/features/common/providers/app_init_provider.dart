import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moamoa/features/ocr/data/datasources/local/user_brand_source.dart';
import 'package:moamoa/features/ocr/data/datasources/memory/global_brand_source.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';

const bool kForceAppInitFailure = false;
// Keep splash visible for at least this duration to avoid flicker on fast init.
const Duration kMinimumSplashDuration = Duration(milliseconds: 1500);
final DateTime appStartTime = DateTime.now();

void logStartupDebug(String message) {
  if (kDebugMode) {
    developer.log(message, name: 'startup');
  }
}

void logStartupRelease(String message) {
  if (kReleaseMode) {
    developer.log(message, name: 'startup');
  }
}

void logStartupProfile(String message) {
  if (kProfileMode) {
    developer.log(message, name: 'startup');
  }
}

class AppInitialization {
  final SharedPreferences sharedPreferences;
  final GlobalBrandSource globalBrandSource;
  final UserBrandSource userBrandSource;
  final bool accountBooksPrefetched;

  AppInitialization({
    required this.sharedPreferences,
    required this.globalBrandSource,
    required this.userBrandSource,
    this.accountBooksPrefetched = false,
  });
}

/// 앱 시작 시 필요한 비동기 초기화
final appInitializationProvider =
    FutureProvider<AppInitialization>((ref) async {
  if (kForceAppInitFailure) {
    throw StateError('Forced app initialization failure');
  }

  final initStopwatch = Stopwatch()..start();
  final stepStopwatch = Stopwatch()..start();

  await initializeDateFormatting('ko_KR', null);
  logStartupDebug('init_date_format_ms=${stepStopwatch.elapsedMilliseconds}');

  stepStopwatch
    ..reset()
    ..start();
  final sharedPreferences = await SharedPreferences.getInstance();
  logStartupDebug('init_shared_prefs_ms=${stepStopwatch.elapsedMilliseconds}');

  stepStopwatch
    ..reset()
    ..start();
  await Hive.initFlutter();
  logStartupDebug('init_hive_ms=${stepStopwatch.elapsedMilliseconds}');

  stepStopwatch
    ..reset()
    ..start();
  final globalBrandSource = GlobalBrandSource();
  await globalBrandSource.initialize();
  logStartupDebug('init_global_brand_ms=${stepStopwatch.elapsedMilliseconds}');

  stepStopwatch
    ..reset()
    ..start();
  final userBrandSource = UserBrandSource();
  await userBrandSource.init();
  logStartupDebug('init_user_brand_ms=${stepStopwatch.elapsedMilliseconds}');

  // ============================================================================
  // Prefetch: 인증 토큰이 있으면 가계부 목록 미리 로드
  // ============================================================================
  stepStopwatch
    ..reset()
    ..start();
  bool accountBooksPrefetched = false;

  try {
    const secureStorage = FlutterSecureStorage();
    final tokenJson = await secureStorage.read(key: 'auth_token');

    if (tokenJson != null) {
      // 토큰이 존재하면 가계부 목록 prefetch (캐시에 저장됨)
      await ref.read(accountBooksProvider.future);
      accountBooksPrefetched = true;
      logStartupDebug(
          'prefetch_account_books_ms=${stepStopwatch.elapsedMilliseconds}');
    } else {
      logStartupDebug('prefetch_skipped_no_token');
    }
  } catch (e) {
    // Prefetch 실패해도 앱은 정상 진행 (HomeScreen에서 재시도)
    logStartupDebug('prefetch_account_books_failed: $e');
  }

  final totalMs = initStopwatch.elapsedMilliseconds;
  if (totalMs < kMinimumSplashDuration.inMilliseconds) {
    await Future.delayed(
      kMinimumSplashDuration - Duration(milliseconds: totalMs),
    );
  }
  logStartupDebug('app_init_total_ms=$totalMs');
  logStartupProfile('app_init_total_ms=$totalMs');
  logStartupRelease('app_init_total_ms=$totalMs');

  return AppInitialization(
    sharedPreferences: sharedPreferences,
    globalBrandSource: globalBrandSource,
    userBrandSource: userBrandSource,
    accountBooksPrefetched: accountBooksPrefetched,
  );
});
