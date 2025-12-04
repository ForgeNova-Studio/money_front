import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

/// 소셜 로그인 타입
enum SocialLoginType {
  apple,
  google,
  kakao,
  naver,
  facebook,
}

extension SocialLoginTypeExtension on SocialLoginType {
  /// 소셜 로그인 버튼 라벨
  String get label {
    switch (this) {
      case SocialLoginType.apple:
        return 'Apple로 로그인';
      case SocialLoginType.google:
        return 'Google로 로그인';
      case SocialLoginType.kakao:
        return 'Kakao로 로그인';
      case SocialLoginType.naver:
        return 'Naver로 로그인';
      case SocialLoginType.facebook:
        return 'Facebook로 로그인';
    }
  }

  /// 소셜 로그인 버튼 아이콘
  Widget get icon {
    switch (this) {
      case SocialLoginType.apple:
        return const Icon(
          Icons.apple,
          color: AppColors.textPrimary,
          size: 24,
        );
      case SocialLoginType.google:
        return Image.network(
          'https://www.google.com/favicon.ico',
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.g_mobiledata,
              color: AppColors.textPrimary,
              size: 24,
            );
          },
        );
      case SocialLoginType.kakao:
        return const Icon(
          Icons.chat_bubble,
          color: Color(0xFFFFE812),
          size: 24,
        );
      case SocialLoginType.naver:
        return const Icon(
          Icons.login,
          color: Color(0xFF03C75A),
          size: 24,
        );
      case SocialLoginType.facebook:
        return const Icon(
          Icons.facebook,
          color: Color(0xFF1877F2),
          size: 24,
        );
    }
  }
}
