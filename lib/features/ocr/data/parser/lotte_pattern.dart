import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// 롯데카드 OCR 패턴
///
/// **특징:**
/// - 롯데카드 앱 기반
/// - 날짜 형식: 12/20, 2025.12.20
/// - 매출일자, 매출금액, 가맹점명 표시
/// - 국내외 이용내역 일시불/할부 조회
///
/// **예상 화면 구조:**
/// ```
/// 12/20
/// 스타벅스                 12,500원
/// 일시불
///
/// 12/19
/// 세븐일레븐               3,500원
/// 일시불
/// ```
class LottePattern extends BaseReceiptPattern {
  @override
  String get name => '롯데카드';

  @override
  String get cardIssuerId => 'lotte';

  @override
  List<String> get identifierKeywords => [
    '롯데카드',
    'LOTTE',
    'Lotte Card',
    '롯데',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    'L.POINT',
    'L포인트',
    '롯데멤버스',
    '엘포인트',
    '롯데온',
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
