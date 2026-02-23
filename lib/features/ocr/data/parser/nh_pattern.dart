import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// NH농협카드 OCR 패턴
///
/// **특징:**
/// - NH올원뱅크/NH스마트뱅킹 기반
/// - 날짜 형식: 12/20, 25.12.20
/// - 농협은행 통합 금융 서비스
///
/// **예상 화면 구조:**
/// ```
/// 12/20
/// 스타벅스                 12,500원
/// 일시불
///
/// 12/19
/// 미니스톱                  3,500원
/// 일시불
/// ```
class NhPattern extends BaseReceiptPattern {
  @override
  String get name => 'NH농협카드';

  @override
  String get cardIssuerId => 'nh';

  @override
  List<String> get identifierKeywords => [
    'NH농협카드',
    'NH카드',
    '농협카드',
    'NH올원',
    '농협',
    'NONGHYUP',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    'NH올원뱅크',
    'NH스마트뱅킹',
    'NH페이',
    '올원페이',
    '농협은행',
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
