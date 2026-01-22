import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:flutter_naver_login/interface/types/naver_token.dart';
import 'package:logger/logger.dart';

/// 네이버 로그인 서비스
///
/// flutter_naver_login 패키지를 사용하여 네이버 소셜 로그인을 처리합니다.
/// 네이버 앱이 설치되어 있으면 앱으로, 없으면 웹뷰로 로그인합니다.
class NaverLoginService {
  final Logger _logger = Logger();

  /// 네이버 로그인 실행
  ///
  /// Returns: NaverLoginResult (accessToken, refreshToken, email 등 포함)
  /// Throws: Exception on login failure
  Future<NaverLoginResult> login() async {
    try {
      _logger.i('네이버 로그인 시작');

      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        _logger.i('네이버 로그인 성공: ${result.account?.email}');
        return result;
      } else if (result.status == NaverLoginStatus.error) {
        _logger.w('네이버 로그인 에러');
        throw Exception('로그인에 실패했습니다.');
      } else {
        _logger.e('네이버 로그인 실패: ${result.status}');
        throw Exception('로그인에 실패했습니다.');
      }
    } catch (e, stackTrace) {
      _logger.e('네이버 로그인 에러', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 네이버 로그아웃
  Future<void> logout() async {
    try {
      _logger.i('네이버 로그아웃 시작');
      await FlutterNaverLogin.logOut();
      _logger.i('네이버 로그아웃 완료');
    } catch (e, stackTrace) {
      _logger.e('네이버 로그아웃 에러', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 현재 네이버 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    try {
      final NaverToken token = await FlutterNaverLogin.refreshAccessTokenWithRefreshToken();
      return token.accessToken?.isNotEmpty ?? false;
    } catch (e) {
      _logger.e('네이버 로그인 상태 확인 에러', error: e);
      return false;
    }
  }

  /// 현재 액세스 토큰 가져오기
  Future<NaverToken?> getCurrentAccessToken() async {
    try {
      final NaverToken token = await FlutterNaverLogin.refreshAccessTokenWithRefreshToken();
      return token;
    } catch (e) {
      _logger.e('네이버 액세스 토큰 조회 에러', error: e);
      return null;
    }
  }
}

