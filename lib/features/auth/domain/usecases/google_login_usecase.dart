// packages
import 'package:google_sign_in/google_sign_in.dart';

// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';

// repository
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// Google 로그인 UseCase
///
/// Google 소셜 로그인 비즈니스 로직 처리
/// - Google Sign In SDK를 통한 인증
/// - 백엔드 서버로 ID Token 전송
/// - JWT 토큰 수령 및 저장
class GoogleLoginUseCase {
  final AuthRepository _repository;

  GoogleLoginUseCase(this._repository);

  /// Google 로그인 실행
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResult> call() async {
    // 1. Google Sign In 인스턴스 가져오기 (v7.x 싱글톤 패턴)
    final googleSignIn = GoogleSignIn.instance;

    // 2. 초기화 (필요한 경우 - clientId는 android/ios 설정 파일에서 자동으로 읽음)
    // await googleSignIn.initialize(); // v7에서는 initialize가 필요 없을 수 있음, 확인 필요
    // 하지만 signIn() 호출 시 자동으로 초기화됨.

    // 3. Google Sign In으로 사용자 인증
    GoogleSignInAccount? googleUser;

    if (googleSignIn.supportsAuthenticate()) {
      // authenticate() 메서드 지원하는 플랫폼
      googleUser = await googleSignIn.authenticate();
    }

    if (googleUser == null) {
      throw UnauthorizedException('Google 로그인이 취소되었습니다');
    }

    // 4. ID Token 가져오기
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw UnauthorizedException('Google ID Token을 가져올 수 없습니다');
    }

    // 5. Repository를 통해 백엔드로 ID Token 전송
    return await _repository.loginWithGoogle(
      idToken: idToken,
      nickname: googleUser.displayName,
    );
  }
}
