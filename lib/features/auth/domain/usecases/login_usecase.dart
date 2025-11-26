// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 로그인 UseCase
///
/// 사용자 로그인 비즈니스 로직 처리
/// - 입력값 검증
/// - Repository 호출
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// 로그인 실행
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [ValidationException] 입력값 검증 오류
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    // 입력값 검증 (Domain Layer의 비즈니스 규칙)
    _validateInput(email: email, password: password);

    // Repository 호출 - 예외는 Repository_impl에서 자동으로 전파됨
    return await _repository.login(email: email, password: password);
  }

  /// 입력값 검증
  void _validateInput({
    required String email,
    required String password,
  }) {
    if (email.isEmpty) {
      throw ValidationException('이메일을 입력해주세요');
    }

    if (!_isValidEmail(email)) {
      throw ValidationException('올바른 이메일 형식이 아닙니다');
    }

    if (password.isEmpty) {
      throw ValidationException('비밀번호를 입력해주세요');
    }

    if (password.length < 8) {
      throw ValidationException('비밀번호는 8자 이상이어야 합니다');
    }
  }

  /// 이메일 형식 검증
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
