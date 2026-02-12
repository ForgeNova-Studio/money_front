// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core

import 'package:moamoa/router/route_names.dart';

// widgets
import 'package:moamoa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:moamoa/features/auth/presentation/widgets/register/email_verification_row.dart';
import 'package:moamoa/features/auth/presentation/widgets/register/gender_selector_row.dart';
import 'package:moamoa/features/auth/presentation/widgets/password_rule_checklist.dart';
import 'package:moamoa/features/auth/presentation/widgets/register/register_submit_button.dart';
import 'package:moamoa/features/auth/presentation/widgets/register/register_title.dart';
import 'package:moamoa/features/auth/presentation/widgets/register/terms_agreement_row.dart';
import 'package:moamoa/features/auth/presentation/widgets/register/verification_code_section.dart';

// viewmodels
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/register_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

/// 회원가입 화면
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _verificationCodeFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 이전 화면의 SnackBar 제거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.hideToast();
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _verificationCodeFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // ViewModel에서 유효성 검사
    final errorMessage =
        ref.read(registerViewModelProvider.notifier).validateForSignup(
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            );

    if (errorMessage != null) {
      context.showErrorToast(errorMessage);
      return;
    }

    // AuthViewModel의 register 메서드 호출
    try {
      await ref.read(authViewModelProvider.notifier).register(
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            nickname: _displayNameController.text,
            gender: ref.read(registerViewModelProvider).selectedGender!,
          );
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // 174행에서 ref.listen으로 에러를 감지하여 처리
      // try-catch는 UnhandledException 방지용
    }

    // 회원가입 성공 시 홈 화면으로 이동
    // (ref.listen에서 처리됨)
  }

  void _handleTermsClick() {
    // TODO: 이용약관 페이지 이동
    context.showToast('이용약관 상세 페이지로 이동 구현 예정');
  }

  void _handlePrivacyClick() {
    // TODO: 개인정보 이용동의 페이지 이동
    context.showToast('개인정보 이용동의 상세 페이지로 이동 구현 예정');
  }

  Future<void> _handleSendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      context.showErrorToast(
        '이메일을 입력해주세요.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // RegisterViewModel의 sendVerificationCode 메서드 호출
      await ref
          .read(registerViewModelProvider.notifier)
          .sendVerificationCode(_emailController.text);

      // 성공 여부 확인 (에러가 있으면 isVerificationCodeSent가 false)
      final formState = ref.read(registerViewModelProvider);
      if (mounted && formState.isVerificationCodeSent) {
        context.showToast('인증번호가 이메일로 전송되었습니다.');
        // 인증번호 전송 후 포커싱 처리
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
          }
        });
      }
      // 에러가 있으면 ref.listen에서 에러 메시지가 표시됨
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // ref.listen(authViewModelProvider)에서 에러를 감지하여 처리
      // try-catch는 UnhandledException 방지용
    }
  }

  Future<void> _handleVerifyCode() async {
    if (_verificationCodeController.text.isEmpty) {
      context.showErrorToast(
        '인증번호를 입력해주세요.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // RegisterViewModel의 verifyCode 메서드 호출
    try {
      final isVerified =
          await ref.read(registerViewModelProvider.notifier).verifyCode(
                email: _emailController.text,
                code: _verificationCodeController.text,
              );

      if (mounted && isVerified) {
        context.showToast('이메일 인증이 완료되었습니다.');
        // 인증 완료 후 포커싱 처리
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          }
        });
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // 174행에서 ref.listen으로 에러를 감지하여 처리
      // try-catch는 UnhandledException 방지용
    }
  }

  void _handleEmailNotReceived() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('메일이 오지 않나요?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('다음 사항을 확인해주세요:'),
            const SizedBox(height: 12),
            _buildCheckItem('스팸 메일함을 확인해주세요.'),
            const SizedBox(height: 8),
            _buildCheckItem('입력하신 이메일 주소가 정확한지 확인해주세요.'),
            const SizedBox(height: 24),
            const Text('여전히 메일이 오지 않는다면 재전송을 시도해주세요.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(text)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ViewModel 상태 구독
    final authState = ref.watch(authViewModelProvider);
    final formState = ref.watch(registerViewModelProvider);
    final isPasswordMismatch = formState.passwordError == '비밀번호가 일치하지 않습니다.';

    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 회원가입 성공 시
      if (next.isAuthenticated && next.user != null) {
        // 홈 화면으로 이동 (뒤로가기 불가)
        context.go(RouteNames.home);
      }

      // 에러 발생 시
      if (next.errorMessage != null && !next.isLoading) {
        context.showErrorToast(next.errorMessage!);
        // 에러 메시지 표시 후 초기화
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // 타이틀
                const RegisterTitle(),

                const SizedBox(height: 40),

                // 닉네임(Display Name) 입력 필드
                CustomTextField(
                  controller: _displayNameController,
                  hintText: '닉네임',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                // 성별 선택
                GenderSelectorRow(
                  selectedGender: formState.selectedGender,
                  onSelected: (gender) {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .selectGender(gender);
                  },
                ),

                const SizedBox(height: 16),

                // 이메일 입력 필드
                EmailVerificationRow(
                  controller: _emailController,
                  isEmailVerified: formState.isEmailVerified,
                  onRequest: _handleSendVerificationCode,
                ),

                if (formState.isVerificationCodeSent &&
                    !formState.isEmailVerified) ...[
                  const SizedBox(height: 12),
                  VerificationCodeSection(
                    controller: _verificationCodeController,
                    focusNode: _verificationCodeFocusNode,
                    onVerify: _handleVerifyCode,
                    onEmailNotReceived: _handleEmailNotReceived,
                  ),
                ],

                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                CustomTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  hintText: '비밀번호',
                  isPassword: true,
                  isPasswordVisible: formState.isPasswordVisible,
                  onChanged: (value) {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .updatePassword(value);
                  },
                  onVisibilityToggle: () {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .togglePasswordVisibility();
                  },
                ),

                const SizedBox(height: 8),
                PasswordRuleChecklist(
                  password: _passwordController.text,
                ),

                const SizedBox(height: 16),

                // 비밀번호 확인 입력 필드
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: '비밀번호 확인',
                  isPassword: true,
                  isPasswordVisible: formState.isConfirmPasswordVisible,
                  errorText:
                      isPasswordMismatch ? formState.passwordError : null,
                  onChanged: (value) {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .updateConfirmPassword(value);
                  },
                  onVisibilityToggle: () {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .toggleConfirmPasswordVisibility();
                  },
                ),

                const SizedBox(height: 24),

                // 약관 동의 체크박스
                TermsAgreementRow(
                  isTermsAgreed: formState.isTermsAgreed,
                  onToggle: () {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .toggleTermsAgreed();
                  },
                  onTermsTap: _handleTermsClick,
                  onPrivacyTap: _handlePrivacyClick,
                ),

                const SizedBox(height: 24),

                // 회원가입 버튼
                RegisterSubmitButton(
                  isLoading: authState.isLoading,
                  onPressed: _handleSignUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
