import 'dart:ui';

import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';

/// 현대카드 OCR 패턴
///
/// **특징:**
/// - 현대카드 앱 기반
/// - 미니멀/심플한 디자인
/// - 날짜 형식: 12.20 (금), 2025-12-20
/// - 영문 가맹점명이 많음
/// - 소비케어 기능으로 소비 패턴 분석
///
/// **예상 화면 구조:**
/// ```
/// 12.20 금
/// STARBUCKS 강남역점      12,500원
///
/// 12.19 목
/// CU GANGNAM              3,500원
/// ```
class HyundaiPattern extends BaseReceiptPattern {
  @override
  String get name => '현대카드';

  @override
  String get cardIssuerId => 'hyundai';

  @override
  List<String> get identifierKeywords => [
    '현대카드',
    'HYUNDAI',
    'Hyundai Card',
    '현대',
  ];

  @override
  List<String> get additionalNoiseKeywords => [
    'M포인트',
    'ZERO',
    'the',
    'DIGITAL',
    '소비케어',
    'MY MENU',
  ];

  @override
  String get dateFormatHint => 'MM.DD';

  /// 현대카드는 미니멀 디자인으로 간격이 넓을 수 있음
  @override
  Rect calculateSmartZone(Rect anchor, double lineHeight) {
    return Rect.fromLTRB(
      0,
      anchor.top - (lineHeight * 2.0),
      anchor.left + 30,
      anchor.bottom + (lineHeight * 1.0),
    );
  }

  @override
  String cleanStoreName(String text) {
    String clean = super.cleanStoreName(text);

    // 현대카드 특화: 영문 가맹점명 처리
    // 대문자 영문만 있는 경우 유지
    // 예: "STARBUCKS GANGNAM" → 그대로 유지 (브랜드 매칭에서 처리)

    return clean;
  }
}
