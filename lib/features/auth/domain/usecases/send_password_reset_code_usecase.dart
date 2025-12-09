// core
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/core/validators/input_validator.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 비밀번호 재설정 인증번호 전송 UseCase
///
/// 비밀번호 재설정 시 이메일 인증을 위한 인증번호 전송
/// - 이메일 형식 검증
/// - 가입된 이메일 체크 (백엔드에서 처리)
/// - 6자리 인증번호를 이메일로 전송 (10분 유효)
/// - 소셜 로그인 사용자는 사용 불가
class SendPasswordResetCodeUseCase {
  final AuthRepository _repository;

  SendPasswordResetCodeUseCase(this._repository);

  /// 인증번호 전송 실행
  ///
  /// [email] 사용자 이메일
  ///
  /// Throws:
  /// - [ValidationException] 이메일 형식 오류
  /// - [ValidationException] 가입되지 않은 이메일 또는 소셜 로그인 사용자 (백엔드에서 반환)
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<void> call(String email) async {
    // 이메일 검증
    _validateEmail(email);

    // Repository 호출
    await _repository.sendPasswordResetCode(email);
  }

  /// 이메일 검증
  void _validateEmail(String email) {
    final errorMessage = InputValidator.getEmailErrorMessage(email);
    if (errorMessage.isNotEmpty) {
      throw ValidationException(errorMessage);
    }
  }
}
