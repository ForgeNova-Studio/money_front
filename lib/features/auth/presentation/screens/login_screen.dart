import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'register_screen.dart';
import '../../../../presentation/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      print('🚀 로그인 시작');
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('✅ 로그인 완료, 인증 상태: ${authProvider.isAuthenticated}');

      if (mounted && authProvider.isAuthenticated) {
        print('🏠 홈 화면으로 이동');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        print('⚠️ 인증되지 않음 또는 mounted가 false');
      }
    } catch (e, stackTrace) {
      print('❌ 로그인 에러: $e');
      print('📍 스택 트레이스: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? '로그인에 실패했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = context.read<AuthProvider>();

    try {
      print('🚀 Google 로그인 시작');
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: '886590665036-4chomeefga43fmilrkdu90ajnhblc2po.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('❌ Google 로그인 취소됨');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google ID Token을 가져올 수 없습니다');
      }

      print('✅ Google ID Token 획득');

      await authProvider.socialLogin(
        provider: 'GOOGLE',
        idToken: idToken,
        nickname: googleUser.displayName ?? 'Google 사용자',
      );

      if (mounted && authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      print('❌ Google 로그인 에러: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google 로그인에 실패했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleNaverLogin() async {
    final authProvider = context.read<AuthProvider>();

    try {
      print('🚀 Naver 로그인 시작');

      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        print('✅ Naver Access Token 획득');

        await authProvider.socialLogin(
          provider: 'NAVER',
          idToken: result.accessToken.accessToken,
          nickname: result.account.name,
        );

        if (mounted && authProvider.isAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        print('❌ Naver 로그인 취소됨');
      }
    } catch (e) {
      print('❌ Naver 로그인 에러: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Naver 로그인에 실패했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // 로고/타이틀
                Text(
                  'MoneyFlow',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '스마트 가계부 앱',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // 이메일 입력
                CustomTextField(
                  label: '이메일',
                  hintText: 'example@email.com',
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // 비밀번호 입력
                CustomTextField(
                  label: '비밀번호',
                  hintText: '8자 이상 입력하세요',
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // 로그인 버튼
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final isLoading = authProvider.status == AuthStatus.loading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('로그인'),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 구분선
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.textSecondary.withOpacity(0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.textSecondary.withOpacity(0.3))),
                  ],
                ),
                const SizedBox(height: 24),

                // 소셜 로그인 버튼
                _buildSocialLoginButton(
                  label: 'Google로 로그인',
                  icon: Icons.login,
                  color: Colors.white,
                  textColor: Colors.black87,
                  onPressed: _handleGoogleLogin,
                ),
                const SizedBox(height: 12),
                _buildSocialLoginButton(
                  label: 'Naver로 로그인 (준비중)',
                  icon: Icons.login,
                  color: Colors.grey,
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Naver 로그인은 준비 중입니다')),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 회원가입 링크
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '계정이 없으신가요? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      children: [
                        TextSpan(
                          text: '회원가입',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 1,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      icon: Icon(icon, size: 24),
      label: Text(label),
    );
  }
}
