// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_password_form_state.freezed.dart';

/// 비밀번호 찾기(이메일 인증) 폼 상태 관리 클래스
///
/// 비밀번호 찾기 화면의 UI 상태와 데이터를 관리합니다.
///
/// **주요 속성 (Properties):**
/// - `email`: 입력된 이메일 주소
/// - `verificationCode`: 입력된 인증번호
/// - `isVerificationCodeSent`: 인증번호 전송 여부
/// - `isEmailVerified`: 이메일 인증 완료 여부
/// - `emailError`: 이메일 유효성 검사 에러 메시지
///
/// **주요 기능 (Key Features):**
/// - 폼 데이터 유지 및 업데이트
/// - 유효성 검사 상태 제공 (`canRequestVerificationCode`, `canContinue`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final formState = ref.watch(findPasswordViewModelProvider);
/// if (formState.canContinue) {
///   // 다음 단계 진행
/// }
/// ```
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
