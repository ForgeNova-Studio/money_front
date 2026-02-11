// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

// cores
import 'package:moamoa/core/constants/app_constants.dart';

import 'package:moamoa/features/auth/presentation/widgets/google_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/naver_login_button.dart';
import 'package:moamoa/router/route_names.dart';

// widgets
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';

// viewmodels and providers
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';

/// 로그인 화면
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _hasCheckedInitialError = false;

  @override
  void initState() {
    super.initState();
    // 화면 로드 후 첫 프레임에서 기존 에러 메시지 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 화면 로드 시 이미 존재하는 에러 메시지 확인
  void _checkInitialError() {
    if (_hasCheckedInitialError) return;
    _hasCheckedInitialError = true;

    final authState = ref.read(authViewModelProvider);
    debugPrint('[LoginScreen] 초기 에러 확인: ${authState.errorMessage}');

    if (authState.errorMessage != null) {
      if (authState.errorMessage!.contains('로그인으로 가입되어 있습니다')) {
        debugPrint('[LoginScreen] 초기 에러로 AlertDialog 표시');
        _showLoginMethodAlert(context, authState.errorMessage!);
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    }
  }

  // ViewModel의 login 메서드 호출
  Future<void> _handleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authViewModelProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  // ViewModel의 loginWithGoogle 메서드 호출
  Future<void> _handleGoogleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authViewModelProvider.notifier).loginWithGoogle();
  }

  // ViewModel의 loginWithNaver 메서드 호출
  Future<void> _handleNaverLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authViewModelProvider.notifier).loginWithNaver();
  }

  // ViewModel의 loginWithKakao 메서드 호출
  Future<void> _handleKakaoLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authViewModelProvider.notifier).loginWithKakao();
  }

  // 비밀번호 찾기 화면으로 이동
  void _handleForgotPassword() {
    context.push(RouteNames.findPassword);
  }

  // 회원가입 화면으로 이동
  void _handleSignUp() {
    context.push(RouteNames.register);
  }

  // 다른 로그인 방법 안내 AlertDialog
  void _showLoginMethodAlert(BuildContext context, String message) {
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
                color: Colors.black.withOpacity(0.1),
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
                        size: 32,
                        color: Theme.of(context).colorScheme.onPrimary)
                    : Center(
                        child: SvgPicture.asset(
                          iconPath,
                          width: providerName == '네이버'
                              ? 24
                              : 32, // 네이버 아이콘만 조금 더 작게
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
                      _handleNaverLogin();
                    } else if (providerName == 'Google') {
                      _handleGoogleLogin();
                    } else if (providerName == '카카오') {
                      _handleKakaoLogin();
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);
    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 다른 화면으로 이동할 때는 리스너를 건너뜀
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      debugPrint(
          '[LoginScreen] listener - isCurrent: $isCurrent, errorMessage: ${next.errorMessage}');
      if (!isCurrent) {
        return;
      }
      // 로그인 성공 시 홈 화면으로 이동
      if (next.isAuthenticated && next.user != null) {
        // 명시적으로 홈 화면으로 이동 (redirect 로직도 백업으로 유지됨)
        context.go(RouteNames.home);
      }

      // 에러 발생 시
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        debugPrint('[LoginScreen] 에러 메시지: ${next.errorMessage}');
        // 다른 로그인 방법으로 가입된 경우 AlertDialog 표시
        if (next.errorMessage!.contains('로그인으로 가입되어 있습니다')) {
          debugPrint('[LoginScreen] AlertDialog 표시 시도');
          _showLoginMethodAlert(context, next.errorMessage!);
          Future.delayed(Duration(milliseconds: 100), () {
            if (mounted) {
              ref.read(authViewModelProvider.notifier).clearError();
            }
          });
          return;
        }

        if (mounted) {
          context.showErrorToast(next.errorMessage!);
        }

        // 에러 메시지 표시 후 초기화
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // 키보드 닫기!! (홈 화면에서 오버플로우 발생 방지)
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // 타이틀
                _buildLoginTitle(context),

                const SizedBox(height: 40),

                // 이메일 입력 필드
                CustomTextField(
                  controller: _emailController,
                  hintText: '이메일',
                  icon: Icons.edit_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                CustomTextField(
                  controller: _passwordController,
                  hintText: '비밀번호',
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),

                SizedBox(height: 12),

                // 비밀번호 찾기 링크
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: context.appColors.textSecondary,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        '비밀번호를 잊으셨나요?',
                        style: TextStyle(
                          fontSize: 15,
                          color: context.appColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    // 로딩 중이면 버튼 비활성화
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor: colorScheme.primaryContainer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // 구분선 (or)
                _buildRowDivider(context),

                SizedBox(height: 24),

                // 마지막 로그인 방법 힌트
                _buildLastLoginHint(ref),

                // Google 로그인 버튼 (공식 브랜드 가이드라인 적용)
                GoogleLoginButton(
                  onPressed: authState.isLoading ? null : _handleGoogleLogin,
                  isLoading: false,
                ),

                SizedBox(height: 16),

                // 카카오 로그인 버튼 (공식 디자인 가이드라인 적용)
                KakaoLoginButton(
                  onPressed: authState.isLoading ? null : _handleKakaoLogin,
                  isLoading: false,
                ),

                const SizedBox(height: 16),

                // 네이버 로그인 버튼 (공식 디자인 가이드라인 적용)
                NaverLoginButton(
                  onPressed: authState.isLoading ? null : _handleNaverLogin,
                  isLoading: false,
                ),

                SizedBox(height: 32),

                // 회원가입 링크
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '모아모아가 처음이신가요? ',
                        style: TextStyle(
                          fontSize: 15,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: _handleSignUp,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// LoginScreen 타이틀 위젯
Widget _buildLoginTitle(BuildContext context) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_rounded,
          size: 80,
          color: Colors.black,
        ),
      ],
    ),
  );
}

// 가로 구분선 위젯
Widget _buildRowDivider(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  return Row(
    children: [
      Expanded(
        child: Divider(
          color: colorScheme.outlineVariant,
          thickness: 1,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'or',
          style: TextStyle(
            fontSize: 14,
            color: context.appColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        child: Divider(
          color: colorScheme.outlineVariant,
          thickness: 1,
        ),
      ),
    ],
  );
}

// 마지막 로그인 방법 힌트 위젯
Widget _buildLastLoginHint(WidgetRef ref) {
  final lastLoginAsync = ref.watch(lastLoginProviderProvider);

  return lastLoginAsync.when(
    data: (provider) {
      if (provider == null) return const SizedBox.shrink();

      final providerName = _getProviderDisplayName(provider);
      if (providerName == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              '지난번에 $providerName로 로그인했어요',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    },
    loading: () => const SizedBox.shrink(),
    error: (_, __) => const SizedBox.shrink(),
  );
}

// 로그인 방법 표시 이름
String? _getProviderDisplayName(String provider) {
  switch (provider.toUpperCase()) {
    case 'GOOGLE':
      return 'Google';
    case 'APPLE':
      return 'Apple';
    case 'NAVER':
      return '네이버';
    case 'KAKAO':
      return '카카오';
    case 'EMAIL':
      return '모아모아 Email';
    default:
      return null;
  }
}
