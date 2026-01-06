import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/receipt_data.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../providers/ocr_providers.dart';

/// OCR 상태 클래스
///
/// 3가지 상태:
/// - 초기 상태: isLoading = false, data = null, error = null
/// - 로딩 중: isLoading = true
/// - 성공: data != null
/// - 실패: error != null
class OcrState {
  final bool isLoading;
  final List<ReceiptData> data;
  final String? error;

  OcrState({
    this.isLoading = false,
    this.data = const [],
    this.error,
  });

  /// 편의 Getters
  bool get hasData => data.isNotEmpty;
  bool get hasError => error != null;

  /// copyWith 패턴
  OcrState copyWith({
    bool? isLoading,
    List<ReceiptData>? data,
    String? error,
  }) {
    return OcrState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

/// OCR ViewModel (Riverpod 2.0+ Notifier)
///
/// 책임:
/// - UI 상태 관리 (로딩, 성공, 실패)
/// - Repository 호출
/// - 에러 처리
///
/// 사용법:
/// ```dart
/// final state = ref.watch(ocrViewModelProvider);
/// ref.read(ocrViewModelProvider.notifier).processImage(imageFile);
/// ```
class OcrViewModel extends Notifier<OcrState> {
  late final OcrRepository _repository;
  final _logger = Logger(level: kDebugMode ? Level.debug : Level.nothing);

  @override
  OcrState build() {
    // 의존성 주입: ocrRepositoryProvider 사용
    _repository = ref.watch(ocrRepositoryProvider);
    return OcrState(); // 초기 상태
  }

  /// 이미지에서 영수증 데이터 추출
  ///
  /// [imageFile] 영수증 이미지 파일
  Future<void> processImage(File imageFile) async {
    try {
      // 로딩 시작
      state = state.copyWith(isLoading: true, error: null);

      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('📸 OCR 처리 시작 (ViewModel)');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // Repository 호출
      final results = await _repository.extractReceiptData(imageFile);

      // 성공
      state = state.copyWith(
        isLoading: false,
        data: results,
        error: results.isEmpty ? '영수증 정보를 찾을 수 없습니다.\n이미지를 다시 확인해주세요.' : null,
      );

      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('✅ OCR 처리 완료: ${results.length}건');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e, stackTrace) {
      // 실패
      _logger.e('OCR 처리 에러', error: e, stackTrace: stackTrace);

      state = state.copyWith(
        isLoading: false,
        error: 'OCR 처리 중 오류가 발생했습니다.\n다시 시도해주세요.',
      );
    }
  }

  /// 영수증 데이터를 서버로 전송
  ///
  /// [receiptData] 전송할 영수증 데이터
  /// Returns 성공 여부
  Future<bool> submitReceiptData(ReceiptData receiptData) async {
    try {
      // 로딩 시작
      state = state.copyWith(isLoading: true, error: null);

      _logger.i('📤 영수증 서버 전송 시작');

      // Repository 호출
      await _repository.submitReceiptData(receiptData);

      // 성공
      state = state.copyWith(isLoading: false);

      _logger.i('✅ 영수증 서버 전송 완료');
      return true;
    } catch (e, stackTrace) {
      // 실패
      _logger.e('영수증 전송 에러', error: e, stackTrace: stackTrace);

      state = state.copyWith(
        isLoading: false,
        error: '서버 전송 중 오류가 발생했습니다.\n다시 시도해주세요.',
      );
      return false;
    }
  }

  /// 상태 초기화
  void reset() {
    state = OcrState();
    _logger.d('OCR 상태 초기화');
  }

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// OcrViewModel Provider
///
/// UI에서 사용:
/// ```dart
/// // 상태 읽기
/// final state = ref.watch(ocrViewModelProvider);
///
/// // 액션 호출
/// ref.read(ocrViewModelProvider.notifier).processImage(file);
/// ```
final ocrViewModelProvider = NotifierProvider<OcrViewModel, OcrState>(() {
  return OcrViewModel();
});
