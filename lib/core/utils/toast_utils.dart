import 'package:flutter/material.dart';

/// BuildContext 확장으로 간편하게 스낵바(토스트)를 표시하는 유틸리티입니다.
///
/// **주요 기능:**
/// *   `showToast`: 기본 스타일의 토스트 메시지를 표시합니다.
/// *   `showErrorToast`: 에러 스타일(붉은색)의 토스트 메시지를 표시합니다.
/// *   이전 스낵바 자동 숨김 처리로 즉각적인 피드백을 제공합니다.
/// *   `mounted` 체크를 통해 안전하게 스낵바를 표시합니다.
///
/// **사용 예시:**
/// ```dart
/// context.showToast('작업이 완료되었습니다.');
/// context.showErrorToast('오류가 발생했습니다.');
/// ```
extension ToastUtils on BuildContext {
  /// 2초 동안 지속되는 기본 토스트 메시지를 표시합니다.
  /// 이전 스낵바가 있다면 즉시 가리고 새 메시지를 보여줍니다.
  void showToast(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    // 위젯 트리에 안 붙어있으면 무시 (안전장치)
    if (!mounted) return;

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
          behavior: SnackBarBehavior.floating, // 테마 설정을 따르겠지만 명시적 지정
        ),
      );
  }

  /// 에러 메시지용 토스트 (필요 시 스타일 변경 가능)
  void showErrorToast(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent, // 에러 느낌 강조
          duration: duration,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
