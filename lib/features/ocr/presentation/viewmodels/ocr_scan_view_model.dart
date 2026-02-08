import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/presentation/providers/expense_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import '../../domain/entities/pending_receipt.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../providers/ocr_providers.dart';
import '../states/ocr_scan_state.dart';

part 'ocr_scan_view_model.g.dart';

/// OCR 스캔 ViewModel
/// 영수증 이미지를 처리하고 대기 목록 관리
@riverpod
class OcrScanViewModel extends _$OcrScanViewModel {
  late final OcrRepository _repository;

  @override
  OcrScanState build() {
    _repository = ref.watch(ocrRepositoryProvider);
    return const OcrScanState();
  }

  /// 이미지에서 영수증 데이터 추출
  Future<void> processImage(File imageFile) async {
    try {
      state = state.copyWith(
        isProcessing: true,
        error: null,
        selectedImagePath: imageFile.path,
      );

      if (kDebugMode) {
        debugPrint('[OcrScan] 이미지 처리 시작: ${imageFile.path}');
      }

      final results = await _repository.extractReceiptData(imageFile);

      if (results.isEmpty) {
        state = state.copyWith(
          isProcessing: false,
          error: '영수증 정보를 찾을 수 없습니다.\n다른 이미지를 선택해주세요.',
        );
        return;
      }

      // ReceiptData를 PendingReceipt로 변환
      final pendingReceipts = results
          .map((data) => PendingReceipt.fromReceiptData(data))
          .toList();

      state = state.copyWith(
        isProcessing: false,
        pendingReceipts: pendingReceipts,
      );

      if (kDebugMode) {
        debugPrint('[OcrScan] 처리 완료: ${results.length}건');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[OcrScan] 처리 에러: $e');
        debugPrint('$stackTrace');
      }

      state = state.copyWith(
        isProcessing: false,
        error: 'OCR 처리 중 오류가 발생했습니다.\n다시 시도해주세요.',
      );
    }
  }

  /// 개별 항목 수정
  void updatePendingReceipt({
    required String id,
    int? amount,
    DateTime? date,
    String? category,
    String? memo,
    String? merchant,
  }) {
    final updatedList = state.pendingReceipts.map((item) {
      if (item.id == id) {
        return item.copyWith(
          amountOverride: amount ?? item.amountOverride,
          dateOverride: date ?? item.dateOverride,
          category: category ?? item.category,
          memo: memo ?? item.memo,
          merchantOverride: merchant ?? item.merchantOverride,
        );
      }
      return item;
    }).toList();

    state = state.copyWith(pendingReceipts: updatedList);
  }

  /// 개별 항목 삭제
  void removePendingReceipt(String id) {
    final updatedList = state.pendingReceipts
        .where((item) => item.id != id)
        .toList();

    state = state.copyWith(pendingReceipts: updatedList);

    if (kDebugMode) {
      debugPrint('[OcrScan] 항목 삭제: $id, 남은 항목: ${state.count}');
    }
  }

  /// 모든 대기 영수증 일괄 저장
  Future<bool> saveAllPendingReceipts() async {
    if (state.pendingReceipts.isEmpty) return false;

    state = state.copyWith(isSaving: true, error: null);

    try {
      // 선택된 가계부 ID 가져오기
      final selectedAccountBookId =
          ref.read(selectedAccountBookViewModelProvider).asData?.value;
      if (selectedAccountBookId == null) {
        throw StateError('가계부가 선택되지 않았습니다');
      }

      // UseCase를 미리 가져와서 루프에서 사용
      final createExpenseUseCase = ref.read(createExpenseUseCaseProvider);

      // 저장할 영수증 목록을 미리 복사 (상태 변경 방지)
      final receiptsToSave = List<PendingReceipt>.from(state.pendingReceipts);

      for (final pending in receiptsToSave) {
        final expense = Expense(
          amount: pending.amount,
          date: pending.date,
          merchant: pending.merchant,
          category: pending.category,
          memo: pending.memo ?? pending.rawText,
          paymentMethod: 'CARD',
          isAutoCategorized: pending.category != null,
          accountBookId: selectedAccountBookId,
        );

        await createExpenseUseCase(expense);
      }

      // 저장 완료 후 상태 초기화
      state = const OcrScanState();

      if (kDebugMode) {
        debugPrint('[OcrScan] 모든 영수증 저장 완료: ${receiptsToSave.length}건');
      }

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: '저장 중 오류가 발생했습니다: $e',
      );

      if (kDebugMode) {
        debugPrint('[OcrScan] 저장 에러: $e');
      }

      return false;
    }
  }

  /// 전체 초기화
  void reset() {
    state = const OcrScanState();

    if (kDebugMode) {
      debugPrint('[OcrScan] 상태 초기화');
    }
  }

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(error: null);
  }
}
