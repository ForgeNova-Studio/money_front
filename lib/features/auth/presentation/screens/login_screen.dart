// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// cores

import 'package:moamoa/features/auth/presentation/widgets/social_login_widgets/google_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/social_login_widgets/kakao_login_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/social_login_widgets/naver_login_button.dart';
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

// viewmodels and providers
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/login_view_model.dart';

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
      _handleAuthError(authState.errorMessage!);
    }
  }

  void _handleAuthError(String message) {
    final action =
        ref.read(loginViewModelProvider).resolveLoginErrorAction(message);

    if (action.shouldShowDialog) {
      debugPrint('[LoginScreen] 에러로 AlertDialog 표시');
      showLoginMethodAlert(
        context,
        provider: action.provider,
        onNaverLogin: () => _retrySocialLogin(LoginProviderType.naver),
        onGoogleLogin: () => _retrySocialLogin(LoginProviderType.google),
        onKakaoLogin: () => _retrySocialLogin(LoginProviderType.kakao),
      );
    } else if (mounted) {
      context.showErrorToast(action.message);
    }

    _scheduleErrorClear();
  }

  Future<void> _retrySocialLogin(LoginProviderType provider) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(loginViewModelProvider).loginWithProvider(provider);
  }

  void _scheduleErrorClear() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      ref.read(loginViewModelProvider).clearAuthError();
    });
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
        _handleAuthError(next.errorMessage!);
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
                          await ref
                              .read(loginViewModelProvider)
                              .loginWithGoogle();
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
                          await ref
                              .read(loginViewModelProvider)
                              .loginWithKakao();
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
                          await ref
                              .read(loginViewModelProvider)
                              .loginWithNaver();
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
        ),
      ),
    );
  }
}
