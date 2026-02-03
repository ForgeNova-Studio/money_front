/// 관리자 설정
/// 관리자 계정 목록을 유연하게 관리할 수 있습니다.
class AdminConfig {
  /// 관리자 이메일 목록
  static const List<String> adminEmails = [
    'hanwoolc95@gmail.com',
    'th82602662@gmail.com',
    'th8260@naver.com',
  ];

  /// 해당 이메일이 관리자인지 확인
  static bool isAdmin(String? email) {
    if (email == null || email.isEmpty) return false;
    return adminEmails.contains(email.toLowerCase());
  }
}
