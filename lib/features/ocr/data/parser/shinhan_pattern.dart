import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// 신한카드 OCR 패턴
///
/// **특징:**
/// - SOL페이 앱 기반
/// - 날짜 형식: 25.12.20(토), 12/20
/// - 타임라인 형식의 이용내역 표시
/// - 카드별, 기간별 필터링 UI
///
/// **예상 화면 구조:**
/// ```
/// 25. 12. 20 (토)
/// ━━━━━━━━━━━━━━━
/// 스타벅스 강남R점     -12,500원
/// 일시불
/// ━━━━━━━━━━━━━━━
/// CU 편의점 강남점     -3,500원
/// 일시불
/// ```
class ShinhanPattern extends BaseReceiptPattern {
  @override
  String get name => '신한카드';

  @override
  String get cardIssuerId => 'shinhan';

  @override
  List<String> get identifierKeywords => [
    '신한카드',
    'SOL페이',
    '신한',
    'SHINHAN',
    'Sol페이',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    'SOL',
    '신한Pay머니',
    '마이신한포인트',
    'MY신한포인트',
    '터치결제',
  ];

  @override
  String get dateFormatHint => 'YY.MM.DD';

  /// 신한카드는 날짜 헤더 아래에 여러 거래가 묶이는 형식
  /// 따라서 위로 더 넓은 범위를 검색
  @override
  Rect calculateSmartZone(Rect anchor, double lineHeight) {
    return Rect.fromLTRB(
      0,
      anchor.top - (lineHeight * 3.0), // 위로 3줄
      anchor.left + 20,
      anchor.bottom + (lineHeight * 1.5),
    );
  }
}
