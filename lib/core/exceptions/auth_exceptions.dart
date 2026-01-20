// 인증 관련 예외 클래스들

/// 네트워크 연결 오류
///
/// 인터넷 연결이 끊어졌거나, 서버에 도달할 수 없을 때 발생
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = '네트워크 연결을 확인해주세요']);

  @override
  String toString() => 'NetworkException: $message';
}

/// 인증 실패
///
/// 잘못된 이메일/비밀번호, 권한 없음 등 인증 관련 오류
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = '이메일 또는 비밀번호가 올바르지 않습니다']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// 사용자 취소
///
/// 로그인/인증 플로우에서 사용자가 취소한 경우
class UserCancelledException implements Exception {
  final String message;

  UserCancelledException([this.message = '사용자에 의해 취소되었습니다']);

  @override
  String toString() => 'UserCancelledException: $message';
}

/// 입력값 검증 오류
///
/// 이메일 중복, 비밀번호 형식 오류 등 입력값 검증 실패
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors; // 필드별 에러 메시지

  ValidationException(this.message, {this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

/// 서버 오류
///
/// 500번대 서버 내부 오류
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = '서버 오류가 발생했습니다', this.statusCode});

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}

/// 토큰 만료
///
/// Access Token 또는 Refresh Token이 만료됨
class TokenExpiredException implements Exception {
  final String message;

  TokenExpiredException([this.message = '로그인이 만료되었습니다. 다시 로그인해주세요']);

  @override
  String toString() => 'TokenExpiredException: $message';
}

/// 로컬 저장소 오류
///
/// SharedPreferences, SQLite 등 로컬 저장소 접근 오류
class StorageException implements Exception {
  final String message;

  StorageException([this.message = '데이터 저장 중 오류가 발생했습니다']);

  @override
  String toString() => 'StorageException: $message';
}

/// 타임아웃 오류
///
/// API 요청 시간 초과
class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = '요청 시간이 초과되었습니다']);

  @override
  String toString() => 'TimeoutException: $message';
}

/// 알 수 없는 오류
///
/// 예상하지 못한 오류 발생 시 사용
class UnknownException implements Exception {
  final String message;
  final dynamic originalError;

  UnknownException({this.message = '알 수 없는 오류가 발생했습니다', this.originalError});

  @override
  String toString() => 'UnknownException: $message (original: $originalError)';
}
