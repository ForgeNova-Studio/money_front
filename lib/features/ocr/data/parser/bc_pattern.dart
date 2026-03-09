import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// BC카드 OCR 패턴
///
/// **특징:**
/// - 페이북(PayBooc) 앱 기반
/// - 날짜 형식: 12/20, 25.12.20
/// - 제휴 은행 카드 통합 관리
///
/// **예상 화면 구조:**
/// ```
/// 12/20
/// 스타벅스                 12,500원
/// 일시불
///
/// 12/19
/// GS25                      3,500원
/// 일시불
/// ```
class BcPattern extends BaseReceiptPattern {
  @override
  String get name => 'BC카드';

  @override
  String get cardIssuerId => 'bc';

  @override
  List<String> get identifierKeywords => [
    'BC카드',
    '비씨카드',
    'BC CARD',
    '페이북',
    'PayBooc',
    'BC',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    '페이북',
    'PayBooc',
    'TOP포인트',
    'BC포인트',
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
