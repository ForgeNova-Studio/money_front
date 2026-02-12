// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// states
import 'package:moamoa/features/auth/presentation/states/find_password_form_state.dart';

// viewmodels
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'find_password_view_model.g.dart';

/// 비밀번호 찾기 ViewModel
///
/// 비밀번호 재설정을 위한 이메일 인증 프로세스를 관리합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일 주소 입력 및 관리
/// - 인증번호 전송 요청 (`sendVerificationCode`)
/// - 인증번호 검증 요청 (`verifyCode`)
/// - 상태 초기화 (`reset`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(findPasswordViewModelProvider.notifier).sendVerificationCode(email);
/// ```
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
    required String code,
  }) async {
    // AuthViewModel의 verifyFindPasswordCode 호출
    final isVerified = await ref
        .read(authViewModelProvider.notifier)
        .verifyFindPasswordCode(email: state.email, code: code);

    if (isVerified) {
      // 인증 성공 시 상태 업데이트
      state = state.copyWith(verificationCode: code, isEmailVerified: true);
    }

    return isVerified;
  }

  /// 상태 초기화
  void reset() {
    state = FindPasswordFormState.initial();
  }
}
