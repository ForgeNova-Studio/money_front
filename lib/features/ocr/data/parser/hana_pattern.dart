import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// 하나카드 OCR 패턴
///
/// **특징:**
/// - 하나Pay 앱 기반
/// - 날짜 형식: 12/20, 25.12.20
/// - 명세서, 보유카드, 이용내역 한눈에 확인
/// - 국내/해외 결제 화면 분리
///
/// **예상 화면 구조:**
/// ```
/// 12/20
/// 스타벅스강남R점         12,500원
/// 일시불
///
/// 12/19
/// 이마트24                 3,500원
/// 일시불
/// ```
class HanaPattern extends BaseReceiptPattern {
  @override
  String get name => '하나카드';

  @override
  String get cardIssuerId => 'hana';

  @override
  List<String> get identifierKeywords => [
    '하나카드',
    '하나Pay',
    'HANA',
    'Hana Card',
    '하나',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    '하나Pay',
    '하나머니',
    '1Q페이',
    '하나멤버스',
  ];

  @override
  String get dateFormatHint => 'MM/DD';

  @override
  Rect calculateSmartZone(Rect anchor, double lineHeight) {
    return Rect.fromLTRB(
      0,
      anchor.top - (lineHeight * 2.5),
      anchor.left + 25,
      anchor.bottom + (lineHeight * 1.5),
    );
  }
}
