class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력하세요';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    if (value.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다';
    }
    return null;
  }

  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력하세요';
    }
    if (value.length < 2) {
      return '닉네임은 2자 이상이어야 합니다';
    }
    if (value.length > 50) {
      return '닉네임은 50자 이하여야 합니다';
    }
    return null;
  }
}
