// models
import 'package:moamoa/features/terms/data/models/models.dart';

/// Terms Remote Data Source 인터페이스
///
/// 약관 관련 API 서버와 통신하는 계층
abstract class TermsRemoteDataSource {
  /// 현재 유효한 약관 목록 조회
  ///
  /// Returns: [List<TermsDocumentModel>] 약관 문서 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<List<TermsDocumentModel>> getActiveTerms();

  /// 내 약관 동의 이력 조회
  ///
  /// Returns: [List<UserAgreementModel>] 동의 이력 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  Future<List<UserAgreementModel>> getMyAgreements();

  /// 약관 재동의
  ///
  /// [agreements] 동의 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 필수 약관 미동의
  /// - [ServerException] 서버 오류
  Future<void> consentAgreements(List<AgreementRequestModel> agreements);

  /// 마케팅 수신 동의 변경
  ///
  /// [agreed] 동의 여부
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  Future<void> updateMarketingConsent(bool agreed);
}
