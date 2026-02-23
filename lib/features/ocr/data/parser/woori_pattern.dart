import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// 우리카드 OCR 패턴
///
/// **특징:**
/// - 우리카드 앱/우리WON뱅킹 기반
/// - 날짜 형식: 12/20, 25.12.20
/// - 우리은행 통합 금융 서비스
///
/// **예상 화면 구조:**
/// ```
/// 12/20
/// 스타벅스                 12,500원
/// 일시불
///
/// 12/19
/// CU편의점                  3,500원
/// 일시불
/// ```
class WooriPattern extends BaseReceiptPattern {
  @override
  String get name => '우리카드';

  @override
  String get cardIssuerId => 'woori';

  @override
  List<String> get identifierKeywords => [
    '우리카드',
    '우리WON',
    'WOORI',
    'Woori Card',
    '우리',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    '우리WON뱅킹',
    'WON',
    '우리페이',
    '우리은행',
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
