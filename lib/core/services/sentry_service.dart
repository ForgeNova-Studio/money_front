import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'sentry_service.g.dart';

/// Sentry 서비스 Provider
@riverpod
SentryService sentryService(Ref ref) {
  return SentryService();
}

/// Sentry 에러 모니터링 서비스
///
/// 무료 플랜 최적화:
/// - 프로덕션에서만 에러 전송
/// - 중복 에러 필터링 (5분 내 같은 에러 재전송 방지)
/// - 사용자 컨텍스트 설정
class SentryService {
  // 중복 에러 필터링을 위한 캐시
  final Map<String, DateTime> _recentErrors = {};
  static const Duration _duplicateThreshold = Duration(minutes: 5);

  /// 에러 캡쳐 (중복 필터링 적용)
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) async {
    // 개발 환경에서는 전송하지 않음
    if (kDebugMode) {
      debugPrint('[Sentry] Debug mode - not sending: $exception');
      return;
    }

    // 중복 에러 필터링
    final fingerprint = _generateFingerprint(exception);
    if (_isDuplicate(fingerprint)) {
      debugPrint('[Sentry] Duplicate error filtered: $fingerprint');
      return;
    }

    try {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          if (extras != null) {
            extras.forEach((key, value) {
              scope.setExtra(key, value);
            });
          }
        },
      );
    } catch (e) {
      debugPrint('[Sentry] Failed to capture exception: $e');
    }
  }

  /// 메시지 전송
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extras,
  }) async {
    if (kDebugMode) return;

    try {
      await Sentry.captureMessage(
        message,
        level: level,
        withScope: (scope) {
          if (extras != null) {
            extras.forEach((key, value) {
              scope.setExtra(key, value);
            });
          }
        },
      );
    } catch (e) {
      debugPrint('[Sentry] Failed to capture message: $e');
    }
  }

  /// 사용자 컨텍스트 설정 (로그인 후 호출)
  Future<void> setUser({
    required String userId,
    String? email,
  }) async {
    try {
      await Sentry.configureScope((scope) {
        scope.setUser(SentryUser(
          id: userId,
          email: email,
        ));
      });
    } catch (e) {
      debugPrint('[Sentry] Failed to set user: $e');
    }
  }

  /// 사용자 컨텍스트 제거 (로그아웃 후 호출)
  Future<void> clearUser() async {
    try {
      await Sentry.configureScope((scope) {
        scope.setUser(null);
      });
    } catch (e) {
      debugPrint('[Sentry] Failed to clear user: $e');
    }
  }

  /// API 에러 캡쳐 (5xx 에러만)
  Future<void> captureApiError({
    required String url,
    required int statusCode,
    String? method,
    String? responseBody,
  }) async {
    // 5xx 에러만 캡쳐
    if (statusCode < 500) return;

    await captureMessage(
      'API Error: $method $url - $statusCode',
      level: SentryLevel.error,
      extras: {
        'url': url,
        'method': method ?? 'UNKNOWN',
        'statusCode': statusCode,
        'responseBody': responseBody?.substring(0, 500), // 500자로 제한
      },
    );
  }

  /// 중복 에러 체크
  bool _isDuplicate(String fingerprint) {
    final now = DateTime.now();
    final lastSent = _recentErrors[fingerprint];

    if (lastSent != null && now.difference(lastSent) < _duplicateThreshold) {
      return true;
    }

    _recentErrors[fingerprint] = now;

    // 오래된 항목 정리
    if (_recentErrors.length > 100) {
      _recentErrors.removeWhere(
        (key, value) => now.difference(value) > _duplicateThreshold,
      );
    }

    return false;
  }

  /// 에러 fingerprint 생성
  String _generateFingerprint(dynamic exception) {
    final type = exception.runtimeType.toString();
    final message = exception
        .toString()
        .substring(0, 100.clamp(0, exception.toString().length));
    return '$type:$message';
  }
}
