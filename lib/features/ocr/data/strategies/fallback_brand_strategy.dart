import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../domain/strategies/brand_match_strategy.dart';
import '../../domain/entities/brand_info.dart';
import '../../domain/entities/category.dart' as ocr;
import '../datasources/local/user_brand_source.dart';
import '../datasources/memory/global_brand_source.dart';
import '../utils/keyword_classifier.dart';

/// 하이브리드 브랜드 매칭 전략
///
/// 책임:
/// - 사용자 학습 데이터 우선 검색
/// - 글로벌 브랜드 데이터 2차 검색
/// - 키워드 기반 카테고리 추론 3차 검색
/// - 3단계 Fallback 전략
///
/// 우선순위:
/// 1. UserBrandSource (사용자 학습 데이터) - 개인화
/// 2. GlobalBrandSource (앱 내장 데이터) - 기본
/// 3. KeywordClassifier (키워드 분석) - 폴백
///
/// 특징:
/// - 오프라인 동작
/// - 실시간 학습 반영
/// - 백엔드 호출 불필요
class FallbackBrandStrategy implements BrandMatchStrategy {
  final UserBrandSource _userSource;
  final GlobalBrandSource _globalSource;
  final _logger = Logger(level: kDebugMode ? Level.debug : Level.off);

  FallbackBrandStrategy({
    required UserBrandSource userSource,
    required GlobalBrandSource globalSource,
  })  : _userSource = userSource,
        _globalSource = globalSource;

  @override
  Future<BrandInfo?> findBrand(String rawText) async {
    _logger.d('🔍 브랜드 검색 시작: "$rawText"');

    // 🚀 1순위: 사용자 개인 학습 데이터 (Override)
    final userInfo = await _userSource.find(rawText);
    if (userInfo != null) {
      _logger.i('✅ [사용자 학습] ${userInfo.name} (${userInfo.category.displayName})');
      return userInfo;
    }

    // 🚀 2순위: 앱 내장 글로벌 데이터 (Default)
    final globalInfo = _globalSource.find(rawText);
    if (globalInfo != null) {
      _logger.i('✅ [글로벌 데이터] ${globalInfo.name} (${globalInfo.category.displayName})');
      return globalInfo;
    }

    // 🚀 3순위: 키워드 기반 카테고리 추론 (Fallback)
    final keywordCategory = KeywordClassifier.classify(rawText);
    if (keywordCategory != null) {
      _logger.i('✅ [키워드 분류] $rawText → ${keywordCategory.displayName}');
      return BrandInfo(
        name: rawText,  // 원본 상호명 그대로 사용
        category: keywordCategory,
        confidence: 0.7,  // 키워드 매칭은 낮은 신뢰도
      );
    }

    // ❌ 매칭 실패 - 미분류로 반환
    _logger.d('❌ 브랜드 매칭 실패: "$rawText" → 미분류');
    return BrandInfo(
      name: rawText,
      category: ocr.Category.uncategorized,
      confidence: 0.0,
    );
  }

  /// 사용자 학습 데이터 저장 (Proxy 메서드)
  ///
  /// UI에서 직접 호출:
  /// ```dart
  /// await strategy.learn("수타벅스 강남점", "스타벅스", Category.food);
  /// ```
  Future<void> learn(String rawText, String name, category) async {
    await _userSource.learn(rawText, name, category);
  }

  /// 학습 데이터 삭제
  Future<void> forget(String rawText) async {
    await _userSource.forget(rawText);
  }

  /// 전체 학습 데이터 초기화
  Future<void> clearAll() async {
    await _userSource.clearAll();
  }
}
