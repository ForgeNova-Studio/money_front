// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// cores
import 'package:moneyflow/core/constants/app_constants.dart';

// features
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/screens/register_screen.dart';
import 'package:moneyflow/features/auth/presentation/screens/find_password_screen.dart';
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moneyflow/features/auth/presentation/widgets/social_login_button.dart';

// presentation
import 'package:moneyflow/presentation/screens/home/home_screen.dart';

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
  void _handleLogin() {
    ref.read(authViewModelProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  void _handleAppleLogin() {
    ref.read(authViewModelProvider.notifier).loginWithApple();
  }

  void _handleGoogleLogin() {
    ref.read(authViewModelProvider.notifier).loginWithGoogle();
  }

  // 비밀번호 찾기 화면으로 이동
  void _handleForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FindPasswordScreen()),
    );
  }

  // 회원가입 화면으로 이동
  void _handleSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 상태 구독
    final authState = ref.watch(authViewModelProvider);

    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 로그인 성공 시
      if (next.isAuthenticated && next.user != null) {
        // 홈 화면으로 이동 (뒤로가기 불가)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }

      // 에러 발생 시
      if (next.errorMessage != null && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        // 에러 메시지 표시 후 초기화
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 키보드 닫기
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // 타이틀
                _buildLoginTitle(),

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
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        '비밀번호를 잊으셨나요?',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: AppColors.textWhite,
                      disabledBackgroundColor: AppColors.primaryPinkPale,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textWhite,
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

                const SizedBox(height: 24),

                // 구분선 (or)
                _buildRowDivider(),

                const SizedBox(height: 24),

                // Apple 로그인 버튼
                SocialLoginButton(
                  label: 'Apple로 로그인',
                  icon: const Icon(
                    Icons.apple,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  onPressed: _handleAppleLogin,
                ),

                const SizedBox(height: 16),

                // Google 로그인 버튼
                SocialLoginButton(
                  label: 'Google로 로그인',
                  icon: Image.network(
                    'https://www.google.com/favicon.ico',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.g_mobiledata,
                        color: AppColors.textPrimary,
                        size: 24,
                      );
                    },
                  ),
                  onPressed: _handleGoogleLogin,
                ),

                const SizedBox(height: 32),

                // 회원가입 링크
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'MoneyFlow가 처음이신가요? ',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: _handleSignUp,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.primaryPink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
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

// LoginScreen 타이틀 위젯
Widget _buildLoginTitle() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'MoneyFlow',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
      ),

      SizedBox(height: 6),

      // 서브타이틀
      Text(
        '계정을 선택해주세요.',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      )
    ],
  );
}

// 가로 구분선 위젯
Widget _buildRowDivider() {
  return const Row(
    children: [
      Expanded(
        child: Divider(
          color: AppColors.gray200,
          thickness: 1,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'or',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        child: Divider(
          color: AppColors.gray200,
          thickness: 1,
        ),
      ),
    ],
  );
}