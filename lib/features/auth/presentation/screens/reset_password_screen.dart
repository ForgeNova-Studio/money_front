// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

// widgets
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/find_password_view_model.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 이전 화면의 SnackBar 제거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('비밀번호를 입력해주세요.'),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('비밀번호가 일치하지 않습니다.'),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    try {
      // FindPasswordViewModel에서 email 가져오기
      final email = ref.read(findPasswordViewModelProvider).email;

      // AuthViewModel의 resetPassword 메서드 호출
      await ref.read(authViewModelProvider.notifier).resetPassword(
            email: email,
            newPassword: _passwordController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('비밀번호가 성공적으로 변경되었습니다.'),
              backgroundColor: context.appColors.success,
            ),
          );

        // 로그인 화면으로 이동 (모든 스택 제거하고 로그인 화면으로)
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // try-catch는 UnhandledException 방지용
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 상태 구독
    final authState = ref.watch(authViewModelProvider);

    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
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
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: context.appColors.backgroundWhite,
          appBar: AppBar(
            backgroundColor: context.appColors.backgroundWhite,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  '비밀번호 재설정',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '새로운 비밀번호를 입력해주세요.',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.appColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _passwordController,
                  hintText: '새 비밀번호',
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: '새 비밀번호 확인',
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        authState.isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.primaryPink,
                      foregroundColor: context.appColors.textWhite,
                      disabledBackgroundColor: context.appColors.primaryPinkPale,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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
                            '비밀번호 변경',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
