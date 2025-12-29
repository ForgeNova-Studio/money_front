import '../entities/brand_info.dart';

/// 브랜드 매칭 전략 인터페이스
///
/// Clean Architecture 원칙:
/// - domain 레이어는 외부 의존성 없음
/// - 구현체는 data 레이어에 위치
///
/// 책임:
/// - OCR로 인식된 원본 텍스트를 받아 브랜드 정보 반환
/// - 여러 전략을 조합할 수 있도록 인터페이스 제공
///
/// 구현체:
/// - FallbackBrandStrategy: 사용자 학습 + 글로벌 데이터
/// - FuzzyMatchStrategy: 유사도 기반 매칭 (Phase 2)
abstract class BrandMatchStrategy {
  /// 원본 텍스트를 받아 브랜드 정보를 반환
  ///
  /// [rawText] OCR로 인식된 원본 텍스트 (예: "수타벅스 강남R점")
  /// Returns 매칭된 브랜드 정보, 없으면 null
  ///
  /// 예시:
  /// ```dart
  /// final info = await strategy.findBrand("스타벅스 강남점");
  /// // info.name: "스타벅스"
  /// // info.category: Category.food
  /// ```
  Future<BrandInfo?> findBrand(String rawText);
}
