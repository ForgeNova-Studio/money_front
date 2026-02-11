// packages
import 'dart:async';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

// core
import 'package:moamoa/core/exceptions/exceptions.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/auth_result.dart';

// repository
import 'package:moamoa/features/auth/domain/repositories/auth_repository.dart';

/// Kakao 로그인 UseCase
///
/// Kakao 소셜 로그인 비즈니스 로직 처리
/// - Kakao Login SDK를 통한 인증
/// - 백엔드 서버로 Access Token 전송
/// - JWT 토큰 수령 및 저장
class KakaoLoginUseCase {
  final AuthRepository _repository;

  KakaoLoginUseCase(this._repository);

  /// Kakao 로그인 실행
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  /// - [UserCancelledException] 사용자가 로그인 취소
  Future<AuthResult> call() async {
    print('[KakaoLoginUseCase] call() 메서드 시작!');

    // 1. 카카오톡 설치 여부 확인 후 로그인 방식 결정
    OAuthToken token;
    try {
      print('[KakaoLoginUseCase] isKakaoTalkInstalled 확인 중...');
      final isInstalled = await isKakaoTalkInstalled();
      
      if (isInstalled) {
        token = await UserApi.instance.loginWithKakaoTalk().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('카카오 로그인 시간 초과');
          },
        );
      } else {
        token = await UserApi.instance.loginWithKakaoAccount().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('카카오 로그인 시간 초과');
          },
        );
      }
    } on KakaoAuthException catch (e) {
      if (e.error == AuthErrorCause.accessDenied) {
        throw UserCancelledException();
      }
      throw UnauthorizedException('카카오 로그인에 실패했습니다: ${e.message}');
    } catch (e) {
      // 🔴 디버그: 어떤 에러가 발생했는지 확인
      print('[KakaoLoginUseCase] catch 에러: $e');
      print('[KakaoLoginUseCase] 에러 타입: ${e.runtimeType}');

      // 사용자 취소 케이스 처리
      if (e.toString().contains('cancelled') ||
          e.toString().contains('CANCELED') ||
          e.toString().contains('user_cancelled')) {
        print('[KakaoLoginUseCase] → UserCancelledException 으로 변환');
        throw UserCancelledException();
      }

      throw NetworkException('카카오 로그인 중 오류가 발생했습니다: $e');
    }

    // 2. Access Token 확인
    final String accessToken = token.accessToken;
    print('[KakaoLoginUseCase] 카카오 토큰 획득 성공, accessToken 길이: ${accessToken.length}');
    if (accessToken.isEmpty) {
      throw UnauthorizedException('카카오 Access Token이 비어있습니다');
    }

    // 3. 사용자 정보 가져오기 (선택적)
    String? email;
    String? nickname;
    try {
      final user = await UserApi.instance.me();
      email = user.kakaoAccount?.email;
      nickname = user.kakaoAccount?.profile?.nickname;
      print('[KakaoLoginUseCase] 사용자 정보: email=$email, nickname=$nickname');
    } catch (e) {
      // 사용자 정보 가져오기 실패해도 로그인은 진행
      print('[KakaoLoginUseCase] 사용자 정보 가져오기 실패 (무시): $e');
    }

    // 4. Repository를 통해 백엔드로 Access Token 전송
    print('[KakaoLoginUseCase] 백엔드 API 호출 시작...');
    try {
      final result = await _repository.loginWithKakao(
        accessToken: accessToken,
        email: email,
        nickname: nickname,
      );
      print('[KakaoLoginUseCase] 백엔드 API 호출 성공!');
      return result;
    } catch (e) {
      print('[KakaoLoginUseCase] 백엔드 API 호출 실패: $e');
      rethrow;
    }
  }
}
