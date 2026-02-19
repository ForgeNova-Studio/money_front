import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 데이터 로드 실패 상태를 표시하는 공통 위젯.
///
/// - 메시지 노출
/// - 다시 시도 버튼
/// - (선택) 닫기 버튼
class RetryableLoadErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onClose;
  final String retryLabel;
  final String closeLabel;

  const RetryableLoadErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.onClose,
    this.retryLabel = '다시 시도',
    this.closeLabel = '닫기',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.appColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: onRetry,
                  child: Text(retryLabel),
                ),
                if (onClose != null) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: onClose,
                    child: Text(closeLabel),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
