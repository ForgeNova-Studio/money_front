import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moamoa/features/ocr/data/datasources/local/user_brand_source.dart';
import 'package:moamoa/features/ocr/data/datasources/memory/global_brand_source.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/home/presentation/providers/home_providers.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';

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
  final bool homeDataPrefetched;

  AppInitialization({
    required this.sharedPreferences,
    required this.globalBrandSource,
    required this.userBrandSource,
    this.homeDataPrefetched = false,
  });
}

/// 앱 시작 시 필요한 비동기 초기화
final appInitializationProvider =
    FutureProvider<AppInitialization>((ref) async {
  if (kForceAppInitFailure) {
    throw StateError('Forced app initialization failure');
  }

  // 전체 초기화에 30초 타임아웃 적용
  return await Future.any([
    _initializeApp(ref),
    Future.delayed(const Duration(seconds: 30), () {
      throw TimeoutException('앱 초기화 시간 초과 (30초)');
    }),
  ]);
});

/// 타임아웃 예외 클래스
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

/// 실제 초기화 로직
Future<AppInitialization> _initializeApp(Ref ref) async {
  final initStopwatch = Stopwatch()..start();
  final stepStopwatch = Stopwatch()..start();

  // ============================================================================
  // 필수 초기화 (실패 시 앱 진행 불가)
  // ============================================================================
  late SharedPreferences sharedPreferences;

  try {
    await initializeDateFormatting('ko_KR', null);
    logStartupDebug('init_date_format_ms=${stepStopwatch.elapsedMilliseconds}');

    stepStopwatch
      ..reset()
      ..start();
    sharedPreferences = await SharedPreferences.getInstance();
    logStartupDebug(
        'init_shared_prefs_ms=${stepStopwatch.elapsedMilliseconds}');

    stepStopwatch
      ..reset()
      ..start();
    await Hive.initFlutter();
    logStartupDebug('init_hive_ms=${stepStopwatch.elapsedMilliseconds}');

    // Google Fonts 사전 로드 (FOUT 방지 - 온보딩→로그인 전환 시 텍스트 스케일링 현상 방지)
    stepStopwatch
      ..reset()
      ..start();
    await GoogleFonts.pendingFonts([
      GoogleFonts.roboto(fontWeight: FontWeight.w500),
    ]);
    logStartupDebug(
        'init_google_fonts_ms=${stepStopwatch.elapsedMilliseconds}');
  } catch (e) {
    logStartupDebug('critical_init_failed: $e');
    rethrow; // 필수 초기화 실패 → 앱 진행 불가
  }

  // ============================================================================
  // 선택적 초기화 (실패해도 앱 진행 가능 - OCR 기능만 제한)
  // ============================================================================
  GlobalBrandSource? globalBrandSource;
  UserBrandSource? userBrandSource;

  try {
    stepStopwatch
      ..reset()
      ..start();
    globalBrandSource = GlobalBrandSource();
    await globalBrandSource.initialize();
    logStartupDebug(
        'init_global_brand_ms=${stepStopwatch.elapsedMilliseconds}');

    stepStopwatch
      ..reset()
      ..start();
    userBrandSource = UserBrandSource();
    await userBrandSource.init();
    logStartupDebug('init_user_brand_ms=${stepStopwatch.elapsedMilliseconds}');
  } catch (e) {
    logStartupDebug('optional_init_failed: $e');
    // 선택적 초기화 실패 → 기본값으로 진행
    globalBrandSource ??= GlobalBrandSource();
    userBrandSource ??= UserBrandSource();
  }

  // ============================================================================
  // Prefetch: 인증된 사용자의 홈 화면 데이터 미리 로드
  // ============================================================================
  stepStopwatch
    ..reset()
    ..start();
  bool homeDataPrefetched = false;

  try {
    const secureStorage = FlutterSecureStorage();
    final tokenJson = await secureStorage.read(key: 'auth_token');

    if (tokenJson != null) {
      // 1. 가계부 목록 prefetch
      final accountBooks = await ref.read(accountBooksProvider.future);
      logStartupDebug(
          'prefetch_account_books_ms=${stepStopwatch.elapsedMilliseconds}');

      if (accountBooks.isNotEmpty) {
        // 2. 선택된 가계부 ID 결정 (저장된 값 또는 첫 번째 가계부)
        final userId = _extractUserIdFromToken(tokenJson);
        final selectedAccountBookId = _resolveSelectedAccountBookId(
          sharedPreferences,
          accountBooks,
          userId,
        );

        if (selectedAccountBookId != null) {
          // 3. 월별 데이터, 예산, 자산 정보 병렬로 prefetch
          stepStopwatch
            ..reset()
            ..start();
          final now = DateTime.now();

          await Future.wait([
            // 월별 거래 내역
            _prefetchMonthlyData(ref, now, userId ?? '', selectedAccountBookId),
            // 예산 정보
            _prefetchBudget(ref, now, selectedAccountBookId),
            // 총 자산 정보
            _prefetchAsset(ref, selectedAccountBookId),
          ]);

          homeDataPrefetched = true;
          logStartupDebug(
              'prefetch_home_data_ms=${stepStopwatch.elapsedMilliseconds}');
        }
      }
    } else {
      logStartupDebug('prefetch_skipped_no_token');
    }
  } catch (e) {
    // Prefetch 실패해도 앱은 정상 진행 (HomeScreen에서 재시도)
    logStartupDebug('prefetch_home_data_failed: $e');
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
    homeDataPrefetched: homeDataPrefetched,
  );
}

/// JWT 토큰에서 userId 추출 (간단한 파싱)
String? _extractUserIdFromToken(String tokenJson) {
  try {
    final tokenData = jsonDecode(tokenJson) as Map<String, dynamic>;
    final accessToken = tokenData['accessToken'] as String?;
    if (accessToken == null) return null;

    // JWT payload 디코딩 (Base64)
    final parts = accessToken.split('.');
    if (parts.length != 3) return null;

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final payloadData = jsonDecode(payload) as Map<String, dynamic>;
    return payloadData['userId'] as String?;
  } catch (e) {
    logStartupDebug('extract_user_id_failed: $e');
    return null;
  }
}

/// 저장된 선택 가계부 ID 또는 첫 번째 가계부 ID 반환
String? _resolveSelectedAccountBookId(
  SharedPreferences prefs,
  List<AccountBook> accountBooks,
  String? userId,
) {
  if (accountBooks.isEmpty) return null;

  // SharedPreferences에서 저장된 선택 가계부 ID 확인
  if (userId != null) {
    final storageKey = 'selected_account_book_id_$userId';
    final storedId = prefs.getString(storageKey);
    if (storedId != null) {
      // 저장된 ID가 유효한지 확인
      final isValid = accountBooks.any(
        (book) => book.accountBookId == storedId && book.isActive != false,
      );
      if (isValid) return storedId;
    }
  }

  // 저장된 값이 없거나 유효하지 않으면 첫 번째 활성 가계부 반환
  final activeBooks = accountBooks.where((b) => b.isActive != false).toList();
  return activeBooks.isNotEmpty ? activeBooks.first.accountBookId : null;
}

/// 월별 거래 내역 prefetch
Future<void> _prefetchMonthlyData(
  Ref ref,
  DateTime month,
  String userId,
  String accountBookId,
) async {
  try {
    final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
    await useCase(
      yearMonth: month,
      userId: userId,
      accountBookId: accountBookId,
    );
    logStartupDebug('prefetch_monthly_data_success');
  } catch (e) {
    logStartupDebug('prefetch_monthly_data_failed: $e');
  }
}

/// 예산 정보 prefetch (로컬 캐시에 저장)
Future<void> _prefetchBudget(
  Ref ref,
  DateTime month,
  String accountBookId,
) async {
  try {
    final useCase = ref.read(getMonthlyBudgetUseCaseProvider);
    final budget = await useCase(
      year: month.year,
      month: month.month,
      accountBookId: accountBookId,
    );

    // HomeViewModel이 사용하는 로컬 캐시에 저장
    final homeRepository = ref.read(homeRepositoryProvider);
    await homeRepository.saveCachedBudget(
      month: month,
      accountBookId: accountBookId,
      budget: budget,
    );

    logStartupDebug('prefetch_budget_success');
  } catch (e) {
    logStartupDebug('prefetch_budget_failed: $e');
  }
}

/// 총 자산 정보 prefetch (로컬 캐시에 저장)
Future<void> _prefetchAsset(
  Ref ref,
  String accountBookId,
) async {
  try {
    final useCase = ref.read(getTotalAssetsUseCaseProvider);
    final asset = await useCase(accountBookId: accountBookId);

    // HomeViewModel이 사용하는 로컬 캐시에 저장
    final homeRepository = ref.read(homeRepositoryProvider);
    await homeRepository.saveCachedAsset(
      accountBookId: accountBookId,
      asset: asset,
    );

    logStartupDebug('prefetch_asset_success');
  } catch (e) {
    logStartupDebug('prefetch_asset_failed: $e');
  }
}
