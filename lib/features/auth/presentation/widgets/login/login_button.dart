import 'package:flutter/material.dart';

/// 이메일 로그인 버튼 위젯
///
/// 사용자가 이메일/비밀번호 입력을 완료하고 로그인 요청을 보낼 때 사용하는 버튼입니다.
///
/// **주요 기능 (Key Features):**
/// - 로딩 상태(`isLoading`)에 따른 버튼 비활성화 및 UI 처리
/// - 버튼 라벨 커스터마이징 (`label`)
///
/// **파라미터 (Parameters):**
/// - [onPressed]: 버튼 클릭 시 실행될 콜백 (로그인 요청 등)
/// - [isLoading]: 로딩 진행 여부 (true일 경우 버튼 비활성화)
/// - [label]: 버튼에 표시될 텍스트 (기본값: '로그인')
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// LoginButton(
///   onPressed: _handleLogin,
///   isLoading: authState.isLoading,
/// )
/// ```
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = '로그인',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        // 로딩 중이면 버튼 비활성화 (onPressed를 null로 처리해도 되지만, 명시적으로 isLoading 체크)
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primaryContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
