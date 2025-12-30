import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../../../domain/entities/brand_info.dart';
import '../../../domain/entities/category.dart';
import '../../utils/string_similarity.dart';

/// 사용자 학습 브랜드 데이터 소스 (Hive 로컬 DB)
///
/// 책임:
/// - 사용자가 수정한 브랜드명/카테고리 저장
/// - 사용자 학습 데이터 우선 검색
/// - Fuzzy Matching을 통한 유연한 인식
///
/// 매칭 전략:
/// 1. 정확 일치 - confidence: 0.95
/// 2. Fuzzy 일치 (Levenshtein) - confidence: 0.8-0.9
///
/// 특징:
/// - Hive Box를 1회만 열기 (성능 최적화)
/// - 사용자 데이터는 GlobalBrand보다 우선
/// - 개인 가게명 변형 허용 ("철수네미용슬" → "철수네미용실")
/// - 오프라인 동작
///
/// 예시:
/// ```dart
/// // 사용자가 "수타벅스" → "스타벅스"로 수정
/// await userSource.learn("수타벅스 강남점", "스타벅스", Category.food);
///
/// // 다음부터 자동 인식 (정확 일치)
/// final info = await userSource.find("수타벅스 강남점");
/// // info.name: "스타벅스", confidence: 0.95
///
/// // Fuzzy 매칭도 가능
/// final fuzzy = await userSource.find("수타벅슨 강남점");
/// // fuzzy.name: "스타벅스", confidence: 0.85
/// ```
class UserBrandSource {
  static const String boxName = 'user_brands';
  final _logger = Logger();

  late Box _box;
  bool _initialized = false;

  /// Hive Box 초기화 (앱 시작 시 1회만 호출)
  Future<void> init() async {
    if (_initialized) return;

    try {
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('📚 UserBrandSource 초기화 시작');

      _box = await Hive.openBox(boxName);

      _initialized = true;
      _logger.i('✅ UserBrandSource 초기화 완료');
      _logger.d('   저장된 학습 데이터 수: ${_box.length}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e, stackTrace) {
      _logger.e('UserBrandSource 초기화 실패', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 사용자 학습 데이터 조회 (Fuzzy Matching 지원)
  ///
  /// [rawText] OCR 원본 텍스트
  /// Returns 학습된 브랜드 정보, 없으면 null
  ///
  /// 검색 우선순위:
  /// 1. 정확 일치 - confidence: 0.95
  /// 2. Fuzzy 매칭 (Levenshtein) - confidence: 0.8-0.9
  ///
  /// 예시:
  /// - "철수네미용실 강남점" → 정확 일치 (confidence: 0.95)
  /// - "철수네미용슬 강남점" → Fuzzy 일치 (confidence: 0.85)
  Future<BrandInfo?> find(String rawText) async {
    if (!_initialized) {
      _logger.w('⚠️ UserBrandSource가 초기화되지 않았습니다');
      return null;
    }

    final normalized = StringSimilarity.normalize(rawText);

    // 🔍 1단계: 정확 일치 (Exact Match)
    if (_box.containsKey(normalized)) {
      final data = _box.get(normalized) as Map;
      _logger.d('🎯 [정확] UserBrand 매칭: "${data['name']}" (학습 데이터)');

      return BrandInfo(
        name: data['name'],
        category: Category.values[data['catIdx']],
        confidence: 0.95, // 정확 일치
      );
    }

    // 🔍 2단계: Fuzzy Matching (Levenshtein Distance)
    _FuzzyMatch? bestMatch;

    for (var key in _box.keys) {
      final storedKey = key.toString();

      // Fuzzy 유사도 검사
      if (StringSimilarity.isSimilar(normalized, storedKey)) {
        final similarity = StringSimilarity.similarity(normalized, storedKey);

        // 가장 유사도가 높은 것 선택
        if (bestMatch == null || similarity > bestMatch.similarity) {
          final data = _box.get(storedKey) as Map;
          bestMatch = _FuzzyMatch(
            name: data['name'],
            category: Category.values[data['catIdx']],
            storedKey: storedKey,
            similarity: similarity,
          );
        }
      }
    }

    // Fuzzy 매칭 결과 반환
    if (bestMatch != null) {
      // Confidence: 0.8 ~ 0.9 범위로 매핑
      final confidence = 0.8 + (bestMatch.similarity * 0.1);

      _logger.d('🔍 [Fuzzy] UserBrand 매칭: "${bestMatch.name}" '
          '(저장된 키: ${bestMatch.storedKey}, 유사도: ${bestMatch.similarity.toStringAsFixed(2)})');

      return BrandInfo(
        name: bestMatch.name,
        category: bestMatch.category,
        confidence: confidence,
      );
    }

    return null;
  }

  /// 사용자 학습 데이터 저장
  ///
  /// UI에서 사용자가 브랜드명/카테고리를 수정했을 때 호출
  ///
  /// [rawText] OCR 원본 텍스트 (예: "수타벅스 강남점")
  /// [name] 정규화된 브랜드명 (예: "스타벅스")
  /// [category] 카테고리
  Future<void> learn(String rawText, String name, Category category) async {
    if (!_initialized) {
      _logger.w('⚠️ UserBrandSource가 초기화되지 않았습니다');
      return;
    }

    final key = StringSimilarity.normalize(rawText);

    await _box.put(key, {
      'name': name,
      'catIdx': category.index,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _logger.i('✅ 사용자 학습 데이터 저장: "$rawText" → "$name" (${category.displayName})');
  }

  /// 학습 데이터 삭제
  Future<void> forget(String rawText) async {
    if (!_initialized) return;

    final key = StringSimilarity.normalize(rawText);
    await _box.delete(key);
    _logger.i('🗑️ 사용자 학습 데이터 삭제: "$rawText"');
  }

  /// 전체 학습 데이터 초기화
  Future<void> clearAll() async {
    if (!_initialized) return;

    await _box.clear();
    _logger.i('🗑️ 모든 사용자 학습 데이터 삭제');
  }

  /// 리소스 정리
  Future<void> dispose() async {
    if (_initialized) {
      await _box.close();
      _initialized = false;
      _logger.d('UserBrandSource 종료');
    }
  }
}

/// Fuzzy 매칭 결과 (내부용)
class _FuzzyMatch {
  final String name;
  final Category category;
  final String storedKey;
  final double similarity;

  _FuzzyMatch({
    required this.name,
    required this.category,
    required this.storedKey,
    required this.similarity,
  });
}
