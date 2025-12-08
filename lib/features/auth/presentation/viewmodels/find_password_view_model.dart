// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// states
import 'package:moneyflow/features/auth/presentation/states/find_password_form_state.dart';

// viewmodels
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'find_password_view_model.g.dart';

/// 비밀번호 찾기 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리
@riverpod
class FindPasswordViewModel extends _$FindPasswordViewModel {
  @override
  FindPasswordFormState build() {
    return FindPasswordFormState.initial();
  }

  /// 이메일 인증번호 전송
  Future<void> sendVerificationCode(String email) async {
    try {
      // 이메일 저장
      state = state.copyWith(email: email);

      // AuthViewModel의 sendPasswordResetCode 호출
      await ref
          .read(authViewModelProvider.notifier)
          .sendPasswordResetCode(email);

      // 성공 시 인증번호 전송 상태 업데이트
      state = state.copyWith(isVerificationCodeSent: true);
    } catch (e) {
      // 에러 발생 시 예외를 다시 던져서 UI에서 처리하도록 함
      rethrow;
    }
  }

  // 이메일 인증번호 확인
  Future<bool> verifyCode({
    required String email,
    required String code,
  }) async {
    // AuthViewModel의 verifyFindPasswordCode 호출
    final isVerified = await ref
        .read(authViewModelProvider.notifier)
        .verifyFindPasswordCode(email: email, code: code);

    if (isVerified) {
      // 인증 성공 시 상태 업데이트
      state = state.copyWith(
          email: email, verificationCode: code, isEmailVerified: true);
    }

    return isVerified;
  }

  /// 상태 초기화
  void reset() {
    state = FindPasswordFormState.initial();
  }
}
