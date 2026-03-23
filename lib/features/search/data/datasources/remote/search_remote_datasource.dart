import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/search/data/models/search_response_model.dart';

/// 거래 내역 검색 Remote DataSource
abstract class SearchRemoteDataSource {
  Future<SearchResponseModel> search({
    required String keyword,
    required String accountBookId,
    int page = 0,
    int size = 20,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<SearchResponseModel> search({
    required String keyword,
    required String accountBookId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.homeSearch,
        queryParameters: {
          'keyword': keyword,
          'accountBookId': accountBookId,
          'page': page,
          'size': size,
        },
      );
      return SearchResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[SearchRemoteDataSource] search error: $e');
        debugPrint('[SearchRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
}
