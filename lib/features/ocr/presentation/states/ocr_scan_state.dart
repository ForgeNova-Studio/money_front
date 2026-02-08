import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/pending_receipt.dart';

part 'ocr_scan_state.freezed.dart';

/// OCR 스캔 상태
@freezed
sealed class OcrScanState with _$OcrScanState {
  const OcrScanState._();

  const factory OcrScanState({
    /// 대기 중인 영수증 목록
    @Default([]) List<PendingReceipt> pendingReceipts,

    /// 이미지 처리 중 여부
    @Default(false) bool isProcessing,

    /// 저장 중 여부
    @Default(false) bool isSaving,

    /// 에러 메시지
    String? error,

    /// 선택된 이미지 경로
    String? selectedImagePath,
  }) = _OcrScanState;

  /// 대기 중인 영수증 개수
  int get count => pendingReceipts.length;

  /// 대기 중인 영수증이 있는지 여부
  bool get hasPendingReceipts => pendingReceipts.isNotEmpty;

  /// 전체 금액 합계
  int get totalAmount =>
      pendingReceipts.fold(0, (sum, item) => sum + item.amount);

  /// 에러가 있는지 여부
  bool get hasError => error != null;
}
