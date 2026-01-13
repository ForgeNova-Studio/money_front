/// 지출 카테고리 Enum
///
/// 기본 카테고리 12개 + 시스템 카테고리 (미분류)
/// Backend CategoryClassifier.java와 동기화 필요
enum Category {
  /// 식비 - 음식점, 배달음식 등
  food('FOOD', '식비', '🍚', 'EF6C00'),

  /// 카페/간식 - 카페, 베이커리, 디저트
  cafeSnack('CAFE_SNACK', '카페/간식', '☕', '8D6E63'),

  /// 교통 - 택시, 대중교통, 주유, 주차
  transport('TRANSPORT', '교통', '🚗', '1E88E5'),

  /// 주거 - 월세, 관리비, 전기, 가스, 수도
  housing('HOUSING', '주거', '🏠', '546E7A'),

  /// 통신/인터넷 - 휴대폰, 인터넷, 알림서비스
  communication('COMMUNICATION', '통신/인터넷', '📶', '3949AB'),

  /// 구독 - 넷플릭스, 유튜브, 멜론 등
  subscription('SUBSCRIPTION', '구독', '🔁', '7E57C2'),

  /// 생활 - 마트, 편의점, 생활용품
  living('LIVING', '생활', '🛒', '43A047'),

  /// 쇼핑 - 백화점, 의류, 온라인쇼핑
  shopping('SHOPPING', '쇼핑', '🛍️', 'EC407A'),

  /// 건강 - 병원, 약국, 헬스장
  health('HEALTH', '건강', '💊', 'E53935'),

  /// 교육 - 학원, 강의, 도서
  education('EDUCATION', '교육', '📚', '5C6BC0'),

  /// 문화 - 영화, 공연, 전시
  culture('CULTURE', '문화', '🎬', '8E24AA'),

  /// 보험 - 생명보험, 자동차보험 등
  insurance('INSURANCE', '보험', '🛡️', '00897B'),

  /// 미분류 - 자동 분류 실패 시
  uncategorized('UNCATEGORIZED', '미분류', '❓', '9E9E9E');

  /// 백엔드 API 전송용 코드
  final String code;

  /// 사용자에게 표시할 이름
  final String displayName;

  /// 아이콘 (Emoji)
  final String icon;

  /// 색상 (Hex, # 제외)
  final String color;

  const Category(this.code, this.displayName, this.icon, this.color);

  /// 백엔드 코드로부터 Enum 변환
  static Category fromCode(String? code) {
    if (code == null) return Category.uncategorized;
    return Category.values.firstWhere(
      (c) => c.code == code,
      orElse: () => Category.uncategorized,
    );
  }

  /// JSON 직렬화용
  String toJson() => code;
}
