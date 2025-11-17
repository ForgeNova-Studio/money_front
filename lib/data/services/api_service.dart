import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  late Dio _dio;
  final StorageService _storageService = StorageService();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 인터셉터 추가
    _dio.interceptors.add(_AuthInterceptor(_storageService));
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }

  Dio get dio => _dio;

  // Auth APIs
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'nickname': nickname,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  // Expense APIs
  Future<Map<String, dynamic>> createExpense(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.expenses, data: data);
    return response.data;
  }

  Future<dynamic> getRecentExpenses() async {
    final response = await _dio.get('${ApiConstants.expenses}/recent');
    return response.data;
  }

  Future<Map<String, dynamic>> getExpenses({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      if (category != null && category.isNotEmpty) 'category': category,
    };

    final response = await _dio.get(
      ApiConstants.expenses,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getExpense(String expenseId) async {
    final response = await _dio.get('${ApiConstants.expenses}/$expenseId');
    return response.data;
  }

  Future<Map<String, dynamic>> updateExpense(
    String expenseId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(
      '${ApiConstants.expenses}/$expenseId',
      data: data,
    );
    return response.data;
  }

  Future<void> deleteExpense(String expenseId) async {
    await _dio.delete('${ApiConstants.expenses}/$expenseId');
  }

  // Statistics APIs
  Future<Map<String, dynamic>> getMonthlyStatistics({
    required int year,
    required int month,
  }) async {
    final response = await _dio.get(
      ApiConstants.statisticsMonthly,
      queryParameters: {
        'year': year,
        'month': month,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getWeeklyStatistics({
    required DateTime startDate,
  }) async {
    final response = await _dio.get(
      ApiConstants.statisticsWeekly,
      queryParameters: {
        'startDate': startDate.toIso8601String().split('T')[0],
      },
    );
    return response.data;
  }

  // Couple APIs
  Future<Map<String, dynamic>> generateInviteCode() async {
    final response = await _dio.post('/api/couples/invite');
    return response.data;
  }

  Future<Map<String, dynamic>> joinCouple(String inviteCode) async {
    final response = await _dio.post(
      '/api/couples/join',
      data: {'inviteCode': inviteCode},
    );
    return response.data;
  }

  Future<void> unlinkCouple() async {
    await _dio.delete('/api/couples/unlink');
  }

  Future<Map<String, dynamic>?> getCurrentCouple() async {
    try {
      final response = await _dio.get('/api/couples/me');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // 커플이 없는 경우
      }
      rethrow;
    }
  }

  // Income APIs
  Future<Map<String, dynamic>> createIncome(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.incomes, data: data);
    return response.data;
  }

  Future<dynamic> getRecentIncomes() async {
    final response = await _dio.get('${ApiConstants.incomes}/recent');
    return response.data;
  }

  Future<Map<String, dynamic>> getIncomes({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      if (source != null && source.isNotEmpty) 'source': source,
    };

    final response = await _dio.get(
      ApiConstants.incomes,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getIncome(String incomeId) async {
    final response = await _dio.get('${ApiConstants.incomes}/$incomeId');
    return response.data;
  }

  Future<Map<String, dynamic>> updateIncome(
    String incomeId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(
      '${ApiConstants.incomes}/$incomeId',
      data: data,
    );
    return response.data;
  }

  Future<void> deleteIncome(String incomeId) async {
    await _dio.delete('${ApiConstants.incomes}/$incomeId');
  }
}

class _AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  _AuthInterceptor(this._storageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 토큰 만료 처리
      // TODO: 로그인 화면으로 이동
    }
    handler.next(err);
  }
}
