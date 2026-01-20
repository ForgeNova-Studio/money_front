import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moneyflow/features/ocr/data/datasources/local/user_brand_source.dart';
import 'package:moneyflow/features/ocr/data/datasources/memory/global_brand_source.dart';

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

  AppInitialization({
    required this.sharedPreferences,
    required this.globalBrandSource,
    required this.userBrandSource,
  });
}

/// 앱 시작 시 필요한 비동기 초기화
final appInitializationProvider = FutureProvider<AppInitialization>((ref) async {
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
  );
});
