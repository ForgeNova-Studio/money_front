// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_password_form_state.freezed.dart';

/// 비밀번호 찾기 폼 상태 관리
@freezed
sealed class FindPasswordFormState with _$FindPasswordFormState {
  const FindPasswordFormState._();

  const factory FindPasswordFormState({
    @Default('') String email,
    @Default('') String verificationCode,
    @Default(false) bool isVerificationCodeSent,
    @Default(false) bool isEmailVerified,
    String? emailError,
  }) = _FindPasswordFormState;

  // 초기 상태
  factory FindPasswordFormState.initial() => const FindPasswordFormState();

  // 유효성 검사 Getters
  bool get canRequestVerificationCode => email.isNotEmpty && !isEmailVerified;
  bool get canContinue => email.isNotEmpty && isEmailVerified;
}
