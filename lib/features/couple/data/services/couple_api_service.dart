import 'package:dio/dio.dart';
import 'package:moneyflow/core/services/base_api_service.dart';

class CoupleApiService extends BaseApiService {
  // Couple APIs
  Future<Map<String, dynamic>> generateInviteCode() async {
    final response = await dio.post('/api/couples/invite');
    return response.data;
  }

  Future<Map<String, dynamic>> joinCouple(String inviteCode) async {
    final response = await dio.post(
      '/api/couples/join',
      data: {'inviteCode': inviteCode},
    );
    return response.data;
  }

  Future<void> unlinkCouple() async {
    await dio.delete('/api/couples/unlink');
  }

  Future<Map<String, dynamic>?> getCurrentCouple() async {
    try {
      final response = await dio.get('/api/couples/me');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // 커플이 없는 경우
      }
      rethrow;
    }
  }
}
