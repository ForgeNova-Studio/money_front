// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// cores

import 'package:moamoa/features/auth/presentation/widgets/google_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/naver_login_button.dart';
import 'package:moamoa/router/route_names.dart';

// widgets
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/widgets/login_title.dart';
import 'package:moamoa/features/auth/presentation/widgets/login_divider.dart';
import 'package:moamoa/features/auth/presentation/widgets/last_login_hint.dart';
import 'package:moamoa/features/auth/presentation/widgets/login_method_alert_dialog.dart';
import 'package:moamoa/features/auth/presentation/widgets/link_find_password.dart';
import 'package:moamoa/features/auth/presentation/widgets/link_register.dart';
import 'package:moamoa/features/auth/presentation/widgets/login_button.dart';

// viewmodels and providers
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

/// 이메일 및 소셜 로그인을 제공하는 인증 메인 화면입니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일/비밀번호 입력 및 로그인 (`_handleLogin`)
/// - 소셜 로그인 버튼 제공 (Google, Naver, Kakao)
/// - 로그인 에러 발생 시 사용자 친화적인 안내 다이얼로그 표시 (`showLoginMethodAlert`)
/// - 마지막 로그인 방법 힌트 제공 (`LastLoginHint` 위젯)
/// - 회원가입 및 비밀번호 찾기 화면으로의 네비게이션
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// context.go(RouteNames.login);
/// // or
/// const LoginScreen();
/// ```
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
      _handleError(authState.errorMessage!);
    }
  }

  /// 에러 처리 (Alert Dialog 또는 Toast)
  void _handleError(String message) {
    if (message.contains('로그인으로 가입되어 있습니다')) {
      debugPrint('[LoginScreen] 에러로 AlertDialog 표시');
      showLoginMethodAlert(
        context,
        message: message,
        onNaverLogin: _handleNaverLogin,
        onGoogleLogin: _handleGoogleLogin,
        onKakaoLogin: _handleKakaoLogin,
      );
    } else {
      if (mounted) {
        context.showErrorToast(message);
      }
    }

    // 에러 표시 후 상태 초기화 (메시지 중복 표시 방지)
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 인증 상태 관리
    final authState = ref.watch(authViewModelProvider);

    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 다른 화면으로 이동할 때는 리스너를 건너뜀
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      debugPrint(
          '[LoginScreen] listener - isCurrent: $isCurrent, errorMessage: ${next.errorMessage}');

      if (!isCurrent) return;

      // 에러 발생 시
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        debugPrint('[LoginScreen] 에러 메시지: ${next.errorMessage}');
        _handleError(next.errorMessage!);
      }
    });

    /// 화면 구성
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
                const LoginTitle(),

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
                LinkFindPassword(onTap: _handleForgotPassword),

                SizedBox(height: 12),

                // 로그인 버튼
                LoginButton(
                  onPressed: _handleLogin,
                  isLoading: authState.isLoading,
                ),

                SizedBox(height: 24),

                // 구분선 (or)
                const LoginDivider(),

                SizedBox(height: 24),

                // 마지막 로그인 방법 힌트
                const LastLoginHint(),

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
                LinkRegister(onTap: _handleSignUp),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
