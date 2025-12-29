import 'category.dart';

/// 브랜드 매칭 결과 객체 (DTO)
///
/// OCR로 읽은 텍스트 → 정규화된 브랜드 정보
/// 예: "수타벅스 강남R점" → BrandInfo("스타벅스", Category.food)
class BrandInfo {
  /// 정규화된 브랜드명 (예: 스타벅스, GS25, 이마트)
  final String name;

  /// 자동 분류된 카테고리
  final Category category;

  /// 신뢰도 점수 (0.0 ~ 1.0)
  /// - 1.0: 완전 일치 (GlobalBrandSource)
  /// - 0.8~1.0: 사용자 학습 데이터 (UserBrandSource)
  /// - 0.6~0.8: Fuzzy Matching (Phase 2)
  final double confidence;

  BrandInfo({
    required this.name,
    required this.category,
    this.confidence = 1.0,
  });

  @override
  String toString() => 'BrandInfo(name: $name, category: ${category.displayName}, confidence: $confidence)';
}
