import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/core/exceptions/auth_exceptions.dart';
import 'package:moamoa/core/exceptions/exception_handler.dart';

void main() {
  group('ExceptionHandler', () {
    test('400 응답의 서버 code를 ValidationException으로 보존한다', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/auth/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/register'),
          statusCode: 400,
          data: {
            'code': 'A012',
            'message': '인증 시간이 만료되었습니다. 다시 인증해주세요',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ExceptionHandler.handleDioException(exception);

      expect(result, isA<ValidationException>());
      expect((result as ValidationException).code, 'A012');
      expect(result.message, '인증 시간이 만료되었습니다. 다시 인증해주세요');
    });

    test('401 응답의 서버 code를 UnauthorizedException으로 보존한다', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: {
            'code': 'A002',
            'message': '인증이 만료되었습니다',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ExceptionHandler.handleDioException(exception);

      expect(result, isA<UnauthorizedException>());
      expect((result as UnauthorizedException).code, 'A002');
      expect(result.message, '인증이 만료되었습니다');
    });
  });
}
