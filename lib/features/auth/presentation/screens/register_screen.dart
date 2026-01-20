// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/router/route_names.dart';

// widgets
import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/register_view_model.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

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
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _verificationCodeFocusNode.dispose();
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: context.appColors.warning,
          ),
        );
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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('이용약관 상세 페이지로 이동 구현 예정')),
      );
  }

  void _handlePrivacyClick() {
    // TODO: 개인정보 이용동의 페이지 이동
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('개인정보 이용동의 상세 페이지로 이동 구현 예정')),
      );
  }

  Future<void> _handleSendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('이메일을 입력해주세요.'),
            backgroundColor: context.appColors.warning,
          ),
        );
      return;
    }

    try {
      // RegisterViewModel의 sendVerificationCode 메서드 호출
      await ref
          .read(registerViewModelProvider.notifier)
          .sendVerificationCode(_emailController.text);

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('인증번호가 전송되었습니다.')),
          );
        // 인증번호 전송 후 포커싱 처리
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
          }
        });
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // 174행에서 ref.listen으로 에러를 감지하여 처리
      // try-catch는 UnhandledException 방지용
    }
  }

  Future<void> _handleVerifyCode() async {
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('인증번호를 입력해주세요.'),
            backgroundColor: context.appColors.warning,
          ),
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
          );
      }
    } catch (e) {
      // 에러는 ref.listen에서 처리되므로 여기서는 따로 처리하지않음
      // 174행에서 ref.listen으로 에러를 감지하여 처리
      // try-catch는 UnhandledException 방지용
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ViewModel 상태 구독
    final authState = ref.watch(authViewModelProvider);
    final formState = ref.watch(registerViewModelProvider);

    // ViewModel 상태 변화 감지
    ref.listen(authViewModelProvider, (previous, next) {
      // 회원가입 성공 시
      if (next.isAuthenticated && next.user != null) {
        // 홈 화면으로 이동 (뒤로가기 불가)
        context.go(RouteNames.home);
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
                _buildRegisterTitle(),

                const SizedBox(height: 40),

                // 닉네임(Display Name) 입력 필드
                CustomTextField(
                  controller: _displayNameController,
                  hintText: '닉네임',
                  icon: Icons.person_outline,
                ),

                SizedBox(height: 16),

                // 성별 선택
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(registerViewModelProvider.notifier)
                              .selectGender(Gender.male);
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: formState.selectedGender == Gender.male
                                ? context.appColors.primary.withValues(alpha: 0.1)
                                : context.appColors.gray100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: formState.selectedGender == Gender.male
                                  ? context.appColors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '남성',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: formState.selectedGender == Gender.male
                                  ? context.appColors.primary
                                  : context.appColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(registerViewModelProvider.notifier)
                              .selectGender(Gender.female);
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: formState.selectedGender == Gender.female
                                ? context.appColors.primary.withValues(alpha: 0.1)
                                : context.appColors.gray100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: formState.selectedGender == Gender.female
                                  ? context.appColors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '여성',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: formState.selectedGender == Gender.female
                                  ? context.appColors.primary
                                  : context.appColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 이메일 입력 필드
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _emailController,
                        hintText: '이메일',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !formState.isEmailVerified,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: formState.isEmailVerified
                            ? null
                            : () {
                                _handleSendVerificationCode();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          disabledBackgroundColor: colorScheme.surfaceVariant,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          formState.isEmailVerified ? '인증완료' : '인증요청',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (formState.isVerificationCodeSent &&
                    !formState.isEmailVerified) ...[
                  SizedBox(height: 12),
                  // 인증번호 입력 필드
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _verificationCodeController,
                          focusNode: _verificationCodeFocusNode,
                          hintText: '인증번호',
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleVerifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.inverseSurface,
                            foregroundColor: colorScheme.onInverseSurface,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            '인증확인',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // 인증번호 유효 시간 안내
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      '※ 인증번호는 10분간 유효합니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.appColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                CustomTextField(
                  controller: _passwordController,
                  hintText: '비밀번호',
                  isPassword: true,
                  isPasswordVisible: formState.isPasswordVisible,
                  onVisibilityToggle: () {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .togglePasswordVisibility();
                  },
                ),

                const SizedBox(height: 16),

                // 비밀번호 확인 입력 필드
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: '비밀번호 확인',
                  isPassword: true,
                  isPasswordVisible: formState.isConfirmPasswordVisible,
                  onVisibilityToggle: () {
                    ref
                        .read(registerViewModelProvider.notifier)
                        .toggleConfirmPasswordVisibility();
                  },
                ),

                SizedBox(height: 24),

                // 약관 동의 체크박스
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: formState.isTermsAgreed,
                        onChanged: (value) {
                          ref
                              .read(registerViewModelProvider.notifier)
                              .toggleTermsAgreed();
                        },
                        activeColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.appColors.textSecondary,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: _handleTermsClick,
                              child: Text(
                                '이용약관',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.appColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            ' 및 ',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.appColors.textSecondary,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.appColors.textSecondary,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: _handlePrivacyClick,
                              child: Text(
                                '개인정보 이용동의',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.appColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '에 확인하고 동의합니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // 회원가입 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor: colorScheme.primaryContainer,
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
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Text(
                            '회원가입',
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
    );
  }

  Widget _buildRegisterTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '회원가입',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: context.appColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '새로운 계정을 생성합니다.',
          style: TextStyle(
            fontSize: 16,
            color: context.appColors.textSecondary,
            height: 1.5,
          ),
        )
      ],
    );
  }
}
