import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/couple_model.dart';
import '../data/services/api_service.dart';

/// 커플 상태
enum CoupleStatus { idle, loading, success, error }

/// 커플 프로바이더
///
/// 기능:
/// - 초대 코드 생성
/// - 커플 가입
/// - 커플 연동 해제
/// - 현재 커플 정보 조회
class CoupleProvider with ChangeNotifier {
  final ApiService _apiService;

  /// 현재 상태
  CoupleStatus _status = CoupleStatus.idle;
  CoupleStatus get status => _status;

  /// 현재 커플 정보
  CoupleModel? _couple;
  CoupleModel? get couple => _couple;

  /// 초대 응답 정보
  InviteResponse? _inviteResponse;
  InviteResponse? get inviteResponse => _inviteResponse;

  /// 에러 메시지
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CoupleProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// 초대 코드 생성
  Future<void> generateInviteCode() async {
    try {
      _status = CoupleStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final data = await _apiService.generateInviteCode();
      _inviteResponse = InviteResponse.fromJson(data);
      _status = CoupleStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        _errorMessage = e.response?.data['message'] ?? '이미 커플 연동이 완료되었습니다';
      } else if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else {
        _errorMessage = '초대 코드 생성에 실패했습니다';
      }
      _status = CoupleStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = CoupleStatus.error;
    }

    notifyListeners();
  }

  /// 커플 가입 (초대 코드 입력)
  Future<void> joinCouple(String inviteCode) async {
    try {
      _status = CoupleStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final data = await _apiService.joinCouple(inviteCode);
      _couple = CoupleModel.fromJson(data);
      _status = CoupleStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        _errorMessage = e.response?.data['message'] ?? '잘못된 요청입니다';
      } else if (e.response?.statusCode == 404) {
        _errorMessage = '유효하지 않은 초대 코드입니다';
      } else if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else {
        _errorMessage = '커플 가입에 실패했습니다';
      }
      _status = CoupleStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = CoupleStatus.error;
    }

    notifyListeners();
  }

  /// 커플 연동 해제
  Future<void> unlinkCouple() async {
    try {
      _status = CoupleStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _apiService.unlinkCouple();
      _couple = null;
      _inviteResponse = null;
      _status = CoupleStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _errorMessage = '커플 정보를 찾을 수 없습니다';
      } else if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else {
        _errorMessage = '커플 연동 해제에 실패했습니다';
      }
      _status = CoupleStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = CoupleStatus.error;
    }

    notifyListeners();
  }

  /// 현재 커플 정보 조회
  Future<void> loadCurrentCouple() async {
    try {
      _status = CoupleStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final data = await _apiService.getCurrentCouple();
      if (data != null) {
        _couple = CoupleModel.fromJson(data);
      } else {
        _couple = null; // 커플이 없는 경우
      }
      _status = CoupleStatus.success;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _errorMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else {
        _errorMessage = '커플 정보 조회에 실패했습니다';
      }
      _status = CoupleStatus.error;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다: $e';
      _status = CoupleStatus.error;
    }

    notifyListeners();
  }

  /// 상태 초기화
  void reset() {
    _status = CoupleStatus.idle;
    _couple = null;
    _inviteResponse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
