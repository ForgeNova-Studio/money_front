import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/expense_model.dart';
import '../data/services/api_service.dart';

enum ExpenseStatus { initial, loading, success, error }

class ExpenseProvider extends ChangeNotifier {
  ExpenseStatus _status = ExpenseStatus.initial;
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> _recentExpenses = [];
  String? _errorMessage;

  final ApiService _apiService = ApiService();

  ExpenseStatus get status => _status;
  List<ExpenseModel> get expenses => _expenses;
  List<ExpenseModel> get recentExpenses => _recentExpenses;
  String? get errorMessage => _errorMessage;

  /// 지출 생성
  Future<void> createExpense(ExpenseModel expense) async {
    _status = ExpenseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createExpense(expense.toJson());
      final newExpense = ExpenseModel.fromJson(response);

      _expenses.insert(0, newExpense);
      _status = ExpenseStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = ExpenseStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 최근 지출 내역 조회
  Future<void> fetchRecentExpenses() async {
    _status = ExpenseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getRecentExpenses();
      _recentExpenses = (response as List)
          .map((json) => ExpenseModel.fromJson(json))
          .toList();

      _status = ExpenseStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = ExpenseStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 날짜 범위로 지출 조회
  Future<void> fetchExpenses({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    _status = ExpenseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getExpenses(
        startDate: startDate,
        endDate: endDate,
        category: category,
      );

      _expenses = (response['expenses'] as List)
          .map((json) => ExpenseModel.fromJson(json))
          .toList();

      _status = ExpenseStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = ExpenseStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 지출 수정
  Future<void> updateExpense(String expenseId, ExpenseModel expense) async {
    _status = ExpenseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateExpense(expenseId, expense.toJson());
      final updatedExpense = ExpenseModel.fromJson(response);

      final index = _expenses.indexWhere((e) => e.expenseId == expenseId);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }

      _status = ExpenseStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = ExpenseStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  /// 지출 삭제
  Future<void> deleteExpense(String expenseId) async {
    _status = ExpenseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteExpense(expenseId);

      _expenses.removeWhere((e) => e.expenseId == expenseId);
      _recentExpenses.removeWhere((e) => e.expenseId == expenseId);

      _status = ExpenseStatus.success;
      notifyListeners();
    } on DioException catch (e) {
      _status = ExpenseStatus.error;
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
