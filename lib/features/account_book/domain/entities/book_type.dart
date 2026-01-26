/// 장부 유형
enum BookType {
  def('DEFAULT', '기본 가계부'),
  coupleLiving('COUPLE_LIVING', '커플 생활비'),
  trip('TRIP', '여행'),
  project('PROJECT', '프로젝트');

  final String code;
  final String label;

  const BookType(this.code, this.label);

  static BookType fromCode(String code) {
    return BookType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => BookType.coupleLiving,
    );
  }
}
