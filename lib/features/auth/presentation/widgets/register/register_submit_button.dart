import 'package:flutter/material.dart';

/// 회원가입 제출 버튼 위젯
///
/// 회원가입 폼 작성이 완료되었을 때 가입 요청을 보내는 버튼입니다.
///
/// **주요 기능 (Key Features):**
/// - 로딩 상태 표시 (CircularProgressIndicator)
/// - 버튼 비활성화 (로딩 중 또는 유효성 검사 실패 시)
///
/// **파라미터 (Parameters):**
/// - [isLoading]: 로딩 진행 여부
/// - [onPressed]: 버튼 클릭 시 콜백 (null일 경우 비활성화)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// RegisterSubmitButton(
///   isLoading: state.isLoading,
///   onPressed: state.isValid ? _submit : null,
/// )
/// ```
class RegisterSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primaryContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : const Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
