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
    print('[KakaoLoginUseCase] 카카오 로그인 시작');

    // 1. 카카오톡 설치 여부 확인 후 로그인 방식 결정
    OAuthToken token;
    try {
      print('[KakaoLoginUseCase] 카카오톡 설치 여부 확인');
      final isInstalled = await isKakaoTalkInstalled();
      
      if (isInstalled) {
        print('[KakaoLoginUseCase] 카카오톡으로 로그인 시도');
        token = await UserApi.instance.loginWithKakaoTalk().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            print('[KakaoLoginUseCase] 타임아웃! 카카오톡 로그인이 30초 내에 완료되지 않았습니다.');
            throw TimeoutException('카카오 로그인 시간 초과');
          },
        );
      } else {
        print('[KakaoLoginUseCase] 카카오 계정으로 로그인 시도');
        token = await UserApi.instance.loginWithKakaoAccount().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            print('[KakaoLoginUseCase] 타임아웃! 카카오 계정 로그인이 30초 내에 완료되지 않았습니다.');
            throw TimeoutException('카카오 로그인 시간 초과');
          },
        );
      }
      
      print('[KakaoLoginUseCase] 카카오 로그인 완료: accessToken=${token.accessToken.substring(0, 10)}...');
    } on KakaoAuthException catch (e) {
      print('[KakaoLoginUseCase] 카카오 인증 에러: ${e.error}');
      if (e.error == AuthErrorCause.accessDenied) {
        throw UserCancelledException();
      }
      throw UnauthorizedException('카카오 로그인에 실패했습니다: ${e.message}');
    } catch (e, stackTrace) {
      print('[KakaoLoginUseCase] 카카오 로그인 에러: $e');
      print('[KakaoLoginUseCase] StackTrace: $stackTrace');
      
      // 사용자 취소 케이스 처리
      if (e.toString().contains('cancelled') || 
          e.toString().contains('CANCELED') ||
          e.toString().contains('user_cancelled')) {
        throw UserCancelledException();
      }
      
      throw NetworkException('카카오 로그인 중 오류가 발생했습니다: $e');
    }

    // 2. Access Token 확인
    final String accessToken = token.accessToken;
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
      print('[KakaoLoginUseCase] 사용자 정보 가져오기 실패 (무시): $e');
      // 사용자 정보 가져오기 실패해도 로그인은 진행
    }

    // 4. Repository를 통해 백엔드로 Access Token 전송
    return await _repository.loginWithKakao(
      accessToken: accessToken,
      email: email,
      nickname: nickname,
    );
  }
}
