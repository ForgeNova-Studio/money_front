// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// states
import 'package:moamoa/features/auth/presentation/states/register_form_state.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

// core
import 'package:moamoa/core/validators/input_validator.dart';

// viewmodels
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

// terms
import 'package:moamoa/features/terms/data/models/models.dart';
import 'package:moamoa/features/terms/presentation/providers/terms_provider.dart';

part 'register_view_model.g.dart';

/// 회원가입 ViewModel
///
/// 회원가입 화면의 UI 상태 관리 및 데이터 처리를 담당합니다.
///
/// **주요 기능 (Key Features):**
/// - 입력 폼 상태 관리 (닉네임, 이메일, 비밀번호, 성별 등)
/// - 유효성 검사 (`validateForSignup`)
/// - 이메일 인증 (`sendVerificationCode`, `verifyCode`)
/// - 약관 동의 및 비밀번호 가시성 토글
/// - 약관 조회 (`loadTerms`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final errorMessage = ref.read(registerViewModelProvider.notifier)
///     .validateForSignup(password: pw, confirmPassword: cp);
/// ```
@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  static const String _passwordMismatchMessage = '비밀번호가 일치하지 않습니다.';

  @override
  RegisterFormState build() {
    return RegisterFormState.initial();
  }

  /// 약관 목록 조회
  Future<void> loadTerms() async {
    state = state.copyWith(isTermsLoading: true);
    try {
      final terms = await ref.read(getActiveTermsProvider.future);
      state = state.copyWith(
        termsDocuments: terms,
        isTermsLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isTermsLoading: false);
      rethrow;
    }
  }

  /// 성별 선택
  void selectGender(Gender gender) {
    state = state.copyWith(selectedGender: gender);
  }

  /// 특정 약관 동의 토글
  void toggleAgreement(DocumentType type) {
    switch (type) {
      case DocumentType.serviceTerms:
        state = state.copyWith(
          serviceTermsAgreed: !state.serviceTermsAgreed,
        );
        break;
      case DocumentType.privacyCollection:
        state = state.copyWith(
          privacyCollectionAgreed: !state.privacyCollectionAgreed,
        );
        break;
      case DocumentType.marketing:
        state = state.copyWith(
          marketingAgreed: !state.marketingAgreed,
        );
        break;
    }
  }

  /// 전체 동의 토글
  void toggleAllAgreements() {
    final newValue = !state.isAllTermsAgreed;
    state = state.copyWith(
      serviceTermsAgreed: newValue,
      privacyCollectionAgreed: newValue,
      marketingAgreed: newValue,
    );
  }

  /// 비밀번호 가시성 토글
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 비밀번호 확인 가시성 토글
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: _passwordMismatchError(
        password: password,
        confirmPassword: state.confirmPassword,
      ),
    );
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(
      confirmPassword: confirmPassword,
      passwordError: _passwordMismatchError(
        password: state.password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  /// 이메일 인증번호 전송
  Future<void> sendVerificationCode(String email) async {
    try {
      // 이메일 저장
      state = state.copyWith(email: email);

      // AuthViewModel의 sendSignupCode 호출
      await ref.read(authViewModelProvider.notifier).sendSignupCode(email);

      // 에러가 발생했는지 확인 (에러가 있으면 인증번호 전송 상태 업데이트 안 함)
      final authState = ref.read(authViewModelProvider);
      if (authState.errorMessage != null) {
        return; // 에러가 있으면 여기서 종료
      }

      // 성공 시 인증번호 전송 상태 업데이트
      state = state.copyWith(isVerificationCodeSent: true);
    } catch (e) {
      // 에러 발생 시 예외를 다시 던져서 UI에서 처리하도록 함
      rethrow;
    }
  }

  /// 인증번호 확인
  Future<bool> verifyCode({
    required String email,
    required String code,
  }) async {
    // AuthViewModel의 verifySignupCode 호출
    final isVerified = await ref
        .read(authViewModelProvider.notifier)
        .verifySignupCode(email: email, code: code);

    if (isVerified) {
      // 인증 성공 시 상태 업데이트
      state = state.copyWith(
        email: email,
        verificationCode: code,
        isEmailVerified: true,
      );
    }

    return isVerified;
  }

  /// 회원가입 가능 여부 검증 및 에러 메시지 반환
  String? validateForSignup({
    required String password,
    required String confirmPassword,
  }) {
    if (!state.isEmailVerified) {
      return '이메일 인증을 완료해주세요.';
    }

    if (state.selectedGender == null) {
      return '성별을 선택해주세요.';
    }

    // 비밀번호 패턴 검증 (백엔드와 동일한 규칙)
    final passwordError = InputValidator.getPasswordErrorMessage(
      password,
      requireUppercase: true,
      requireSpecialChar: true,
    );
    if (passwordError.isNotEmpty) {
      return passwordError;
    }

    if (password != confirmPassword) {
      return _passwordMismatchMessage;
    }

    if (!state.isRequiredTermsAgreed) {
      return '서비스 이용약관과 개인정보 수집·이용 동의는 필수입니다.';
    }

    return null; // 검증 통과
  }

  /// 회원가입 요청용 약관 동의 목록 반환
  List<AgreementRequestModel> getAgreementRequests() {
    return state.toAgreementRequests();
  }

  String? _passwordMismatchError({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return null;
    }

    if (!_isPasswordValidForSignup(password)) return null;
    return password != confirmPassword ? _passwordMismatchMessage : null;
  }

  bool _isPasswordValidForSignup(String password) {
    return InputValidator.isValidPassword(
      password,
      requireUppercase: true,
      requireSpecialChar: true,
    );
  }

  /// 상태 초기화
  void reset() {
    state = RegisterFormState.initial();
  }
}
