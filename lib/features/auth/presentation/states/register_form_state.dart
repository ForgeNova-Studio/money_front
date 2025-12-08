// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

part 'register_form_state.freezed.dart';

/// 회원가입 폼 상태 관리
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
