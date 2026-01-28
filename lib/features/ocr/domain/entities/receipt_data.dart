import 'category.dart';

/// 영수증 승인 상태
enum ReceiptStatus {
  /// 승인
  approved,

  /// 취소
  cancelled,
}

/// 영수증 파싱 결과 데이터
///
/// 기능:
/// - 금액, 날짜, 가맹점, 승인/취소 상태 저장
/// - 브랜드 매칭 및 카테고리 자동 분류
class ReceiptData {
  /// 파싱된 금액 (원)
  final int? amount;

  /// 파싱된 날짜
  final DateTime? date;

  /// 파싱된 원본 가맹점명 (OCR 결과 그대로)
  final String? merchant;

  /// 정규화된 브랜드명 (Strategy Pattern 결과)
  /// 예: "수타벅스 강남R점" → "스타벅스"
  final String? displayName;

  /// 자동 분류된 카테고리
  final Category? category;

  /// 승인/취소 상태
  final ReceiptStatus? status;

  /// 원본 텍스트 (디버깅 및 수동 수정용)
  final String rawText;

  /// 카드사 식별 (선택적)
  final String? cardIssuer;

  const ReceiptData({
    this.amount,
    this.date,
    this.merchant,
    this.displayName,
    this.category,
    this.status,
    required this.rawText,
    this.cardIssuer,
  });

  /// 빈 영수증 데이터 생성 (파싱 실패 시)
  factory ReceiptData.empty(String rawText) {
    return ReceiptData(
      rawText: rawText,
      amount: null,
      date: null,
      merchant: null,
      displayName: null,
      category: null,
      status: null,
      cardIssuer: null,
    );
  }

  /// 데이터 복사본 생성 (일부 필드만 수정)
  ReceiptData copyWith({
    int? amount,
    DateTime? date,
    String? merchant,
    String? displayName,
    Category? category,
    ReceiptStatus? status,
    String? rawText,
    String? cardIssuer,
  }) {
    return ReceiptData(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      merchant: merchant ?? this.merchant,
      displayName: displayName ?? this.displayName,
      category: category ?? this.category,
      status: status ?? this.status,
      rawText: rawText ?? this.rawText,
      cardIssuer: cardIssuer ?? this.cardIssuer,
    );
  }

  /// 모든 필수 필드가 파싱되었는지 확인
  bool get isComplete {
    return amount != null && date != null && merchant != null;
  }

  /// 승인 여부 확인
  bool get isApproved {
    return status == ReceiptStatus.approved || status == null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptData &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          date == other.date &&
          merchant == other.merchant &&
          displayName == other.displayName &&
          category == other.category &&
          status == other.status &&
          rawText == other.rawText &&
          cardIssuer == other.cardIssuer;

  @override
  int get hashCode =>
      amount.hashCode ^
      date.hashCode ^
      merchant.hashCode ^
      displayName.hashCode ^
      category.hashCode ^
      status.hashCode ^
      rawText.hashCode ^
      cardIssuer.hashCode;

  @override
  String toString() {
    return 'ReceiptData(amount: $amount, date: $date, '
        'merchant: $merchant, displayName: $displayName, '
        'category: ${category?.displayName}, '
        'status: ${status?.name}, cardIssuer: $cardIssuer)';
  }
}
