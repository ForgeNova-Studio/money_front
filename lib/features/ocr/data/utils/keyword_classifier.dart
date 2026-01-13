import '../../domain/entities/category.dart';

/// 상호명 키워드 기반 카테고리 분류기
///
/// 브랜드 매칭 실패 시 상호명의 키워드를 분석하여 카테고리 추론
/// 예: "원천주유소" → "주유" 키워드 → TRANSPORT
class KeywordClassifier {
  /// 키워드-카테고리 매핑 테이블
  /// 우선순위: 더 구체적인 키워드가 먼저 매칭되도록 정렬
  static const Map<String, Category> _keywordMap = {
    // ─────────────────────────────────────────────────────
    // 식비 (FOOD)
    // ─────────────────────────────────────────────────────
    '이츠': Category.food,        // 쿠팡이츠, 요기요이츠
    '배민': Category.food,        // 배달의민족
    '요기요': Category.food,
    '배달': Category.food,
    '식당': Category.food,
    '음식점': Category.food,
    '한식': Category.food,
    '중식': Category.food,
    '일식': Category.food,
    '양식': Category.food,
    '분식': Category.food,
    '치킨': Category.food,
    '피자': Category.food,
    '햄버거': Category.food,
    '버거': Category.food,
    '족발': Category.food,
    '보쌈': Category.food,
    '찜닭': Category.food,
    '곱창': Category.food,
    '삼겹살': Category.food,
    '고기집': Category.food,
    '정육': Category.food,

    // ─────────────────────────────────────────────────────
    // 카페/간식 (CAFE_SNACK)
    // ─────────────────────────────────────────────────────
    '카페': Category.cafeSnack,
    '커피': Category.cafeSnack,
    '베이커리': Category.cafeSnack,
    '빵집': Category.cafeSnack,
    '제과': Category.cafeSnack,
    '디저트': Category.cafeSnack,
    '아이스크림': Category.cafeSnack,
    '떡집': Category.cafeSnack,
    '도넛': Category.cafeSnack,

    // ─────────────────────────────────────────────────────
    // 교통 (TRANSPORT)
    // ─────────────────────────────────────────────────────
    '주유': Category.transport,     // 주유소
    '주차': Category.transport,
    '택시': Category.transport,
    'ktx': Category.transport,
    'srt': Category.transport,
    '고속': Category.transport,     // 고속버스
    '버스터미널': Category.transport,
    '톨게이트': Category.transport,
    '하이패스': Category.transport,
    '카카오t': Category.transport,
    '타다': Category.transport,
    '쏘카': Category.transport,
    '그린카': Category.transport,
    '렌트': Category.transport,

    // ─────────────────────────────────────────────────────
    // 주거 (HOUSING)
    // ─────────────────────────────────────────────────────
    '월세': Category.housing,
    '관리비': Category.housing,
    '전기세': Category.housing,
    '수도세': Category.housing,
    '가스비': Category.housing,
    '도시가스': Category.housing,
    '한전': Category.housing,
    '수도사업소': Category.housing,

    // ─────────────────────────────────────────────────────
    // 통신/인터넷 (COMMUNICATION)
    // ─────────────────────────────────────────────────────
    '알림서비스': Category.communication,
    '통신': Category.communication,
    '휴대폰': Category.communication,
    '핸드폰': Category.communication,
    'kt': Category.communication,
    'skt': Category.communication,
    'lg유플러스': Category.communication,
    '인터넷': Category.communication,
    'iptv': Category.communication,

    // ─────────────────────────────────────────────────────
    // 구독 (SUBSCRIPTION)
    // ─────────────────────────────────────────────────────
    '구독': Category.subscription,
    '월정액': Category.subscription,
    '이용료': Category.subscription,  // 12월이용료 같은 패턴
    '넷플릭스': Category.subscription,
    '유튜브': Category.subscription,
    '멜론': Category.subscription,
    '지니': Category.subscription,
    '벅스': Category.subscription,
    '웨이브': Category.subscription,
    '티빙': Category.subscription,
    '왓챠': Category.subscription,
    '쿠팡플레이': Category.subscription,
    '애플뮤직': Category.subscription,
    '스포티파이': Category.subscription,

    // ─────────────────────────────────────────────────────
    // 생활 (LIVING)
    // ─────────────────────────────────────────────────────
    '마트': Category.living,
    '이마트': Category.living,
    '홈플러스': Category.living,
    '롯데마트': Category.living,
    '하나로마트': Category.living,
    '편의점': Category.living,
    'gs25': Category.living,
    'cu': Category.living,
    '세븐일레븐': Category.living,
    'emart24': Category.living,
    '다이소': Category.living,
    '생활용품': Category.living,
    '세탁': Category.living,
    '클리닝': Category.living,
    '철물점': Category.living,

    // ─────────────────────────────────────────────────────
    // 쇼핑 (SHOPPING)
    // ─────────────────────────────────────────────────────
    '백화점': Category.shopping,
    '아울렛': Category.shopping,
    '의류': Category.shopping,
    '옷가게': Category.shopping,
    '신발': Category.shopping,
    '쿠팡': Category.shopping,
    '11번가': Category.shopping,
    'g마켓': Category.shopping,
    '옥션': Category.shopping,
    '네이버쇼핑': Category.shopping,
    '무신사': Category.shopping,
    '올리브영': Category.shopping,
    '화장품': Category.shopping,

    // ─────────────────────────────────────────────────────
    // 건강 (HEALTH)
    // ─────────────────────────────────────────────────────
    '병원': Category.health,
    '의원': Category.health,
    '약국': Category.health,
    '치과': Category.health,
    '안과': Category.health,
    '한의원': Category.health,
    '피부과': Category.health,
    '정형외과': Category.health,
    '헬스': Category.health,
    '피트니스': Category.health,
    '요가': Category.health,
    '필라테스': Category.health,
    '짐': Category.health,

    // ─────────────────────────────────────────────────────
    // 교육 (EDUCATION)
    // ─────────────────────────────────────────────────────
    '학원': Category.education,
    '과외': Category.education,
    '강의': Category.education,
    '교육': Category.education,
    '학교': Category.education,
    '등록금': Category.education,
    '교재': Category.education,
    '서점': Category.education,
    '교보문고': Category.education,
    '영풍문고': Category.education,
    '알라딘': Category.education,
    '예스24': Category.education,

    // ─────────────────────────────────────────────────────
    // 문화 (CULTURE)
    // ─────────────────────────────────────────────────────
    '영화': Category.culture,
    'cgv': Category.culture,
    '메가박스': Category.culture,
    '롯데시네마': Category.culture,
    '공연': Category.culture,
    '콘서트': Category.culture,
    '전시': Category.culture,
    '박물관': Category.culture,
    '미술관': Category.culture,
    '노래방': Category.culture,
    'pc방': Category.culture,
    '당구장': Category.culture,
    '볼링': Category.culture,

    // ─────────────────────────────────────────────────────
    // 보험 (INSURANCE)
    // ─────────────────────────────────────────────────────
    '보험': Category.insurance,
    '생명보험': Category.insurance,
    '화재보험': Category.insurance,
    '손해보험': Category.insurance,
    '삼성생명': Category.insurance,
    '한화생명': Category.insurance,
    'db손해보험': Category.insurance,
    '현대해상': Category.insurance,
  };

  /// 상호명에서 카테고리 추론
  ///
  /// [merchant] OCR로 인식된 상호명
  /// Returns 매칭된 카테고리, 없으면 null
  static Category? classify(String merchant) {
    if (merchant.isEmpty) return null;

    final normalized = merchant.toLowerCase().replaceAll(' ', '');

    // 키워드 순회하며 매칭
    for (final entry in _keywordMap.entries) {
      if (normalized.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return null;
  }
}
