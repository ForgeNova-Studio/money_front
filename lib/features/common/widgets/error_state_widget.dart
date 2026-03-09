import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/exceptions/exception_handler.dart';

/// 에러 상태를 표시하는 공통 위젯
///
/// 모든 화면에서 통일된 에러 UI를 제공합니다.
/// - 에러 아이콘
/// - 사용자 친화적 에러 메시지
/// - 다시 시도 버튼
class ErrorStateWidget extends StatelessWidget {
  /// 에러 객체 (자동으로 사용자 친화적 메시지로 변환됨)
  final Object? error;

  /// 직접 메시지를 지정하고 싶을 때 사용 (error보다 우선)
  final String? message;

  /// 다시 시도 버튼 콜백
  final VoidCallback? onRetry;

  /// 다시 시도 버튼 텍스트
  final String retryText;

  /// 아이콘 (기본: error_outline)
  final IconData icon;

  /// 아이콘 크기
  final double iconSize;

  const ErrorStateWidget({
    super.key,
    this.error,
    this.message,
    this.onRetry,
    this.retryText = '다시 시도',
    this.icon = Icons.error_outline,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    // 표시할 메시지 결정 (message > error > 기본)
    final displayMessage = message ??
        (error != null
            ? ExceptionHandler.getUserFriendlyMessage(error!)
            : '오류가 발생했습니다.');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 에러 아이콘
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: appColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: appColors.error,
              ),
            ),
            const SizedBox(height: 16),

            // 에러 메시지
            Text(
              displayMessage,
              style: TextStyle(
                fontSize: 15,
                color: appColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // 다시 시도 버튼
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(retryText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
