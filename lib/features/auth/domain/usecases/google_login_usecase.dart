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
    // TODO: Google Sign In SDK 연동
    // 1. Google Sign In으로 사용자 인증
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // if (googleUser == null) {
    //   throw UnauthorizedException('Google 로그인이 취소되었습니다');
    // }
    //
    // 2. ID Token 가져오기
    // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    // final String? idToken = googleAuth.idToken;
    //
    // if (idToken == null) {
    //   throw UnauthorizedException('Google ID Token을 가져올 수 없습니다');
    // }
    //
    // 3. Repository를 통해 백엔드로 ID Token 전송
    // return await _repository.loginWithGoogle(idToken: idToken);

    // Mock: 실제 구현은 위 주석 참고
    return await _repository.loginWithGoogle(idToken: 'mock_google_id_token');
  }
}
