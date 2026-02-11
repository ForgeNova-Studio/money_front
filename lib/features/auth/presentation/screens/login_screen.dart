// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    // 메시지에서 provider 추출 (예: "NAVER", "GOOGLE" 등)
    String providerName = '';
    if (message.contains('NAVER')) {
      providerName = '네이버';
    } else if (message.contains('GOOGLE')) {
      providerName = '구글';
    } else if (message.contains('KAKAO')) {
      providerName = '카카오';
    } else if (message.contains('EMAIL')) {
      providerName = '이메일';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('로그인 안내'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이 이메일은 이미 가입되어 있어요.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$providerName 로그인을 이용해주세요.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
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
      return '이메일';
    default:
      return null;
  }
}
