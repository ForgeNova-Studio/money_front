/// 입력값 검증 유틸리티
///
/// 회원가입/로그인 등에서 사용하는 공통 검증 로직
class InputValidator {
  // 검증 상수
  static const int passwordMinLength = 8;
  static const int nicknameMinLength = 2;
  static const int nicknameMaxLength = 20;
  static const int verificationCodeLength = 6;

  // 정규식
  static final RegExp emailRegex =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp codeRegex = RegExp(r'^\d{6}$');
  static final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp digitRegex = RegExp(r'[0-9]');

  /// 이메일 형식 검증
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  /// 인증번호 형식 검증 (6자리 숫자)
  static bool isValidVerificationCode(String code) {
    return codeRegex.hasMatch(code);
  }

  /// 비밀번호 강도 검증
  ///
  /// 요구사항:
  /// - 최소 8자 이상
  /// - 소문자 포함
  /// - 숫자 포함
  /// - (선택) 대문자 포함
  static bool isValidPassword(String password,
      {bool requireUppercase = false}) {
    if (password.length < passwordMinLength) return false;
    if (!lowercaseRegex.hasMatch(password)) return false;
    if (!digitRegex.hasMatch(password)) return false;
    if (requireUppercase && !uppercaseRegex.hasMatch(password)) return false;
    return true;
  }

  /// 닉네임 길이 검증
  static bool isValidNickname(String nickname) {
    return nickname.length >= nicknameMinLength &&
        nickname.length <= nicknameMaxLength;
  }

  /// 이메일 형식 오류 메시지
  static String getEmailErrorMessage(String email) {
    if (email.isEmpty) return '이메일을 입력해주세요.';
    if (!isValidEmail(email)) return '올바른 이메일 형식이 아닙니다.';
    return '';
  }

  /// 비밀번호 오류 메시지
  static String getPasswordErrorMessage(String password,
      {bool requireUppercase = false}) {
    if (password.isEmpty) return '비밀번호를 입력해주세요.';
    if (password.length < passwordMinLength) {
      return '비밀번호는 최소 $passwordMinLength자 이상이어야 합니다.';
    }
    if (!lowercaseRegex.hasMatch(password)) {
      return '비밀번호에 소문자를 포함해주세요.';
    }
    if (!digitRegex.hasMatch(password)) {
      return '비밀번호에 숫자를 포함해주세요.';
    }
    if (requireUppercase && !uppercaseRegex.hasMatch(password)) {
      return '비밀번호에 대문자를 포함해주세요.';
    }
    return '';
  }

  /// 닉네임 오류 메시지
  static String getNicknameErrorMessage(String nickname) {
    if (nickname.isEmpty) return '닉네임을 입력해주세요.';
    if (nickname.length < nicknameMinLength) {
      return '닉네임은 최소 $nicknameMinLength자 이상이어야 합니다.';
    }
    if (nickname.length > nicknameMaxLength) {
      return '닉네임은 최대 $nicknameMaxLength자 이하여야 합니다.';
    }
    return '';
  }

  /// 인증번호 오류 메시지
  static String getVerificationCodeErrorMessage(String code) {
    if (code.isEmpty) return '인증번호를 입력해주세요.';
    if (!isValidVerificationCode(code)) {
      return '인증번호는 6자리 숫자여야 합니다.';
    }
    return '';
  }
}
