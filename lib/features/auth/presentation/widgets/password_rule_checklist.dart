import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/validators/input_validator.dart';

/// 비밀번호 규칙 체크리스트 위젯
///
/// 입력된 비밀번호가 보안 규칙을 만족하는지 실시간으로 시각화하여 보여줍니다.
///
/// **주요 기능 (Key Features):**
/// - 비밀번호 복잡도 규칙 검사 (길이, 대소문자, 숫자, 특수문자)
/// - 규칙 만족 여부에 따른 아이콘 및 색상 변경
///
/// **파라미터 (Parameters):**
/// - [password]: 검사할 비밀번호 문자열
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// PasswordRuleChecklist(
///   password: _passwordController.text,
/// )
/// ```
class PasswordRuleChecklist extends StatelessWidget {
  final String password;

  const PasswordRuleChecklist({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final hasMinLength = password.length >= InputValidator.passwordMinLength;
    final hasUpperCase = InputValidator.uppercaseRegex.hasMatch(password);
    final hasLowerCase = InputValidator.lowercaseRegex.hasMatch(password);
    final hasDigit = InputValidator.digitRegex.hasMatch(password);
    final hasSpecialChar = InputValidator.specialCharRegex.hasMatch(password);
    final textStyle = TextStyle(
      fontSize: 12,
      color: context.appColors.textSecondary,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PasswordRuleRow(
          label: '최소 ${InputValidator.passwordMinLength}자 이상',
          satisfied: hasMinLength,
          textStyle: textStyle,
        ),
        _PasswordRuleRow(
          label: '대문자 1개 이상',
          satisfied: hasUpperCase,
          textStyle: textStyle,
        ),
        _PasswordRuleRow(
          label: '소문자 1개 이상',
          satisfied: hasLowerCase,
          textStyle: textStyle,
        ),
        _PasswordRuleRow(
          label: '숫자 1개 이상',
          satisfied: hasDigit,
          textStyle: textStyle,
        ),
        _PasswordRuleRow(
          label: '특수문자(@\$!%*?&) 1개 이상',
          satisfied: hasSpecialChar,
          textStyle: textStyle,
        ),
      ],
    );
  }
}

/// 개별 비밀번호 규칙 항목 표시 위젯
class _PasswordRuleRow extends StatelessWidget {
  final String label;
  final bool satisfied;
  final TextStyle textStyle;

  const _PasswordRuleRow({
    required this.label,
    required this.satisfied,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        satisfied ? context.appColors.primary : context.appColors.textTertiary;
    return Row(
      children: [
        Icon(
          satisfied ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(label, style: textStyle),
      ],
    );
  }
}
