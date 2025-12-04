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

  /// 이메일 인증번호 전송
  Future<void> sendVerificationCode(String email) async {
    // 이메일 저장
    state = state.copyWith(email: email);

    // AuthViewModel의 sendSignupCode 호출
    await ref.read(authViewModelProvider.notifier).sendSignupCode(email);

    // 성공 시 인증번호 전송 상태 업데이트
    state = state.copyWith(isVerificationCodeSent: true);
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

    if (password != confirmPassword) {
      return '비밀번호가 일치하지 않습니다.';
    }

    if (!state.isTermsAgreed) {
      return '약관 및 개인정보 이용동의에 체크해주세요.';
    }

    return null; // 검증 통과
  }

  /// 상태 초기화
  void reset() {
    state = RegisterFormState.initial();
  }
}
