// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// Apple 로그인 UseCase
///
/// Apple 소셜 로그인 비즈니스 로직 처리
/// - Sign in with Apple SDK를 통한 인증
/// - 백엔드 서버로 Authorization Code 전송
/// - JWT 토큰 수령 및 저장
class AppleLoginUseCase {
  final AuthRepository _repository;

  AppleLoginUseCase(this._repository);

  /// Apple 로그인 실행
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResult> call() async {
    // TODO: Sign in with Apple SDK 연동
    // 1. Apple Sign In으로 사용자 인증
    // final credential = await SignInWithApple.getAppleIDCredential(
    //   scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ],
    // );
    //
    // 2. Authorization Code 가져오기
    // final String? authorizationCode = credential.authorizationCode;
    //
    // if (authorizationCode == null) {
    //   throw UnauthorizedException('Apple Authorization Code를 가져올 수 없습니다');
    // }
    //
    // 3. Repository를 통해 백엔드로 Authorization Code 전송
    // return await _repository.loginWithApple(
    //   authorizationCode: authorizationCode,
    //   identityToken: credential.identityToken,
    // );

    // Mock: 실제 구현은 위 주석 참고
    return await _repository.loginWithApple(
      authorizationCode: 'mock_apple_authorization_code',
    );
  }
}
