import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'receipt_data.dart';

part 'pending_receipt.freezed.dart';

/// OCR에서 파싱된 후 사용자 확인을 기다리는 영수증 데이터
@freezed
sealed class PendingReceipt with _$PendingReceipt {
  const PendingReceipt._();

  const factory PendingReceipt({
    /// 고유 식별자 (UUID)
    required String id,

    /// 원본 파싱 데이터
    required ReceiptData receiptData,

    /// 사용자가 수정한 금액 (null이면 파싱 원본 사용)
    int? amountOverride,

    /// 사용자가 수정한 날짜 (null이면 파싱 원본 사용)
    DateTime? dateOverride,

    /// 사용자가 수정한 카테고리 (null이면 미분류)
    String? category,

    /// 사용자가 수정한 메모
    String? memo,

    /// 사용자가 수정한 가맹점명 (null이면 파싱 원본 사용)
    String? merchantOverride,

    /// 생성 시간
    required DateTime createdAt,
  }) = _PendingReceipt;

  /// 새 PendingReceipt 생성 헬퍼
  factory PendingReceipt.fromReceiptData(ReceiptData data) {
    return PendingReceipt(
      id: const Uuid().v4(),
      receiptData: data,
      category: data.category?.code,
      createdAt: DateTime.now(),
    );
  }

  /// 금액 (편의 getter) - 사용자 수정값 우선
  int get amount => amountOverride ?? receiptData.amount ?? 0;

  /// 가맹점 (편의 getter) - 사용자 수정값 우선
  String get merchant =>
      merchantOverride ?? receiptData.displayName ?? receiptData.merchant ?? '알 수 없음';

  /// 결제일 (편의 getter) - 사용자 수정값 우선
  DateTime get date => dateOverride ?? receiptData.date ?? DateTime.now();

  /// 원본 텍스트
  String get rawText => receiptData.rawText;
}
