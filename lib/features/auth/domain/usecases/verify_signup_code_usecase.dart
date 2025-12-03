// core
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/core/validators/input_validator.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 회원가입 인증번호 검증 UseCase
///
/// 이메일로 전송된 인증번호를 검증
/// - 인증번호 형식 검증 (6자리 숫자)
/// - Repository를 통한 백엔드 검증
class VerifySignupCodeUseCase {
  final AuthRepository _repository;

  VerifySignupCodeUseCase(this._repository);

  /// 인증번호 검증 실행
  ///
  /// [email] 사용자 이메일
  /// [code] 6자리 인증번호
  ///
  /// Returns: true (검증 성공), false (검증 실패)
  ///
  /// Throws:
  /// - [ValidationException] 인증번호 형식 오류
  /// - [ValidationException] 인증번호 불일치 (백엔드에서 반환)
  /// - [ValidationException] 인증번호 만료 (백엔드에서 반환)
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<bool> call({
    required String email,
    required String code,
  }) async {
    // 입력값 검증
    _validateInput(email: email, code: code);

    // Repository 호출
    return await _repository.verifySignupCode(email, code);
  }

  /// 입력값 검증
  void _validateInput({
    required String email,
    required String code,
  }) {
    // 이메일 검증
    final emailError = InputValidator.getEmailErrorMessage(email);
    if (emailError.isNotEmpty) {
      throw ValidationException(emailError);
    }

    // 인증번호 검증
    final codeError = InputValidator.getVerificationCodeErrorMessage(code);
    if (codeError.isNotEmpty) {
      throw ValidationException(codeError);
    }
  }
}
