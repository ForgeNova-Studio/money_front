import 'package:flutter/material.dart';

/// 커스텀 텍스트 입력 필드
///
/// 앱 전반에서 사용되는 스타일이 적용된 TextField 위젯입니다.
/// 아이콘, 비밀번호 숨김/표시 토글, 유효성 검사 에러 표시 등의 기능을 지원합니다.
///
/// **주요 기능 (Key Features):**
/// - 일관된 디자인 스타일 적용 (Rounded Border, Fill Color 등)
/// - 비밀번호 모드 지원 (가시성 토글 버튼 자동 표시)
/// - 아이콘 및 에러 메시지 표시
///
/// **파라미터 (Parameters):**
/// - [controller]: 텍스트 컨트롤러
/// - [hintText]: 플레이스홀더 텍스트
/// - [icon]: 입력 필드 우측에 표시될 아이콘 (비밀번호 모드가 아닐 때)
/// - [isPassword]: 비밀번호 입력 필드 여부
/// - [isPasswordVisible]: 비밀번호 가시성 상태 (외부 상태 관리 필요)
/// - [onVisibilityToggle]: 비밀번호 가시성 토글 콜백
/// - [keyboardType]: 키보드 타입
/// - [enabled]: 활성화 여부
/// - [errorText]: 유효성 검사 실패 시 표시할 에러 메시지
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// CustomTextField(
///   controller: emailController,
///   hintText: '이메일',
///   icon: Icons.email,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;
  final TextInputType keyboardType;
  final bool enabled;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.focusNode,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      onChanged: onChanged,
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: keyboardType,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onVisibilityToggle,
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              )
            : (icon != null
                ? Icon(
                    icon,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  )
                : null),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
