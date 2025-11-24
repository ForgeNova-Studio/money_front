import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/services/base_api_service.dart';

class AuthApiService extends BaseApiService {
  // Auth APIs
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(ApiConstants.login, data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> register(
      {required String email,
      required String password,
      required String nickname}) async {
    final response = await dio.post(ApiConstants.register, data: {
      'email': email,
      'password': password,
      'nickname': nickname,
    });
    return response.data;
  }
}
