// packages
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
/// - 백엔드 서버로 Identity Token 전송
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
    try {
      // 1. Apple Sign In으로 사용자 인증
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 2. Identity Token 가져오기 (authorizationCode 대신 identityToken 사용)
      final String? identityToken = credential.identityToken;

      if (identityToken == null) {
        throw UnauthorizedException('Apple Identity Token을 가져올 수 없습니다');
      }

      // 3. 닉네임 생성 (Apple은 이름 제공 안 할 수도 있음)
      String nickname = 'Apple Auth User';
      if (credential.givenName != null && credential.familyName != null) {
        nickname = '${credential.familyName}${credential.givenName}';
      } else if (credential.givenName != null) {
        nickname = credential.givenName!;
      }

      // 4. Repository를 통해 백엔드로 Identity Token 전송
      return await _repository.loginWithApple(
        authorizationCode:
            identityToken, // identityToken을 authorizationCode로 전달
        nickname: nickname,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      // Apple 로그인 취소 또는 에러 처리
      if (e.code == AuthorizationErrorCode.canceled) {
        throw UnauthorizedException('Apple 로그인이 취소되었습니다');
      }
      throw UnauthorizedException('Apple 로그인 실패: ${e.message}');
    }
  }
}
