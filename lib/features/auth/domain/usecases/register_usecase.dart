import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 회원가입 UseCase
///
/// 사용자 회원가입 비즈니스 로직 처리
/// - 입력값 검증
/// - 이메일 중복 확인
/// - Repository 호출
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// 회원가입 실행
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  /// [nickname] 사용자 닉네임
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [ValidationException] 입력값 검증 오류
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<AuthResult> call({
    required String email,
    required String password,
    required String nickname,
  }) async {
    // 입력값 검증
    _validateInput(
      email: email,
      password: password,
      nickname: nickname,
    );

    // 이메일 중복 확인
    final isDuplicate = await _repository.checkEmailDuplicate(email);
    if (isDuplicate) {
      throw ValidationException('이미 사용 중인 이메일입니다');
    }

    // Repository 호출
    return await _repository.register(
      email: email,
      password: password,
      nickname: nickname,
    );
  }

  /// 입력값 검증
  void _validateInput({
    required String email,
    required String password,
    required String nickname,
  }) {
    // 이메일 검증
    if (email.isEmpty) {
      throw ValidationException('이메일을 입력해주세요');
    }
    if (!_isValidEmail(email)) {
      throw ValidationException('올바른 이메일 형식이 아닙니다');
    }

    // 비밀번호 검증
    if (password.isEmpty) {
      throw ValidationException('비밀번호를 입력해주세요');
    }
    if (password.length < 8) {
      throw ValidationException('비밀번호는 8자 이상이어야 합니다');
    }
    if (!_hasUpperCase(password)) {
      throw ValidationException('비밀번호에 대문자를 포함해주세요');
    }
    if (!_hasLowerCase(password)) {
      throw ValidationException('비밀번호에 소문자를 포함해주세요');
    }
    if (!_hasDigit(password)) {
      throw ValidationException('비밀번호에 숫자를 포함해주세요');
    }

    // 닉네임 검증
    if (nickname.isEmpty) {
      throw ValidationException('닉네임을 입력해주세요');
    }
    if (nickname.length < 2) {
      throw ValidationException('닉네임은 2자 이상이어야 합니다');
    }
    if (nickname.length > 20) {
      throw ValidationException('닉네임은 20자 이하여야 합니다');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _hasUpperCase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  bool _hasLowerCase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  bool _hasDigit(String password) {
    return RegExp(r'\d').hasMatch(password);
  }
}
