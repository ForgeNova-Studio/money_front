import 'package:dio/dio.dart';
import 'auth_exceptions.dart';

/// DioException을 우리의 Custom Exception으로 변환하는 핸들러
///
/// 사용 예시:
/// ```dart
/// try {
///   final response = await dio.post('/login');
/// } on DioException catch (e) {
///   throw ExceptionHandler.handleDioException(e);
/// }
/// ```
class ExceptionHandler {
  /// DioException을 Custom Exception으로 변환
  static Exception handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('요청 시간이 초과되었습니다');

      case DioExceptionType.connectionError:
        return NetworkException('네트워크 연결을 확인해주세요');

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return UnknownException(message: '요청이 취소되었습니다');

      case DioExceptionType.badCertificate:
        return NetworkException('보안 인증서 오류가 발생했습니다');

      case DioExceptionType.unknown:
        return NetworkException('네트워크 오류가 발생했습니다');
    }
  }

  /// HTTP 응답 에러 처리
  static Exception _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // 서버에서 보낸 메시지 추출
    String? message;
    if (data is Map<String, dynamic>) {
      message = data['message'] as String?;
    }

    switch (statusCode) {
      case 400:
        // Bad Request - 입력값 검증 오류
        Map<String, String>? fieldErrors;
        if (data is Map<String, dynamic> && data['errors'] != null) {
          fieldErrors = Map<String, String>.from(data['errors'] as Map);
        }
        return ValidationException(
          message ?? '입력값을 확인해주세요',
          errors: fieldErrors,
        );

      case 401:
        // Unauthorized - 인증 실패
        return UnauthorizedException(
          message ?? '이메일 또는 비밀번호가 올바르지 않습니다',
        );

      case 403:
        // Forbidden - 권한 없음
        return UnauthorizedException(
          message ?? '접근 권한이 없습니다',
        );

      case 404:
        // Not Found
        return ServerException(
          message: message ?? '요청한 정보를 찾을 수 없습니다',
          statusCode: 404,
        );

      case 409:
        // Conflict - 중복 등
        return ValidationException(
          message ?? '이미 존재하는 정보입니다',
        );

      case 422:
        // Unprocessable Entity - 입력값 검증 오류
        return ValidationException(
          message ?? '입력값을 확인해주세요',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        // Server Error
        return ServerException(
          message: message ?? '서버 오류가 발생했습니다',
          statusCode: statusCode,
        );

      default:
        return UnknownException(
          message: message ?? '알 수 없는 오류가 발생했습니다',
          originalError: error,
        );
    }
  }

  /// Exception을 사용자 친화적인 메시지로 변환
  static String getErrorMessage(Exception exception) {
    if (exception is NetworkException) {
      return exception.message;
    } else if (exception is UnauthorizedException) {
      return exception.message;
    } else if (exception is ValidationException) {
      return exception.message;
    } else if (exception is ServerException) {
      return exception.message;
    } else if (exception is TokenExpiredException) {
      return exception.message;
    } else if (exception is StorageException) {
      return exception.message;
    } else if (exception is TimeoutException) {
      return exception.message;
    } else if (exception is UnknownException) {
      return exception.message;
    }
    return '오류가 발생했습니다';
  }

  /// 모든 에러 타입을 사용자 친화적인 메시지로 변환
  /// Exception이 아닌 일반 Object 에러도 처리 가능
  static String getUserFriendlyMessage(Object error) {
    // 이미 정의된 Exception 타입이면 해당 메시지 사용
    if (error is Exception) {
      return getErrorMessage(error);
    }

    // 문자열 에러 분석
    final message = error.toString().toLowerCase();

    // 타임아웃 관련
    if (message.contains('timeout') || message.contains('timed out')) {
      return '서버 응답이 지연되고 있어요.\n잠시 후 다시 시도해주세요.';
    }

    // 네트워크 관련
    if (message.contains('socketexception') ||
        message.contains('connection refused') ||
        message.contains('connection reset') ||
        message.contains('network') ||
        message.contains('no internet') ||
        message.contains('failed host lookup')) {
      return '네트워크 연결을 확인해주세요.';
    }

    // 서버 에러
    if (message.contains('500') ||
        message.contains('502') ||
        message.contains('503') ||
        message.contains('504') ||
        message.contains('internal server')) {
      return '서버에 문제가 발생했어요.\n잠시 후 다시 시도해주세요.';
    }

    // 인증 에러
    if (message.contains('401') ||
        message.contains('403') ||
        message.contains('unauthorized') ||
        message.contains('forbidden')) {
      return '인증이 필요합니다.\n다시 로그인해주세요.';
    }

    // 기본 메시지
    return '일시적인 오류가 발생했어요.\n잠시 후 다시 시도해주세요.';
  }
}
