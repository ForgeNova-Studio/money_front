// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// cores
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/router/route_names.dart';

// widgets
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moneyflow/features/auth/presentation/widgets/social_login_button.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

/// 로그인 화면
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenSampleState();
}

class _LoginScreenSampleState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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

  // ViewModel의 loginWithApple 메서드 호출
  Future<void> _handleAppleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authViewModelProvider.notifier).loginWithApple();
  }

  // ViewModel의 loginWithGoogle 메서드 호출
  Future<void> _handleGoogleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authViewModelProvider.notifier).loginWithGoogle();
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
    final authState = ref.watch(authViewModelProvider);
    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 다른 화면으로 이동할 때는 리스너를 건너뜀
      if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
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
        backgroundColor: context.appColors.backgroundWhite,
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
                      backgroundColor: context.appColors.primary,
                      foregroundColor: context.appColors.textWhite,
                      disabledBackgroundColor:
                          context.appColors.primaryPale,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    // 로딩 상태 여부에 따라 위젯 분기
                    // 로딩 중: 로딩 인디케이터 표시
                    // 로딩 완료: 로그인 버튼 표시
                    child: authState.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.appColors.textWhite,
                              ),
                            ),
                          )
                        : const Text(
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

                // Apple 로그인 버튼
                SocialLoginButton(
                  label: 'Apple로 로그인',
                  icon: Icon(
                    Icons.apple,
                    color: context.appColors.textPrimary,
                    size: 24,
                  ),
                  onPressed:
                      authState.isLoading ? null : () => _handleAppleLogin(),
                ),

                SizedBox(height: 16),

                // Google 로그인 버튼
                SocialLoginButton(
                  label: 'Google로 로그인',
                  icon: Image.network(
                    'https://www.google.com/favicon.ico',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.g_mobiledata,
                        color: context.appColors.textPrimary,
                        size: 24,
                      );
                    },
                  ),
                  onPressed:
                      authState.isLoading ? null : () => _handleGoogleLogin(),
                ),

                SizedBox(height: 32),

                // 회원가입 링크
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MoneyFlow가 처음이신가요? ',
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
                            color: context.appColors.primary,
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'MoneyFlow',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: context.appColors.textPrimary,
          height: 1.2,
        ),
      ),

      SizedBox(height: 6),

      // 서브타이틀
      Text(
        '계정을 선택해주세요.',
        style: TextStyle(
          fontSize: 16,
          color: context.appColors.textSecondary,
          height: 1.5,
        ),
      )
    ],
  );
}

// 가로 구분선 위젯
Widget _buildRowDivider(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Divider(
          color: context.appColors.gray200,
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
          color: context.appColors.gray200,
          thickness: 1,
        ),
      ),
    ],
  );
}
