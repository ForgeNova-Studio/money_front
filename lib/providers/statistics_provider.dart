import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../data/models/monthly_statistics_model.dart';

/// 통계 상태
enum StatisticsStatus { idle, loading, success, error }

/// 통계 프로바이더
///
/// 기능:
/// - 월간 통계 조회
/// - 로딩 상태 관리
/// - 에러 처리
class StatisticsProvider with ChangeNotifier {
  late Dio _dio;

  /// 현재 상태
  StatisticsStatus _status = StatisticsStatus.idle;
  StatisticsStatus get status => _status;

  /// 월간 통계 데이터
  MonthlyStatisticsModel? _monthlyStatistics;
  MonthlyStatisticsModel? get monthlyStatistics => _monthlyStatistics;

  /// 에러 메시지
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StatisticsProvider() {
    _initDio();
  }

  /// Dio 인스턴스 초기화
  /// JWT 토큰을 자동으로 추가하는 인터셉터 설정
  void _initDio() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    // JWT 토큰 인터셉터
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  /// 월간 통계 조회
  ///
  /// @param year 조회할 년도
  /// @param month 조회할 월 (1-12)
  Future<void> fetchMonthlyStatistics(int year, int month) async {
    try {
      _status = StatisticsStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final response = await _dio.get(
        '${ApiConstants.statisticsUrl}/monthly',
        queryParameters: {
          'year': year,
          'month': month,
        },
      );

      if (response.statusCode == 200) {
        _monthlyStatistics = MonthlyStatisticsModel.fromJson(response.data);
        _status = StatisticsStatus.success;
      } else {
        _errorMessage = '통계 조회에 실패했습니다';
        _status = StatisticsStatus.error;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else if (e.response?.statusCode == 404) {
        _errorMessage = '통계 데이터를 찾을 수 없습니다';
      } else {
        _errorMessage = '네트워크 오류가 발생했습니다';
      }
      _status = StatisticsStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다';
      _status = StatisticsStatus.error;
    }

    notifyListeners();
  }

  /// 상태 초기화
  void reset() {
    _status = StatisticsStatus.idle;
    _monthlyStatistics = null;
    _errorMessage = null;
    notifyListeners();
  }
}
