import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// 삼성카드 OCR 패턴
///
/// **특징:**
/// - 삼성카드 앱 기반
/// - 카드 이미지 중심의 UI
/// - 날짜 형식: 12.20(금), 2025.12.20
/// - MY 섹션에서 이용내역 확인
///
/// **예상 화면 구조:**
/// ```
/// 12.20 (금)
/// 스타벅스코리아         12,500원
/// 일시불
///
/// 12.19 (목)
/// GS25 강남점            3,500원
/// 일시불
/// ```
class SamsungPattern extends BaseReceiptPattern {
  @override
  String get name => '삼성카드';

  @override
  String get cardIssuerId => 'samsung';

  @override
  List<String> get identifierKeywords => [
    '삼성카드',
    'SAMSUNG',
    'Samsung Card',
    '삼성',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    'taptap',
    'LINK',
    '삼성페이',
    'Samsung Pay',
    '디지털',
    'iD',
  ];

  @override
  String get dateFormatHint => 'MM.DD';

  /// 삼성카드는 비교적 정렬된 레이아웃
  @override
  Rect calculateSmartZone(Rect anchor, double lineHeight) {
    return Rect.fromLTRB(
      0,
      anchor.top - (lineHeight * 2.5),
      anchor.left + 30,
      anchor.bottom + (lineHeight * 1.5),
    );
  }

  @override
  String cleanStoreName(String text) {
    String clean = super.cleanStoreName(text);

    // 삼성카드 특화: 영문 브랜드명 정리
    // 예: "STARBUCKS KOREA" → "스타벅스"는 브랜드 매칭에서 처리

    return clean;
  }
}
