/// 성별 열거형 (Enum)
///
/// 사용자의 성별 정보를 정의합니다.
///
/// **종류 (Values):**
/// - [male]: 남성
/// - [female]: 여성
/// - [other]: 기타
enum Gender {
  male,
  female,
  other;

  /// 서버 전송용 문자열 변환
  ///
  /// - [male] -> 'MALE'
  /// - [female] -> 'FEMALE'
  /// - [other] -> 'OTHER'
  String toServerString() {
    switch (this) {
      case Gender.male:
        return 'MALE';
      case Gender.female:
        return 'FEMALE';
      case Gender.other:
        return 'OTHER';
    }
  }
}
