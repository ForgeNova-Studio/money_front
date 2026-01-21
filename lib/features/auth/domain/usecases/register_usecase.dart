// core
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/core/validators/input_validator.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/auth_result.dart';
import 'package:moamoa/features/auth/domain/entities/gender.dart';

// repository
import 'package:moamoa/features/auth/domain/repositories/auth_repository.dart';

/// 회원가입 UseCase
///
/// 사용자 회원가입 비즈니스 로직 처리
/// - 입력값 검증
/// - 비밀번호 확인 일치 검증
/// - Repository 호출
///
/// 참고: 이메일 중복 확인은 send-signup-code API에서 처리됨
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// 회원가입 실행
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  /// [confirmPassword] 비밀번호 확인
  /// [nickname] 사용자 닉네임
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [ValidationException] 입력값 검증 오류 (비밀번호 불일치 포함)
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<AuthResult> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String nickname,
    required Gender gender,
  }) async {
    // 입력값 검증
    _validateInput(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      nickname: nickname,
    );

    // Repository 호출
    return await _repository.register(
      email: email,
      password: password,
      nickname: nickname,
      gender: gender,
    );
  }

  /// 입력값 검증
  void _validateInput({
    required String email,
    required String password,
    required String confirmPassword,
    required String nickname,
  }) {
    // 이메일 검증
    final emailError = InputValidator.getEmailErrorMessage(email);
    if (emailError.isNotEmpty) {
      throw ValidationException(emailError);
    }

    // 비밀번호 검증 (대문자 필수)
    final passwordError = InputValidator.getPasswordErrorMessage(
      password,
      requireUppercase: true,
      requireSpecialChar: true,
    );
    if (passwordError.isNotEmpty) {
      throw ValidationException(passwordError);
    }

    // 비밀번호 확인 검증
    if (confirmPassword.isEmpty) {
      throw ValidationException('비밀번호 확인을 입력해주세요');
    }
    if (password != confirmPassword) {
      throw ValidationException('비밀번호가 일치하지 않습니다');
    }

    // 닉네임 검증
    final nicknameError = InputValidator.getNicknameErrorMessage(nickname);
    if (nicknameError.isNotEmpty) {
      throw ValidationException(nicknameError);
    }
  }
}
