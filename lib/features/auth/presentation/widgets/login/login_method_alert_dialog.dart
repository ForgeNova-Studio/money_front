import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 로그인 방법 안내 알림창 표시 함수
///
/// 사용자가 이미 가입된 계정(소셜/이메일)이 있을 경우,
/// 해당 로그인 방법으로 유도하는 안내 다이얼로그를 표시합니다.
///
/// **주요 기능 (Key Features):**
/// - 가입된 제공업체(Naver, Google, Kakao, Email)에 따라 맞춤 UI 표시
/// - 해당 제공업체의 로그인 버튼 제공 및 콜백 연결
/// - 브랜드별 색상 및 아이콘 적용
///
/// **파라미터 (Parameters):**
/// - [context]: 다이얼로그를 표시할 BuildContext
/// - [message]: 백엔드에서 전달받은 에러 메시지 (제공업체 정보 포함)
/// - [onNaverLogin]: 네이버 로그인 콜백
/// - [onGoogleLogin]: 구글 로그인 콜백
/// - [onKakaoLogin]: 카카오 로그인 콜백
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// showLoginMethodAlert(
///   context,
///   message: 'User already exists with ... NAVER',
///   onNaverLogin: _viewModel.loginWithNaver,
///   // ... other callbacks
/// );
/// ```
void showLoginMethodAlert(
  BuildContext context, {
  required String message,
  required VoidCallback onNaverLogin,
  required VoidCallback onGoogleLogin,
  required VoidCallback onKakaoLogin,
}) {
  // 메시지에서 provider 추출
  String providerName = '';
  String iconPath = '';
  Color backgroundColor = Colors.white;
  Color textColor = Colors.black;
  String buttonText = '확인';

  if (message.contains('NAVER')) {
    providerName = '네이버';
    iconPath = 'assets/images/naver_logo.svg';
    backgroundColor = const Color(0xFF03C75A);
    textColor = Colors.white;
    buttonText = '네이버로 로그인';
  } else if (message.contains('GOOGLE')) {
    providerName = 'Google';
    iconPath = 'assets/images/google_logo.svg';
    backgroundColor = Colors.white;
    textColor = Colors.black; // 구글은 보통 흰배경에 검은글씨/회색테두리
    buttonText = 'Google로 로그인';
  } else if (message.contains('KAKAO')) {
    providerName = '카카오';
    iconPath = 'assets/images/kakao_symbol.svg';
    backgroundColor = const Color(0xFFFEE500);
    textColor = Colors.black;
    buttonText = '카카오로 로그인';
  } else if (message.contains('EMAIL')) {
    providerName = '모아모아 Email';
    // 이메일 아이콘은 기본 아이콘 사용
    backgroundColor = Theme.of(context).colorScheme.primary;
    textColor = Theme.of(context).colorScheme.onPrimary;
    buttonText = '모아모아 Email로 로그인';
  }

  showDialog(
    context: context,
    barrierDismissible: false, // 명시적 확인 유도
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. 아이콘 영역
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor == Colors.white
                    ? Colors.grey[100] // 구글 등 흰 배경일 때는 연한 회색 원
                    : backgroundColor, // 네이버/카카오 등은 해당 브랜드 컬러 원
                shape: BoxShape.circle,
              ),
              child: providerName == '모아모아 Email'
                  ? Icon(Icons.email_outlined,
                      size: 32, color: Theme.of(context).colorScheme.onPrimary)
                  : Center(
                      child: SvgPicture.asset(
                        iconPath,
                        width:
                            providerName == '네이버' ? 24 : 32, // 네이버 아이콘만 조금 더 작게
                        height: providerName == '네이버' ? 24 : 32,
                        // 배경색이 브랜드 컬러인 경우 아이콘을 흰색으로 변경할지 여부 고민 필요
                        // 네이버 로고는 보통 흰색 N이므로 그대로 두거나 흰색 필터 적용
                        // 카카오는 노란 배경에 갈색 심볼이므로 그대로 둠
                        // 구글은 흰 배경(회색원)에 컬러 로고이므로 그대로 둠
                        colorFilter: providerName == '네이버'
                            ? const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn)
                            : null,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // 2. 타이틀
            const Text(
              '이미 가입된 계정이 있어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 3. 안내 메시지
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: '회원님은 '),
                  TextSpan(
                    text: providerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: providerName == '모아모아 Email'
                          ? Theme.of(context).colorScheme.primary
                          : (providerName == '네이버'
                              ? const Color(0xFF03C75A)
                              : (providerName == '카카오'
                                  ? Colors.brown
                                  : Colors.black)),
                    ),
                  ),
                  const TextSpan(text: ' 계정으로\n가입되어 있습니다.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. 액션 버튼 (해당 소셜 로그인 색상 적용)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 닫기
                  // 각 제공업체별 로그인 함수 호출
                  if (providerName == '네이버') {
                    onNaverLogin();
                  } else if (providerName == 'Google') {
                    onGoogleLogin();
                  } else if (providerName == '카카오') {
                    onKakaoLogin();
                  } else if (providerName == '모아모아 Email') {
                    // 이메일의 경우 로그인 화면으로 포커스를 주거나 그냥 닫음
                    // 현재 로그인 화면이므로 별도 이동 불필요
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: textColor,
                  elevation: 0,
                  side: providerName == 'Google'
                      ? const BorderSide(color: Colors.grey, width: 0.5)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (providerName != '모아모아 Email') ...[
                      SvgPicture.asset(
                        iconPath,
                        width: 20,
                        height: 20,
                        // 네이버/카카오는 원본 색상 유지 vs 흰색 아이콘?
                        // 에셋 자체가 로고 색상이 포함되어 있으므로 컬러 필터 없이 사용하거나
                        // 배경색에 따라 조정 필요. 여기서는 에셋 원본 사용.
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 5. 닫기/취소 버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    ),
  );
}
