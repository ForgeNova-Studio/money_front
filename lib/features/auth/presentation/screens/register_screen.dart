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
///
/// 사용자가 서비스 이용을 위해 계정을 생성하는 화면입니다.
///
/// **주요 기능 (Key Features):**
/// - 사용자 기본 정보 입력 (닉네임, 성별, 비밀번호 등)
/// - 이메일 인증 프로세스 (`_handleSendVerificationCode`, `_handleVerifyCode`, `_handleEmailNotReceived`)
/// - 입력값 유효성 검사 및 회원가입 요청 (`_handleSignUp`)
/// - 이용약관 및 개인정보 처리방침 동의
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// context.push(RouteNames.register);
/// // or
/// const RegisterScreen();
/// ```
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

/// [RegisterScreen]의 상태 관리 클래스
///
/// 입력 필드 컨트롤러, 포커스 노드, 그리고 회원가입 관련 비즈니스 로직을 연결합니다.
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
    final result =
        await ref.read(registerViewModelProvider.notifier).submitSignup(
              email: _emailController.text,
              nickname: _displayNameController.text,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            );

    if (!mounted) return;
    if (!result.success && result.message != null) {
      context.showErrorToast(result.message!);
      return;
    }
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
    final result = await ref
        .read(registerViewModelProvider.notifier)
        .requestVerificationCode(_emailController.text);

    if (!mounted) return;
    if (!result.success) {
      if (result.message != null) {
        context.showErrorToast(
          result.message!,
          duration: const Duration(seconds: 2),
        );
      }
      return;
    }

    if (!mounted) return;
    context.showToast('인증번호가 이메일로 전송되었습니다.');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
      }
    });
  }

  Future<void> _handleVerifyCode() async {
    final result = await ref
        .read(registerViewModelProvider.notifier)
        .confirmVerificationCode(
          email: _emailController.text,
          code: _verificationCodeController.text,
        );

    if (!mounted) return;
    if (!result.success) {
      if (result.message != null) {
        context.showErrorToast(
          result.message!,
          duration: const Duration(seconds: 2),
        );
      }
      return;
    }

    if (!mounted) return;
    context.showToast('이메일 인증이 완료되었습니다.');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
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
