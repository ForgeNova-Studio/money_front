import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:moneyflow/features/income/data/services/income_api_service.dart';
import '../../domain/entities/income.dart';

enum IncomeStatus { initial, loading, success, error }

class IncomeProvider extends ChangeNotifier {
  IncomeStatus _status = IncomeStatus.initial;
  List<IncomeModel> _incomes = [];
  List<IncomeModel> _recentIncomes = [];
  String? _errorMessage;

  final IncomeApiService _apiService = IncomeApiService();

  IncomeStatus get status => _status;
  List<IncomeModel> get incomes => _incomes;
  List<IncomeModel> get recentIncomes => _recentIncomes;
  String? get errorMessage => _errorMessage;

  /// 수입 생성
  Future<void> createIncome(IncomeModel income) async {
    _status = IncomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createIncome(income.toJson());
      final newIncome = IncomeModel.fromJson(response);

      _incomes.insert(0, newIncome);
      _status = IncomeStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = IncomeStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 최근 수입 내역 조회
  Future<void> fetchRecentIncomes() async {
    _status = IncomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getRecentIncomes();
      _recentIncomes =
          (response as List).map((json) => IncomeModel.fromJson(json)).toList();

      _status = IncomeStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = IncomeStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 날짜 범위로 수입 조회
  Future<void> fetchIncomes({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    _status = IncomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getIncomes(
        startDate: startDate,
        endDate: endDate,
        source: source,
      );

      _incomes = (response['incomes'] as List)
          .map((json) => IncomeModel.fromJson(json))
          .toList();

      _status = IncomeStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = IncomeStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 수입 수정
  Future<void> updateIncome(String incomeId, IncomeModel income) async {
    _status = IncomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await _apiService.updateIncome(incomeId, income.toJson());
      final updatedIncome = IncomeModel.fromJson(response);

      final index = _incomes.indexWhere((i) => i.incomeId == incomeId);
      if (index != -1) {
        _incomes[index] = updatedIncome;
      }

      _status = IncomeStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = IncomeStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 수입 삭제
  Future<void> deleteIncome(String incomeId) async {
    _status = IncomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteIncome(incomeId);

      _incomes.removeWhere((i) => i.incomeId == incomeId);
      _recentIncomes.removeWhere((i) => i.incomeId == incomeId);

      _status = IncomeStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = IncomeStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return '서버 오류가 발생했습니다';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return '서버 연결 시간이 초과되었습니다';
    } else if (error.type == DioExceptionType.connectionError) {
      return '서버에 연결할 수 없습니다';
    }
    return '알 수 없는 오류가 발생했습니다';
  }
}
