// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

// models
import 'package:moamoa/features/terms/data/models/models.dart';

part 'register_form_state.freezed.dart';

/// 회원가입 폼 상태 관리 클래스
///
/// 회원가입 화면의 모든 입력 필드 데이터와 UI 상태를 관리합니다.
///
/// **주요 속성 (Properties):**
/// - `displayName`: 닉네임
/// - `email`: 이메일
/// - `password`, `confirmPassword`: 비밀번호 및 확인
/// - `selectedGender`: 선택된 성별
/// - `serviceTermsAgreed`: 서비스 이용약관 동의
/// - `privacyCollectionAgreed`: 개인정보 수집·이용 동의
/// - `marketingAgreed`: 마케팅 정보 수신 동의
/// - `isEmailVerified`: 이메일 인증 완료 여부
///
/// **주요 기능 (Key Features):**
/// - 입력 필드 데이터 관리
/// - 비밀번호 일치 여부 확인 (`isPasswordMatch`)
/// - 전체 폼 유효성 검사 (`isFormValid`)
/// - 약관 동의 상태 관리 (`isRequiredTermsAgreed`, `isAllTermsAgreed`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final formState = ref.watch(registerViewModelProvider);
/// ElevatedButton(
///   onPressed: formState.isFormValid ? _submit : null,
///   child: Text('가입하기'),
/// )
/// ```
@freezed
sealed class RegisterFormState with _$RegisterFormState {
  const RegisterFormState._();

  const factory RegisterFormState({
    @Default('') String displayName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String verificationCode,
    Gender? selectedGender,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
    @Default(false) bool isVerificationCodeSent,
    @Default(false) bool isEmailVerified,
    String? emailError,
    String? passwordError,
    // 약관 동의 상태 (항목별)
    @Default(false) bool serviceTermsAgreed,
    @Default(false) bool privacyCollectionAgreed,
    @Default(false) bool marketingAgreed,
    // 약관 데이터 (서버에서 조회)
    @Default([]) List<TermsDocumentModel> termsDocuments,
    @Default(false) bool isTermsLoading,
  }) = _RegisterFormState;

  // 초기 상태
  factory RegisterFormState.initial() => const RegisterFormState();

  // 유효성 검사 Getters
  bool get isPasswordMatch =>
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword;

  /// 필수 약관 동의 여부
  bool get isRequiredTermsAgreed =>
      serviceTermsAgreed && privacyCollectionAgreed;

  /// 전체 약관 동의 여부 (필수 + 선택)
  bool get isAllTermsAgreed =>
      serviceTermsAgreed && privacyCollectionAgreed && marketingAgreed;

  /// 폼 유효성 검사 (isTermsAgreed → isRequiredTermsAgreed로 변경)
  bool get isFormValid =>
      displayName.isNotEmpty &&
      isEmailVerified &&
      selectedGender != null &&
      isPasswordMatch &&
      isRequiredTermsAgreed;

  bool get canSubmitForm => isFormValid;

  bool get canRequestVerificationCode => email.isNotEmpty && !isEmailVerified;

  /// 특정 약관 타입의 동의 여부 조회
  bool isAgreed(DocumentType type) {
    switch (type) {
      case DocumentType.serviceTerms:
        return serviceTermsAgreed;
      case DocumentType.privacyCollection:
        return privacyCollectionAgreed;
      case DocumentType.marketing:
        return marketingAgreed;
    }
  }

  /// 특정 약관 타입의 문서 조회
  TermsDocumentModel? getDocument(DocumentType type) {
    try {
      return termsDocuments.firstWhere((doc) => doc.type == type);
    } catch (_) {
      return null;
    }
  }

  /// 회원가입 요청용 약관 동의 목록 생성
  List<AgreementRequestModel> toAgreementRequests() {
    return termsDocuments.map((doc) {
      return AgreementRequestModel(
        type: doc.type,
        version: doc.version,
        agreed: isAgreed(doc.type),
      );
    }).toList();
  }
}
