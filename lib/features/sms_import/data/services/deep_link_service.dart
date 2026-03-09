import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deep_link_service.g.dart';

/// 딥링크 데이터
class DeepLinkData {
  final String cardCompanyId;
  final String smsText;

  const DeepLinkData({
    required this.cardCompanyId,
    required this.smsText,
  });

  @override
  String toString() => 'DeepLinkData(card: $cardCompanyId, text: $smsText)';
}

/// 딥링크 서비스
/// moamoa://import?card=samsung&text={SMS_TEXT} 형식의 딥링크 처리
@Riverpod(keepAlive: true)
class DeepLinkService extends _$DeepLinkService {
  static const _channel = MethodChannel('moamoa/deeplink');

  DateTime? _lastProcessedTime;
  String? _lastProcessedUri;

  @override
  DeepLinkData? build() {
    // iOS에서 딥링크 수신 시 호출되는 메소드 핸들러
    _channel.setMethodCallHandler(_handleMethodCall);

    // 앱이 딥링크로 시작된 경우 초기 링크 가져오기
    _getInitialLink();

    return null;
  }

  /// 딥링크 데이터 소비 (한 번 읽으면 null로 초기화)
  DeepLinkData? consume() {
    final data = state;
    if (data != null) {
      state = null;
    }
    return data;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onDeepLink') {
      final uri = call.arguments as String?;
      if (uri != null) {
        _processUri(uri);
      }
    }
  }

  Future<void> _getInitialLink() async {
    try {
      final uri = await _channel.invokeMethod<String>('getInitialLink');
      if (uri != null) {
        _processUri(uri);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[DeepLinkService] 초기 링크 가져오기 실패: $e');
      }
    }
  }

  void _processUri(String uriString) {
    // 중복 처리 방지 (2초 내 동일 URI 무시)
    final now = DateTime.now();
    if (_lastProcessedUri == uriString &&
        _lastProcessedTime != null &&
        now.difference(_lastProcessedTime!) < const Duration(seconds: 2)) {
      if (kDebugMode) {
        debugPrint('[DeepLinkService] 중복된 URI 무시: $uriString');
      }
      return;
    }

    _lastProcessedUri = uriString;
    _lastProcessedTime = now;

    try {
      final uri = Uri.parse(uriString);

      // moamoa://import?card=samsung&text=...
      if (uri.scheme == 'moamoa' && uri.host == 'import') {
        final card = uri.queryParameters['card'];
        final text = uri.queryParameters['text'];

        if (card != null && text != null) {
          final data = DeepLinkData(
            cardCompanyId: card,
            smsText: text,
          );

          if (kDebugMode) {
            debugPrint('[DeepLinkService] 딥링크 수신: $data');
          }

          state = data;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[DeepLinkService] URI 파싱 실패: $e');
      }
    }
  }
}
