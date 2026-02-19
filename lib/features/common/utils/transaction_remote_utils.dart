import 'package:dio/dio.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';

/// 트랜잭션 목록 조회용 날짜/필터 쿼리 파라미터를 생성한다.
Map<String, dynamic> buildTransactionListQuery({
  required DateTime startDate,
  required DateTime endDate,
  String? filterKey,
  String? filterValue,
}) {
  final queryParams = <String, dynamic>{
    'startDate': _toDateOnly(startDate),
    'endDate': _toDateOnly(endDate),
  };

  if (filterKey != null && filterValue != null) {
    queryParams[filterKey] = filterValue;
  }

  return queryParams;
}

/// Dio 요청 결과를 JSON 모델로 변환한다.
Future<T> requestModel<T>({
  required Future<Response<dynamic>> Function() request,
  required T Function(Map<String, dynamic> json) fromJson,
}) async {
  try {
    final response = await request();
    return fromJson(_toJsonMap(response.data));
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }
}

/// Dio 요청 결과가 본문 없는 성공 응답일 때 사용한다.
Future<void> requestVoid({
  required Future<Response<dynamic>> Function() request,
}) async {
  try {
    await request();
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }
}

String _toDateOnly(DateTime value) => value.toIso8601String().split('T')[0];

Map<String, dynamic> _toJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  throw const FormatException('Response body is not a JSON object');
}
