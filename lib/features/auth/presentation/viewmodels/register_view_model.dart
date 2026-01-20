// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// states
import 'package:moneyflow/features/auth/presentation/states/register_form_state.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'register_view_model.g.dart';

/// 회원가입 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리
@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  static const String _passwordRuleMessage =
      '비밀번호는 대문자, 소문자, 숫자, 특수문자(@\$!%*?&)를 각각 최소 1개 이상 포함해야 합니다.';
  static const String _passwordMismatchMessage = '비밀번호가 일치하지 않습니다.';

  @override
  RegisterFormState build() {
    return RegisterFormState.initial();
  }

  /// 성별 선택
  void selectGender(Gender gender) {
    state = state.copyWith(selectedGender: gender);
  }

  /// 약관 동의 토글
  void toggleTermsAgreed() {
    state = state.copyWith(isTermsAgreed: !state.isTermsAgreed);
  }

  /// 비밀번호 가시성 토글
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 비밀번호 확인 가시성 토글
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: _passwordValidationError(
        password: password,
        confirmPassword: state.confirmPassword,
      ),
    );
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(
      confirmPassword: confirmPassword,
      passwordError: _passwordValidationError(
        password: state.password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  /// 이메일 인증번호 전송
  Future<void> sendVerificationCode(String email) async {
    try {
      // 이메일 저장
      state = state.copyWith(email: email);

      // AuthViewModel의 sendSignupCode 호출
      await ref.read(authViewModelProvider.notifier).sendSignupCode(email);

      // 성공 시 인증번호 전송 상태 업데이트
      state = state.copyWith(isVerificationCodeSent: true);
    } catch (e) {
      // 에러 발생 시 예외를 다시 던져서 UI에서 처리하도록 함
      rethrow;
    }
  }

  /// 인증번호 확인
  Future<bool> verifyCode({
    required String email,
    required String code,
  }) async {
    // AuthViewModel의 verifySignupCode 호출
    final isVerified = await ref
        .read(authViewModelProvider.notifier)
        .verifySignupCode(email: email, code: code);

    if (isVerified) {
      // 인증 성공 시 상태 업데이트
      state = state.copyWith(
        email: email,
        verificationCode: code,
        isEmailVerified: true,
      );
    }

    return isVerified;
  }

  /// 회원가입 가능 여부 검증 및 에러 메시지 반환
  String? validateForSignup({
    required String password,
    required String confirmPassword,
  }) {
    if (!state.isEmailVerified) {
      return '이메일 인증을 완료해주세요.';
    }

    if (state.selectedGender == null) {
      return '성별을 선택해주세요.';
    }

    // 비밀번호 패턴 검증 (백엔드와 동일한 규칙)
    if (!_isValidPassword(password)) {
      return _passwordRuleMessage;
    }

    if (password != confirmPassword) {
      return _passwordMismatchMessage;
    }

    if (!state.isTermsAgreed) {
      return '약관 및 개인정보 이용동의에 체크해주세요.';
    }

    return null; // 검증 통과
  }

  /// 비밀번호 유효성 검증
  /// 대문자, 소문자, 숫자, 특수문자(@$!%*?&) 각각 최소 1개 이상 포함
  bool _isValidPassword(String password) {
    // 최소 1개의 대문자
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    // 최소 1개의 소문자
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    // 최소 1개의 숫자
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    // 최소 1개의 특수문자 (@$!%*?&)
    final hasSpecialChar = password.contains(RegExp(r'[@$!%*?&]'));

    return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar;
  }

  String? _passwordValidationError({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isEmpty && confirmPassword.isEmpty) {
      return null;
    }

    if (password.isNotEmpty && !_isValidPassword(password)) {
      return _passwordRuleMessage;
    }

    if (confirmPassword.isNotEmpty && password != confirmPassword) {
      return _passwordMismatchMessage;
    }

    return null;
  }

  /// 상태 초기화
  void reset() {
    state = RegisterFormState.initial();
  }
}
