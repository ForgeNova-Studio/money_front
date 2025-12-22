// entities
import 'package:moneyflow/features/income/domain/entities/income.dart';

/// Income Repository 인터페이스
///
/// Income 관련 비즈니스 로직의 추상화 계층
/// Data Layer에서 이 인터페이스를 구현
///
/// Exception 처리:
/// - NetworkException: 네트워크 연결 오류
/// - UnauthorizedException: 인증 실패 (잘못된 이메일/비밀번호)
/// - ValidationException: 입력값 검증 오류
/// - ServerException: 서버 오류 (500번대)
/// - TokenExpiredException: 토큰 만료
abstract class IncomeRepository {
  /// 수입 목록 조회
  /// [startDate] 조회 시작일*
  /// [endDate] 조회 종료일*
  /// [source] 수입 출처
  ///
  /// Returns: [List<Income>] 수입 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<List<Income>> getIncomeList({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  });

  /// 수입 생성
  /// [income] 수입 정보
  ///
  /// Returns: [Income] 생성된 수입
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<Income> createIncome({
    required Income income,
  });

  /// 수입 상세 조회
  /// [incomeId] 수입 ID*
  ///
  /// Returns: [Income]
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<Income> getIncomeDetail({
    required String incomeId,
  });

  /// 수입 수정
  /// [incomeId] 수입 ID*
  /// [income] 수입 정보*
  ///
  /// Returns: [Income] 수정된 수입
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<Income> updateIncome({
    required String incomeId,
    required Income income,
  });

  /// 수입 삭제
  /// [incomeId] 수입 ID*
  ///
  /// Returns: void
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<void> deleteIncome({
    required String incomeId,
  });

  /// 최근 수입 내역 조회 (최근 수입 5개 조회 - 홈 화면 전용)
  ///
  /// Returns: [List<Income>] 최근 수입 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<List<Income>> getRecentIncomeList();
}
