/// 지출 카테고리 Enum
///
/// 백엔드 CategoryClassifier.java와 동일한 구조
/// 변경 시 반드시 백엔드와 동기화 필요
enum Category {
  /// 식비 - 음식점, 카페, 편의점 등
  food('FOOD', '식비'),

  /// 교통 - 택시, 대중교통, 주유 등
  transport('TRANSPORT', '교통'),

  /// 쇼핑 - 마트, 백화점, 온라인쇼핑 등
  shopping('SHOPPING', '쇼핑'),

  /// 문화생활 - 영화, 공연, 서점 등
  culture('CULTURE', '문화생활'),

  /// 주거/통신 - 월세, 관리비, 통신비 등
  housing('HOUSING', '주거/통신'),

  /// 의료/건강 - 병원, 약국, 헬스장 등
  medical('MEDICAL', '의료/건강'),

  /// 교육 - 학원, 도서, 강의 등
  education('EDUCATION', '교육'),

  /// 경조사 - 결혼, 장례, 선물 등
  event('EVENT', '경조사'),

  /// 기타
  etc('ETC', '기타');

  /// 백엔드 API 전송용 코드
  final String code;

  /// 사용자에게 표시할 이름
  final String displayName;

  const Category(this.code, this.displayName);

  /// 백엔드 코드로부터 Enum 변환
  static Category fromCode(String code) {
    return Category.values.firstWhere(
      (c) => c.code == code,
      orElse: () => Category.etc,
    );
  }

  /// JSON 직렬화용
  String toJson() => code;
}
