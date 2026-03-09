/// 결제 수단 열거형
///
/// 지출 발생 시 사용된 결제 수단(현금, 카드 등)을 정의합니다.
/// 백엔드 통신을 위한 [code]와 UI 표시를 위한 [label]을 제공합니다.
///
/// **주요 기능:**
/// - [code]: 서버와 통신 시 사용하는 코드값 (예: 'CARD')
/// - [label]: 화면에 표시되는 사용자 친화적 텍스트 (예: '카드')
/// - [fromCode]: 문자열 코드를 Enum으로 변환하는 팩토리 메서드
///
/// **사용 예시:**
/// ```dart
/// final method = PaymentMethod.fromCode('CARD');
/// print(method.label); // '카드'
/// ```
enum PaymentMethod {
  cash('CASH', '현금'),
  card('CARD', '카드');

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
