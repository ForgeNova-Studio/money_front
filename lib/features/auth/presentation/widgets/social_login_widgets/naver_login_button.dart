import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 네이버 로그인 버튼 위젯
///
/// 네이버 공식 디자인 가이드라인을 준수한 로그인 버튼입니다.
/// Reference: https://developers.naver.com/docs/login/bi/bi.md
///
/// **주요 기능 (Key Features):**
/// - 네이버 로고 및 텍스트 표시
/// - 완성형('네이버로 로그인') 및 축약형('네이버 로그인') 지원
/// - 공식 색상(Green/White) 적용
///
/// **파라미터 (Parameters):**
/// - [onPressed]: 버튼 클릭 시 콜백
/// - [isLoading]: 로딩 진행 여부
/// - [useShortLabel]: 축약형 라벨 사용 여부 (기본값: true)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// NaverLoginButton(
///   onPressed: viewModel.loginWithNaver,
///   isLoading: authState.isLoading,
/// )
/// ```
class NaverLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  /// 완성형: '네이버로 로그인', 축약형: '네이버 로그인'
  final bool useShortLabel;

  const NaverLoginButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.useShortLabel = true,
  });

  // 네이버 공식 색상 - 녹색 배경 권장
  static const Color naverGreen = Color(0xFF03C75A);
  static const Color naverWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: naverGreen,
          foregroundColor: naverWhite,
          disabledBackgroundColor: naverGreen.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 네이버 N 로고
            SvgPicture.asset(
              'assets/images/naver_logo.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                naverWhite,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            // 시스템 기본 서체 사용
            Text(
              useShortLabel ? '네이버 로그인' : '네이버로 로그인',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: naverWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
