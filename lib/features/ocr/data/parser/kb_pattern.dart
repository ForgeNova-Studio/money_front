import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// KB국민카드 OCR 패턴
///
/// **특징:**
/// - KB Pay 앱 기반
/// - 날짜 형식: 12/20, 25.12.20
/// - 결제 금액, 즉시결제, 금융 서비스 통합
/// - 카드탭에서 이용내역 확인
///
/// **예상 화면 구조:**
/// ```
/// 12/20
/// 스타벅스                 12,500원
/// 일시불
///
/// 12/19
/// 편의점                    3,500원
/// 일시불
/// ```
class KbPattern extends BaseReceiptPattern {
  @override
  String get name => 'KB국민카드';

  @override
  String get cardIssuerId => 'kb';

  @override
  List<String> get identifierKeywords => [
    'KB국민카드',
    'KB카드',
    'KB Pay',
    'KB페이',
    'KBPay',
    '국민카드',
    'KOOKMIN',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    'KB Pay',
    'LIIV',
    '리브',
    '스타뱅킹',
    'KB손해보험',
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
