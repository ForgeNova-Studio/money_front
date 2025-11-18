import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:moneyflow/features/budget/data/services/budget_api_service.dart';
import 'package:moneyflow/features/budget/domain/entities/budget_model.dart';

/// 예산 상태
enum BudgetStatus { idle, loading, success, error }

/// 예산 프로바이더
///
/// 기능:
/// - 월별 예산 생성/수정
/// - 예산 조회 (목표 금액 및 현재 소비 금액)
/// - 로딩 상태 관리
/// - 에러 처리
class BudgetProvider with ChangeNotifier {
  final BudgetApiService _apiService;

  /// 현재 상태
  BudgetStatus _status = BudgetStatus.idle;
  BudgetStatus get status => _status;

  /// 현재 조회된 예산
  BudgetModel? _budget;
  BudgetModel? get budget => _budget;

  /// 에러 메시지
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BudgetProvider({BudgetApiService? apiService})
      : _apiService = apiService ?? BudgetApiService();

  /// 예산 생성 또는 수정
  ///
  /// @param budget 예산 모델
  Future<void> createOrUpdateBudget(BudgetModel budget) async {
    try {
      _status = BudgetStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final data = await _apiService.createOrUpdateBudget(
        budget.toRequestJson(),
      );

      _budget = BudgetModel.fromJson(data);
      _status = BudgetStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else if (e.response?.statusCode == 403) {
        _errorMessage = '예산 접근 권한이 없습니다.';
      } else if (e.response?.statusCode == 400) {
        _errorMessage = '잘못된 요청입니다. 입력값을 확인해주세요.';
      } else {
        _errorMessage = '네트워크 오류가 발생했습니다: ${e.message}';
      }
      _status = BudgetStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = BudgetStatus.error;
    }

    notifyListeners();
  }

  /// 특정 년월의 예산 조회
  ///
  /// @param year 조회할 년도
  /// @param month 조회할 월 (1-12)
  Future<void> fetchBudget(int year, int month) async {
    try {
      _status = BudgetStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final data = await _apiService.getBudget(
        year: year,
        month: month,
      );

      _budget = BudgetModel.fromJson(data);
      _status = BudgetStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else if (e.response?.statusCode == 403) {
        _errorMessage = '예산 접근 권한이 없습니다.';
      } else if (e.response?.statusCode == 404) {
        _errorMessage = '해당 기간의 예산을 찾을 수 없습니다';
        _budget = null;
      } else {
        _errorMessage = '네트워크 오류가 발생했습니다: ${e.message}';
      }
      _status = BudgetStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = BudgetStatus.error;
    }

    notifyListeners();
  }

  /// 예산 삭제
  ///
  /// @param budgetId 예산 ID
  Future<void> deleteBudget(String budgetId) async {
    try {
      _status = BudgetStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _apiService.deleteBudget(budgetId);

      _budget = null;
      _status = BudgetStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else if (e.response?.statusCode == 403) {
        _errorMessage = '예산 삭제 권한이 없습니다.';
      } else if (e.response?.statusCode == 404) {
        _errorMessage = '예산을 찾을 수 없습니다';
      } else {
        _errorMessage = '네트워크 오류가 발생했습니다: ${e.message}';
      }
      _status = BudgetStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = BudgetStatus.error;
    }

    notifyListeners();
  }

  /// 상태 초기화
  void reset() {
    _status = BudgetStatus.idle;
    _budget = null;
    _errorMessage = null;
    notifyListeners();
  }
}
