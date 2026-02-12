import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 카카오 공식 디자인 가이드라인을 준수한 로그인 버튼
/// Reference: https://developers.kakao.com/docs/latest/ko/kakaologin/design-guide
class KakaoLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  /// 완성형: '카카오로 로그인', 축약형: '카카오 로그인'
  final bool useShortLabel;

  const KakaoLoginButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.useShortLabel = true,
  });

  // 카카오 공식 색상
  static const Color kakaoYellow = Color(0xFFFEE500);
  static const Color kakaoBlack = Color(0xFF000000);
  static const Color kakaoLabel = Color(0xFF191919);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kakaoYellow,
          foregroundColor: kakaoLabel,
          disabledBackgroundColor: kakaoYellow.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            // 공식 가이드라인: border-radius 12px
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(kakaoLabel),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 카카오 말풍선 심볼
                  SvgPicture.asset(
                    'assets/images/kakao_symbol.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      kakaoBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // OS 기본 시스템 서체 사용 (공식 가이드라인)
                  Text(
                    useShortLabel ? '카카오 로그인' : '카카오로 로그인',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: kakaoLabel,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
