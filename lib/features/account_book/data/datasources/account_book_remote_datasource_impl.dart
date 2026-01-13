import 'package:dio/dio.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/account_book/data/datasources/account_book_remote_datasource.dart';
import 'package:moneyflow/features/account_book/data/models/account_book_member_info_model.dart';
import 'package:moneyflow/features/account_book/data/models/account_book_model.dart';

class AccountBookRemoteDataSourceImpl implements AccountBookRemoteDataSource {
  final Dio dio;

  AccountBookRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AccountBookModel>> getAccountBooks() async {
    try {
      final response = await dio.get(ApiConstants.accountBooks);
      final data = response.data as List<dynamic>;
      return data
          .map((item) => AccountBookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<AccountBookModel> getAccountBook({required String accountBookId}) async {
    try {
      final response = await dio.get(ApiConstants.accountBookById(accountBookId));
      return AccountBookModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<AccountBookModel> createAccountBook({
    required AccountBookModel accountBook,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.accountBooks,
        data: _buildCreatePayload(accountBook),
      );
      return AccountBookModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<List<AccountBookMemberInfoModel>> getMembers({
    required String accountBookId,
  }) async {
    try {
      final response = await dio.get(ApiConstants.accountBookMembers(accountBookId));
      final data = response.data as List<dynamic>;
      return data
          .map((item) =>
              AccountBookMemberInfoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> addMember({
    required String accountBookId,
    required String newMemberId,
  }) async {
    try {
      await dio.post(
        ApiConstants.accountBookMembers(accountBookId),
        queryParameters: {'newMemberId': newMemberId},
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> deactivateAccountBook({required String accountBookId}) async {
    try {
      await dio.delete(ApiConstants.accountBookById(accountBookId));
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}

Map<String, dynamic> _buildCreatePayload(AccountBookModel accountBook) {
  final payload = <String, dynamic>{
    'name': accountBook.name,
    'bookType': accountBook.bookType,
    'coupleId': accountBook.coupleId,
    'memberCount': accountBook.memberCount,
    'description': accountBook.description,
    'startDate': _formatDate(accountBook.startDate),
    'endDate': _formatDate(accountBook.endDate),
  };

  payload.removeWhere((key, value) => value == null);
  return payload;
}

String? _formatDate(DateTime? value) {
  if (value == null) {
    return null;
  }
  return value.toIso8601String().split('T')[0];
}
