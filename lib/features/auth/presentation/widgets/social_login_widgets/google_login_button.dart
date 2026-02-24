import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Google 로그인 버튼 위젯
///
/// Google 공식 브랜드 가이드라인을 준수한 로그인 버튼입니다.
/// Reference: https://developers.google.com/identity/branding-guidelines
///
/// **주요 기능 (Key Features):**
/// - Google 로고 및 "Google로 로그인" 텍스트 표시
/// - Roboto 폰트 사용 (가이드라인 준수)
/// - 로딩 상태 표시
///
/// **파라미터 (Parameters):**
/// - [onPressed]: 버튼 클릭 시 콜백
/// - [isLoading]: 로딩 진행 여부
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// GoogleLoginButton(
///   onPressed: viewModel.loginWithGoogle,
///   isLoading: authState.isLoading,
/// )
/// ```
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleLoginButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F1F1F),
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google 'G' 로고 - 표준 색상, 흰색 배경
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/images/google_logo.svg',
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Roboto Medium 폰트 사용 (공식 가이드라인)
            Text(
              'Google로 로그인',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
