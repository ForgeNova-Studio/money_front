// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// routes
import 'package:moamoa/router/route_names.dart';

// widgets
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/login_title.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/login_divider.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/last_login_hint.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/login_method_alert_dialog.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/link_find_password.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/link_register.dart';
import 'package:moamoa/features/auth/presentation/widgets/login/login_button.dart';
import 'package:moamoa/features/auth/presentation/layouts/auth_screen_scaffold.dart';
import 'package:moamoa/features/auth/presentation/listeners/auth_ui_event_listener.dart';
import 'package:moamoa/features/auth/presentation/widgets/social_login_widgets/google_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/social_login_widgets/kakao_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/social_login_widgets/naver_login_button.dart';

// viewmodels and providers
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/login_view_model.dart';

/// 이메일 및 소셜 로그인을 제공하는 인증 메인 화면입니다.
///
/// **Key Features:**
/// * 이메일/비밀번호 기반의 일반 로그인 지원
/// * 소셜 로그인 버튼 제공 (Google, Kakao, Naver)
/// * 에러 발생 시 사용자 친화적인 안내 다이얼로그 및 토스트 표시 (`AuthUiEventListener` 등 연동)
/// * 마지막 로그인 방법 힌트 제공 (`LastLoginHint`)
/// * 회원가입 및 비밀번호 찾기 화면으로의 이동 가능
///
/// **Usage Example:**
/// ```dart
/// context.go(RouteNames.login);
/// // 또는 위젯 트리에 직접 포함
/// const LoginScreen();
/// ```
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

/// [LoginScreen]의 상태를 관리하는 State 클래스입니다.
///
/// **Key Features:**
/// * 이메일 및 비밀번호 입력용 `TextEditingController` 리소스 관리
/// * 비밀번호 표시 여부(`_isPasswordVisible`) 토글 상태 관리
/// * 소셜 로그인 중복 가입 에러 시 로그인 수단 전환 및 재시도 다이얼로그 노출 처리
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 소셜 로그인 중복 가입 에러 시 로그인 수단 전환 및 재시도 다이얼로그 노출
  void _showLoginMethodDialog(
    BuildContext context,
    LoginProviderType provider,
    String message,
  ) {
    // 다이얼로그 위젯 호출
    showLoginMethodAlert(
      context,
      provider: provider,
      onNaverLogin: () => _retrySocialLogin(LoginProviderType.naver),
      onGoogleLogin: () => _retrySocialLogin(LoginProviderType.google),
      onKakaoLogin: () => _retrySocialLogin(LoginProviderType.kakao),
    );
  }

  // 소셜 로그인 다른 방법으로 시도
  // - 예) 기존 카카오 화원이 카카오가 아닌 다른 로그인 사용시 안내 다이얼로그의 버튼 기능
  Future<void> _retrySocialLogin(LoginProviderType provider) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(loginViewModelProvider).loginWithProvider(provider);
  }

  @override
  Widget build(BuildContext context) {
    // 인증 상태 관리
    final authState = ref.watch(authViewModelProvider);

    /// 화면 구성
    return AuthUiEventListener(
      onLoginMethodDialog: _showLoginMethodDialog,
      child: AuthScreenScaffold(
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
              icon: Icons.email_outlined,
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

            const SizedBox(height: 12),

            // 비밀번호 찾기 링크
            LinkFindPassword(
              onTap: () => context.push(RouteNames.findPassword),
            ),

            const SizedBox(height: 12),

            // 로그인 버튼
            LoginButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                await ref.read(loginViewModelProvider).loginWithEmail(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
              },
              isLoading: authState.isLoading,
            ),

            const SizedBox(height: 24),

            // 구분선 (or)
            const LoginDivider(),

            const SizedBox(height: 24),

            // 마지막 로그인 방법 힌트
            const LastLoginHint(),

            // Google 로그인 버튼 (공식 브랜드 가이드라인 적용)
            GoogleLoginButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await ref.read(loginViewModelProvider).loginWithGoogle();
                    },
              isLoading: authState.isLoading,
            ),

            const SizedBox(height: 16),

            // 카카오 로그인 버튼 (공식 디자인 가이드라인 적용)
            KakaoLoginButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await ref.read(loginViewModelProvider).loginWithKakao();
                    },
              isLoading: authState.isLoading,
            ),

            const SizedBox(height: 16),

            // 네이버 로그인 버튼 (공식 디자인 가이드라인 적용)
            NaverLoginButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await ref.read(loginViewModelProvider).loginWithNaver();
                    },
              isLoading: authState.isLoading,
            ),

            const SizedBox(height: 32),

            // 회원가입 링크
            // 회원가입 링크
            LinkRegister(
              onTap: () => context.push(RouteNames.register),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
