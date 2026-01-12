/// 결제 수단 열거형
enum PaymentMethod {
  card('CARD', '카드'),
  cash('CASH', '현금');

  final String code;
  final String label;

  const PaymentMethod(this.code, this.label);

  static PaymentMethod fromCode(String code) {
    return PaymentMethod.values.firstWhere(
      (e) => e.code == code,
      orElse: () => PaymentMethod.card,
    );
  }
}
