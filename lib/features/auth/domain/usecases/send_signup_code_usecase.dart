// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 회원가입 인증번호 전송 UseCase
///
/// 회원가입 시 이메일 인증을 위한 인증번호 전송
/// - 이메일 형식 검증
/// - 이메일 중복 체크 (백엔드에서 처리)
/// - 6자리 인증번호를 이메일로 전송 (10분 유효)
class SendSignupCodeUseCase {
  final AuthRepository _repository;

  SendSignupCodeUseCase(this._repository);

  /// 인증번호 전송 실행
  ///
  /// [email] 사용자 이메일
  ///
  /// Throws:
  /// - [ValidationException] 이메일 형식 오류
  /// - [ValidationException] 이미 가입된 이메일 (백엔드에서 반환)
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<void> call(String email) async {
    // 이메일 검증
    _validateEmail(email);

    // Repository 호출
    await _repository.sendSignupCode(email);
  }

  /// 이메일 검증
  void _validateEmail(String email) {
    if (email.isEmpty) {
      throw ValidationException('이메일을 입력해주세요');
    }
    if (!_isValidEmail(email)) {
      throw ValidationException('올바른 이메일 형식이 아닙니다');
    }
  }

  /// 이메일 형식 검증 (RFC 5322 기반 간소화)
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}