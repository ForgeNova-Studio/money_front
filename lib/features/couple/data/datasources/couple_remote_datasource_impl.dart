import 'package:dio/dio.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/couple/data/datasources/couple_remote_datasource.dart';
import 'package:moamoa/features/couple/data/models/couple_model.dart';

class CoupleRemoteDataSourceImpl implements CoupleRemoteDataSource {
  final Dio dio;

  CoupleRemoteDataSourceImpl({required this.dio});

  @override
  Future<CoupleModel?> getCurrentCouple() async {
    try {
      final response = await dio.get(ApiConstants.couplesMe);
      return CoupleModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // 404는 커플이 없는 정상 상태
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<InviteModel> generateInviteCode() async {
    try {
      final response = await dio.post(ApiConstants.couplesInvite);
      return InviteModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<CoupleModel> joinCouple({required String inviteCode}) async {
    try {
      final response = await dio.post(
        ApiConstants.couplesJoin,
        data: {'inviteCode': inviteCode},
      );
      return CoupleModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> unlinkCouple() async {
    try {
      await dio.delete(ApiConstants.couplesUnlink);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
