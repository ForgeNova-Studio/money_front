/// 약관 문서 타입
enum DocumentType {
  /// 서비스 이용약관 (필수)
  serviceTerms,

  /// 개인정보 수집·이용 동의 (필수)
  privacyCollection,

  /// 마케팅 정보 수신 동의 (선택)
  marketing;

  /// 서버 문자열로 변환
  String toServerString() {
    switch (this) {
      case DocumentType.serviceTerms:
        return 'SERVICE_TERMS';
      case DocumentType.privacyCollection:
        return 'PRIVACY_COLLECTION';
      case DocumentType.marketing:
        return 'MARKETING';
    }
  }

  /// 서버 문자열에서 변환
  static DocumentType fromServerString(String value) {
    switch (value.toUpperCase()) {
      case 'SERVICE_TERMS':
        return DocumentType.serviceTerms;
      case 'PRIVACY_COLLECTION':
        return DocumentType.privacyCollection;
      case 'MARKETING':
        return DocumentType.marketing;
      default:
        throw ArgumentError('Unknown DocumentType: $value');
    }
  }

  /// 한국어 표시명
  String get displayName {
    switch (this) {
      case DocumentType.serviceTerms:
        return '서비스 이용약관';
      case DocumentType.privacyCollection:
        return '개인정보 수집·이용 동의';
      case DocumentType.marketing:
        return '마케팅 정보 수신 동의';
    }
  }

  /// 필수 여부
  bool get isRequired {
    switch (this) {
      case DocumentType.serviceTerms:
      case DocumentType.privacyCollection:
        return true;
      case DocumentType.marketing:
        return false;
    }
  }
}
