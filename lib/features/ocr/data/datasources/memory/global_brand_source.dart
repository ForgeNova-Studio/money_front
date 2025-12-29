import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../../../domain/entities/brand_info.dart';
import '../../../domain/entities/category.dart';
import '../../utils/string_similarity.dart';

/// 글로벌 브랜드 데이터 소스 (앱 내장)
///
/// 책임:
/// - assets/data/brands.json 파일 로드 및 파싱
/// - 메이저 브랜드 키워드 매칭 (정확 + Fuzzy)
///
/// 특징:
/// - Provider/Main에서 initialize() 호출로 데이터 로드
/// - JSON 카테고리 문자열("CAFE")과 Enum(Category.cafe) 간의 유연한 매핑
/// - StringSimilarity 유틸을 활용한 오타 보정
class GlobalBrandSource {
  final _logger = Logger();

  // 검색 속도를 위한 메모리 캐시 (Key: 정규화된 키워드)
  final Map<String, _BrandData> _brandMap = {};

  /// JSON 파일 로드 및 초기화
  ///
  /// 앱 시작 시(main.dart) 또는 Provider 생성 시 호출
  Future<void> initialize() async {
    try {
      _logger.d(' GlobalBrandSource 데이터 로딩 시작...');

      final jsonString = await rootBundle.loadString('assets/data/brands.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final List<dynamic> brands = json['brands'];

      _brandMap.clear(); // 재초기화 대비

      for (var brandData in brands) {
        final keywords = List<String>.from(brandData['keywords']);
        final name = brandData['name'];
        final categoryCode = brandData['category'];

        // 🛡️ 카테고리 매핑 강화 (대소문자 무시)
        // JSON이 "CAFE"든 "Cafe"든 상관없이 Category.cafe로 매핑
        final category = Category.values.firstWhere(
              (e) => e.name.toUpperCase() == categoryCode.toString().toUpperCase(),
          orElse: () => Category.etc, // 매칭 실패 시 '기타'로 처리 (Category Enum에 맞춰 수정 필요)
        );

        final data = _BrandData(name: name, category: category);

        // 각 키워드를 Map에 등록
        for (var keyword in keywords) {
          // 전처리 (공백 제거, 소문자 변환 등 StringSimilarity 내부 로직 사용 권장)
          // 만약 normalize가 없다면: keyword.replaceAll(' ', '').toLowerCase()
          final key = StringSimilarity.normalize(keyword);
          _brandMap[key] = data;
        }
      }

      _logger.i(' GlobalBrandSource 초기화 완료 (등록된 키워드: ${_brandMap.length}개)');
    } catch (e, stackTrace) {
      _logger.e('GlobalBrandSource 초기화 실패', error: e, stackTrace: stackTrace);
      // 실패해도 앱이 죽지 않도록 예외를 삼키거나, 필요시 rethrow
    }
  }

  /// 브랜드 검색 (Fuzzy Matching 지원)
  ///
  /// [rawText] OCR 원본 텍스트
  /// Returns 매칭된 브랜드 정보, 없으면 null
  BrandInfo? find(String rawText) {
    if (_brandMap.isEmpty) {
      _logger.w(' GlobalBrandSource 데이터가 비어있습니다. initialize()가 호출되었는지 확인하세요.');
      return null;
    }

    // 입력값 전처리
    final normalized = StringSimilarity.normalize(rawText);

    //  1단계: 정확 일치 (Exact Match via contains)
    // "스타벅스 강남점" -> "스타벅스" 키워드 포함 확인
    for (var entry in _brandMap.entries) {
      if (normalized.contains(entry.key)) {
        _logger.d(' [정확] GlobalBrand 매칭: "${entry.value.name}" (키워드: ${entry.key})');
        return BrandInfo(
          name: entry.value.name,
          category: entry.value.category,
          confidence: 1.0,
        );
      }
    }

    //  2단계: Fuzzy Matching (Levenshtein Distance)
    // "서타벅스" -> "스타벅스" 찾기
    _FuzzyMatch? bestMatch;

    for (var entry in _brandMap.entries) {
      final keyword = entry.key;

      // 키워드 길이 차이가 너무 크면 스킵 (최적화)
      if ((normalized.length - keyword.length).abs() > 3) continue;

      // Fuzzy 유사도 검사
      // dynamicThreshold 등을 내부적으로 사용하여 true/false 판단
      if (StringSimilarity.isSimilar(normalized, keyword)) {
        final similarity = StringSimilarity.similarity(normalized, keyword);

        // 가장 유사도가 높은 것 선택
        if (bestMatch == null || similarity > bestMatch.similarity) {
          bestMatch = _FuzzyMatch(
            brandData: entry.value,
            keyword: keyword,
            similarity: similarity,
          );
        }
      }
    }

    // Fuzzy 매칭 결과 반환
    if (bestMatch != null) {
      // Confidence: 0.7 ~ 0.9 범위로 매핑
      final confidence = 0.7 + (bestMatch.similarity * 0.2);

      _logger.d(' [Fuzzy] GlobalBrand 매칭: "${bestMatch.brandData.name}" '
          '(키워드: ${bestMatch.keyword}, 유사도: ${(bestMatch.similarity * 100).toStringAsFixed(1)}%)');

      return BrandInfo(
        name: bestMatch.brandData.name,
        category: bestMatch.brandData.category,
        confidence: confidence,
      );
    }

    return null;
  }
}

/// 내부 브랜드 데이터 클래스 (DTO)
class _BrandData {
  final String name;
  final Category category;

  _BrandData({required this.name, required this.category});
}

/// Fuzzy 매칭 결과 (내부 계산용)
class _FuzzyMatch {
  final _BrandData brandData;
  final String keyword;
  final double similarity;

  _FuzzyMatch({
    required this.brandData,
    required this.keyword,
    required this.similarity,
  });
}