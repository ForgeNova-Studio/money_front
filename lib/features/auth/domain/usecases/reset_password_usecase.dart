// core
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/core/validators/input_validator.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 비밀번호 재설정 UseCase
///
/// 인증번호를 검증하고 새로운 비밀번호로 재설정
/// - 입력값 검증
/// - 인증번호 검증 (백엔드에서 처리)
/// - 비밀번호 재설정
/// - 소셜 로그인 사용자는 사용 불가
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  /// 비밀번호 재설정 실행
  ///
  /// [email] 사용자 이메일
  /// [newPassword] 새로운 비밀번호
  ///
  /// Throws:
  /// - [ValidationException] 입력값 검증 오류
  /// - [ValidationException] 소셜 로그인 사용자 (백엔드에서 반환)
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<void> call({
    required String email,
    required String newPassword,
  }) async {
    // 입력값 검증
    _validateInput(
      email: email,
      newPassword: newPassword,
    );

    // Repository 호출
    await _repository.resetPassword(
      email: email,
      newPassword: newPassword,
    );
  }

  /// 입력값 검증
  void _validateInput({
    required String email,
    required String newPassword,
  }) {
    // 이메일 검증
    final emailError = InputValidator.getEmailErrorMessage(email);
    if (emailError.isNotEmpty) {
      throw ValidationException(emailError);
    }

    // 비밀번호 검증 (대문자 필수)
    final passwordError = InputValidator.getPasswordErrorMessage(
      newPassword,
      requireUppercase: true,
    );
    if (passwordError.isNotEmpty) {
      throw ValidationException(passwordError);
    }
  }
}
