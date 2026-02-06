// packages
import 'dart:async';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:flutter_naver_login/interface/types/naver_account_result.dart';
import 'package:flutter_naver_login/interface/types/naver_token.dart';

// core
import 'package:moamoa/core/exceptions/exceptions.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/auth_result.dart';

// repository
import 'package:moamoa/features/auth/domain/repositories/auth_repository.dart';

/// Naver 로그인 UseCase
///
/// Naver 소셜 로그인 비즈니스 로직 처리
/// - Naver Login SDK를 통한 인증
/// - 백엔드 서버로 Access Token 전송
/// - JWT 토큰 수령 및 저장
class NaverLoginUseCase {
  final AuthRepository _repository;

  NaverLoginUseCase(this._repository);

  /// Naver 로그인 실행
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  /// - [UserCancelledException] 사용자가 로그인 취소
  Future<AuthResult> call() async {
    // 1. Naver Login 실행
    NaverLoginResult result;
    try {

      // 타임아웃 설정 (30초)
      result = await FlutterNaverLogin.logIn().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('네이버 로그인 시간 초과');
        },
      );
    } catch (e) {
      throw NetworkException('네이버 로그인 중 오류가 발생했습니다: $e');
    }

    // 2. 로그인 상태 확인
    if (result.status == NaverLoginStatus.error) {
      throw UnauthorizedException('네이버 로그인에 실패했습니다');
    }

    if (result.status != NaverLoginStatus.loggedIn) {
      throw UserCancelledException();
    }

    // 3. Access Token 가져오기 (새 API에서는 별도 호출 필요)
    NaverToken token;
    try {
      token = await FlutterNaverLogin.getCurrentAccessToken();
    } catch (e) {
      throw UnauthorizedException('네이버 Access Token을 가져올 수 없습니다');
    }

    final String accessToken = token.accessToken;
    if (accessToken.isEmpty) {
      throw UnauthorizedException('네이버 Access Token이 비어있습니다');
    }

    // 4. 사용자 계정 정보 가져오기
    final NaverAccountResult? account = result.account;
    final String? email = account?.email;
    final String? nickname = (account?.name?.isNotEmpty == true)
        ? account!.name 
        : account?.nickname;

    // 5. Repository를 통해 백엔드로 Access Token 전송
    return await _repository.loginWithNaver(
      accessToken: accessToken,
      email: email,
      nickname: nickname,
    );
  }
}
