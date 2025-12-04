import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/auth/presentation/widgets/social_login_type.dart';

/// 소셜 로그인 버튼 위젯 (Enum 사용 버전)
///
/// 사용 예시:
/// ```dart
/// SocialLoginButtonV2(
///   type: SocialLoginType.apple,
///   onPressed: _handleAppleLogin,
/// )
/// ```
class SocialLoginButtonV2 extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback onPressed;

  const SocialLoginButtonV2({
    super.key,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.gray300,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: type.icon,
        label: Text(
          type.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
