import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/monthly_statistics_model.dart';
import '../data/services/api_service.dart';

/// 통계 상태
enum StatisticsStatus { idle, loading, success, error }

/// 통계 프로바이더
///
/// 기능:
/// - 월간 통계 조회
/// - 로딩 상태 관리
/// - 에러 처리
class StatisticsProvider with ChangeNotifier {
  final ApiService _apiService;

  /// 현재 상태
  StatisticsStatus _status = StatisticsStatus.idle;
  StatisticsStatus get status => _status;

  /// 월간 통계 데이터
  MonthlyStatisticsModel? _monthlyStatistics;
  MonthlyStatisticsModel? get monthlyStatistics => _monthlyStatistics;

  /// 에러 메시지
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StatisticsProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// 월간 통계 조회
  ///
  /// @param year 조회할 년도
  /// @param month 조회할 월 (1-12)
  Future<void> fetchMonthlyStatistics(int year, int month) async {
    try {
      _status = StatisticsStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final data = await _apiService.getMonthlyStatistics(
        year: year,
        month: month,
      );

      _monthlyStatistics = MonthlyStatisticsModel.fromJson(data);
      _status = StatisticsStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else if (e.response?.statusCode == 403) {
        _errorMessage = '통계 접근 권한이 없습니다. 다시 로그인해주세요.';
      } else if (e.response?.statusCode == 404) {
        _errorMessage = '통계 데이터를 찾을 수 없습니다';
      } else {
        _errorMessage = '네트워크 오류가 발생했습니다: ${e.message}';
      }
      _status = StatisticsStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
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
