/// 문자열 유사도 계산 유틸리티
///
/// Levenshtein Distance 알고리즘을 사용하여
/// 두 문자열 간의 편집 거리를 계산합니다.
///
/// 용도:
/// - OCR 오타 보정 ("서타벅스" → "스타벅스")
/// - 사용자 학습 데이터 유연 매칭 ("철수네미용슬" → "철수네미용실")
///
/// 특징:
/// - 자동 전처리 (공백/특수문자 제거, 소문자 변환)
/// - 짧은 단어 방어 로직 (2글자 이하는 정확 일치만)
/// - 동적 threshold (문자열 길이 기반)
class StringSimilarity {
  /// 텍스트 정규화 (전처리)
  ///
  /// 1. 공백 제거: "스타 벅스" → "스타벅스"
  /// 2. 소문자 변환: "Starbucks" → "starbucks"
  /// 3. 특수문자 제거: "(주)스타벅스" → "스타벅스"
  ///
  /// ⚠️ 필수: Levenshtein 비교 전에 반드시 정규화 필요
  static String normalize(String text) {
    return text
        .replaceAll(' ', '')                    // 공백 제거
        .toLowerCase()                          // 소문자 변환
        .replaceAll(RegExp(r'[^\w가-힣]'), ''); // 특수문자 제거 (한글/영문/숫자만 유지)
  }

  /// Levenshtein Distance 계산 (편집 거리)
  ///
  /// 한 문자열을 다른 문자열로 변환하는데 필요한
  /// 최소 편집 횟수 (삽입/삭제/교체)
  ///
  /// 예시:
  /// - levenshtein("스타벅스", "서타벅스") → 1 (1글자 교체)
  /// - levenshtein("카페", "카카오") → 2 (2글자 교체)
  ///
  /// ⚠️ 주의: 이 함수는 정규화를 수행하지 않습니다.
  /// normalize()로 전처리 후 호출하세요.
  ///
  /// 시간 복잡도: O(m * n)
  /// 공간 복잡도: O(m) - 최적화된 1차원 배열 사용
  static int levenshtein(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    // 공간 최적화: 2차원 배열 대신 1차원 배열 사용
    List<int> previousRow = List.generate(s2.length + 1, (i) => i);

    for (int i = 0; i < s1.length; i++) {
      List<int> currentRow = [i + 1];

      for (int j = 0; j < s2.length; j++) {
        int insertCost = currentRow[j] + 1;
        int deleteCost = previousRow[j + 1] + 1;
        int replaceCost = previousRow[j] + (s1[i] == s2[j] ? 0 : 1);

        currentRow.add([insertCost, deleteCost, replaceCost].reduce((a, b) => a < b ? a : b));
      }

      previousRow = currentRow;
    }

    return previousRow.last;
  }

  /// 유사도 점수 계산 (0.0 ~ 1.0)
  ///
  /// 1.0 = 완전히 동일
  /// 0.0 = 완전히 다름
  ///
  /// 예시:
  /// - similarity("스타벅스", "스타벅스") → 1.0
  /// - similarity("스타벅스", "서타벅스") → 0.75 (4글자 중 1글자 다름)
  /// - similarity("카페", "카카오") → 0.33 (3글자 중 2글자 다름)
  ///
  /// ⚠️ 자동 정규화: 이 함수는 내부에서 normalize() 호출
  static double similarity(String s1, String s2) {
    String norm1 = normalize(s1);
    String norm2 = normalize(s2);

    if (norm1 == norm2) return 1.0;
    if (norm1.isEmpty || norm2.isEmpty) return 0.0;

    int maxLength = norm1.length > norm2.length ? norm1.length : norm2.length;
    int distance = levenshtein(norm1, norm2);

    return 1.0 - (distance / maxLength);
  }

  /// 동적 Threshold 계산
  ///
  /// 문자열 길이에 따라 적절한 threshold 반환
  ///
  /// 규칙:
  /// - 1-2글자: 0 (정확 일치만, 예: "CU", "KT" 등 짧은 브랜드)
  /// - 3-4글자: 1
  /// - 5-8글자: 2
  /// - 9+ 글자: 3
  ///
  /// ⚠️ 짧은 단어 방어 로직:
  /// 2글자 이하는 threshold=0으로 오타 허용 안 함
  /// (예: "CU" → "GU"는 완전히 다른 브랜드)
  static int dynamicThreshold(String text) {
    int length = normalize(text).length;

    if (length <= 2) return 0; // 짧은 단어: 정확 일치만
    if (length <= 4) return 1;
    if (length <= 8) return 2;
    return 3;
  }

  /// Fuzzy Match 여부 판단 (자동 전처리 + 동적 threshold)
  ///
  /// 가장 추천하는 메서드 - 모든 로직 자동 처리:
  /// 1. 자동 정규화
  /// 2. 동적 threshold 계산
  /// 3. 짧은 단어 방어
  ///
  /// 예시:
  /// ```dart
  /// isSimilar("스타 벅스", "(주)서타벅스") → true (정규화 후 distance=1)
  /// isSimilar("CU", "GU") → false (짧은 단어: threshold=0)
  /// isSimilar("철수네미용실", "철수네미용슬") → true (distance=1)
  /// ```
  static bool isSimilar(String s1, String s2) {
    String norm1 = normalize(s1);
    String norm2 = normalize(s2);

    // 정확 일치
    if (norm1 == norm2) return true;

    // 동적 threshold 계산 (더 긴 문자열 기준)
    int threshold = dynamicThreshold(norm1.length > norm2.length ? norm1 : norm2);

    // Levenshtein 거리 비교
    return levenshtein(norm1, norm2) <= threshold;
  }

  /// Fuzzy Match 여부 판단 (수동 threshold)
  ///
  /// threshold를 직접 지정하고 싶을 때 사용
  ///
  /// 예시:
  /// ```dart
  /// isSimilarWithThreshold("스타벅스", "서타벅스", threshold: 1) → true
  /// isSimilarWithThreshold("카페", "카카오", threshold: 1) → false (distance=2)
  /// ```
  static bool isSimilarWithThreshold(String s1, String s2, {required int threshold}) {
    String norm1 = normalize(s1);
    String norm2 = normalize(s2);

    if (norm1 == norm2) return true;

    return levenshtein(norm1, norm2) <= threshold;
  }
}
