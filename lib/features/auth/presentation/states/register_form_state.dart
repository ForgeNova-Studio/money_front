// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';

part 'register_form_state.freezed.dart';

/// 회원가입 폼 상태 관리 클래스
///
/// 회원가입 화면의 모든 입력 필드 데이터와 UI 상태를 관리합니다.
///
/// **주요 속성 (Properties):**
/// - `displayName`: 닉네임
/// - `email`: 이메일
/// - `password`, `confirmPassword`: 비밀번호 및 확인
/// - `selectedGender`: 선택된 성별
/// - `isTermsAgreed`: 약관 동의 여부
/// - `isEmailVerified`: 이메일 인증 완료 여부
///
/// **주요 기능 (Key Features):**
/// - 입력 필드 데이터 관리
/// - 비밀번호 일치 여부 확인 (`isPasswordMatch`)
/// - 전체 폼 유효성 검사 (`isFormValid`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final formState = ref.watch(registerViewModelProvider);
/// ElevatedButton(
///   onPressed: formState.isFormValid ? _submit : null,
///   child: Text('가입하기'),
/// )
/// ```
@freezed
sealed class RegisterFormState with _$RegisterFormState {
  const RegisterFormState._();

  const factory RegisterFormState({
    @Default('') String displayName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String verificationCode,
    Gender? selectedGender,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
    @Default(false) bool isTermsAgreed,
    @Default(false) bool isVerificationCodeSent,
    @Default(false) bool isEmailVerified,
    String? emailError,
    String? passwordError,
  }) = _RegisterFormState;

  // 초기 상태
  factory RegisterFormState.initial() => const RegisterFormState();

  // 유효성 검사 Getters
  bool get isPasswordMatch =>
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword;

  bool get isFormValid =>
      displayName.isNotEmpty &&
      isEmailVerified &&
      selectedGender != null &&
      isPasswordMatch &&
      isTermsAgreed;

  bool get canSubmitForm => isFormValid;

  bool get canRequestVerificationCode => email.isNotEmpty && !isEmailVerified;
}
