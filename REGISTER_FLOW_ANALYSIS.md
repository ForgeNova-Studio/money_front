# 회원가입 흐름 전체 분석 보고서

**분석 날짜**: 2025-12-08
**분석 대상**: MoneyFlow 앱 회원가입 기능 (프론트엔드 + 백엔드)

---

## 📋 목차

1. [회원가입 흐름 요약](#회원가입-흐름-요약)
2. [발견된 문제점](#발견된-문제점)
3. [예외 처리 분석](#예외-처리-분석)
4. [테스트 케이스](#테스트-케이스)
5. [개선 방안](#개선-방안)

---

## 회원가입 흐름 요약

### 전체 프로세스

```
1. 사용자 정보 입력
   ├─ 닉네임 입력
   ├─ 성별 선택 (남성/여성)
   ├─ 이메일 입력
   ├─ 비밀번호 입력
   └─ 비밀번호 확인 입력

2. 이메일 인증
   ├─ [인증요청] 버튼 클릭 → sendSignupCode()
   ├─ 백엔드: 인증번호 생성 (6자리, 10분 유효)
   ├─ 이메일 전송
   ├─ 인증번호 입력 필드 표시
   ├─ 인증번호 입력 → verifySignupCode()
   └─ 인증 완료 (10초 이내 회원가입 완료 필요) ⚠️

3. 약관 동의
   └─ 이용약관 및 개인정보 이용동의 체크

4. 회원가입
   ├─ 유효성 검사 (프론트엔드)
   ├─ register() API 호출
   ├─ 백엔드: 인증 완료 확인 (10초 이내인지 검증) ⚠️
   ├─ 사용자 생성 + JWT 토큰 발급
   ├─ 로컬 저장 (Secure Storage)
   └─ 홈 화면으로 이동
```

### 데이터 흐름

```
UI (RegisterScreen)
  ↓
ViewModel (RegisterViewModel + AuthViewModel)
  ↓
UseCase (RegisterUseCase, SendSignupCodeUseCase, VerifySignupCodeUseCase)
  ↓
Repository (AuthRepositoryImpl)
  ↓
DataSource (AuthRemoteDataSourceImpl + AuthLocalDataSourceImpl)
  ↓
Backend API (AuthService)
  ↓
Database (EmailVerification, User)
```

---

## 발견된 문제점

### 🟡 중간 수준 문제

#### 3. **닉네임 길이 제한 불일치**

**위치**:
- `money_front/lib/core/validators/input_validator.dart:8`
- `money_front/lib/features/auth/REGISTER_FLOW.md:102`

**문제**:
```dart
// InputValidator
static const int nicknameMaxLength = 20;  // 코드: 20자
```

```markdown
# REGISTER_FLOW.md
2자 이상 12자 이하  // 문서: 12자
```

**영향**:
- 문서와 코드가 일치하지 않음
- 백엔드 검증 정책을 확인해야 함

**해결 방법**:
1. 백엔드의 실제 제한을 확인
2. 프론트엔드와 백엔드, 문서를 모두 일치시킴

---

#### 4. **특수문자 정책 불일치**

**위치**:
- `money_front/lib/features/auth/presentation/viewmodels/register_view_model.dart:125`
- `money_front/lib/core/validators/input_validator.dart`

**문제**:

**RegisterViewModel**:
```dart
// @$!%*?& 만 허용
final hasSpecialChar = password.contains(RegExp(r'[@$!%*?&]'));
```

**InputValidator**:
```dart
// 특수문자 종류 검증 없음 (백엔드에 의존)
```

**영향**:
- RegisterViewModel에서는 `#`, `^`, `()` 등의 특수문자를 거부하지만
- InputValidator는 모든 특수문자를 허용
- 일관성 없음

**해결 방법**:
모든 일반적인 특수문자를 허용하도록 통일:
```dart
final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
```

---

### 🟢 경미한 문제

#### 5. **verifySignupCode 응답 형식 불명확**

**위치**: `money_front/lib/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart:122`

```dart
// API 응답이 { "success": true/false } 형태라고 가정
return response.data['success'] as bool? ?? false;
```

**문제**:
- 주석으로 "가정"이라고 명시됨
- 백엔드 AuthService.java:358을 보면 `VerificationResponse.success("인증이 완료되었습니다")`를 반환
- VerificationResponse의 실제 JSON 구조를 확인해야 함

**해결 방법**:
1. VerificationResponse 클래스 확인
2. 실제 응답 형식에 맞게 코드 수정
3. 주석 제거 또는 명확하게 수정

---

#### 6. **성별 필수 여부 불명확**

**위치**: `money_front/lib/features/auth/presentation/viewmodels/register_view_model.dart:95-97`

```dart
if (state.selectedGender == null) {
  return '성별을 선택해주세요.';
}
```

**문제**:
- 프론트엔드에서는 성별을 필수로 요구
- 하지만 백엔드 UserModel에서 gender는 nullable일 수 있음
- 소셜 로그인 시 성별이 없을 수 있음 (REGISTER_FLOW.md:778-780)

**영향**:
- 정책이 명확하지 않음
- 소셜 로그인과 일반 회원가입의 요구사항이 다름

**해결 방법**:
1. 일반 회원가입: 성별 필수 유지
2. 소셜 로그인: 성별 선택 사항
3. 정책 문서화

---

## 예외 처리 분석

### ✅ 잘 처리된 부분

#### 1. **DioException → Custom Exception 변환**

**위치**: `money_front/lib/core/exceptions/exception_handler.dart`

```dart
static Exception handleDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return TimeoutException('요청 시간이 초과되었습니다');
    case DioExceptionType.connectionError:
      return NetworkException('네트워크 연결을 확인해주세요');
    case DioExceptionType.badResponse:
      return _handleResponseError(error);
    // ...
  }
}
```

**장점**:
- 모든 네트워크 에러 타입을 커버
- HTTP 상태 코드별로 적절한 예외로 변환 (400, 401, 403, 404, 409, 422, 500번대)
- 사용자 친화적인 에러 메시지 제공

---

#### 2. **ViewModel의 예외 처리 및 상태 관리**

**위치**: `money_front/lib/features/auth/presentation/viewmodels/auth_view_model.dart`

```dart
Future<void> sendSignupCode(String email) async {
  state = AuthState.loading();

  try {
    final useCase = ref.read(sendSignupCodeUseCaseProvider);
    await useCase(email);
    state = AuthState.initial();
  } on ValidationException catch (e) {
    state = AuthState.error(e.message);
    rethrow;  // UI에서 처리할 수 있도록 rethrow
  } on NetworkException catch (e) {
    state = AuthState.error(e.message);
    rethrow;
  } // ...
}
```

**장점**:
- 각 예외 타입별로 처리
- 에러 상태를 state에 저장하여 UI에서 표시
- rethrow로 UI에서 추가 처리 가능

---

#### 3. **UseCase 레벨 입력값 검증**

**위치**: `money_front/lib/features/auth/domain/usecases/`

```dart
// SendSignupCodeUseCase
void _validateEmail(String email) {
  final errorMessage = InputValidator.getEmailErrorMessage(email);
  if (errorMessage.isNotEmpty) {
    throw ValidationException(errorMessage);
  }
}

// VerifySignupCodeUseCase
void _validateInput({required String email, required String code}) {
  final emailError = InputValidator.getEmailErrorMessage(email);
  if (emailError.isNotEmpty) {
    throw ValidationException(emailError);
  }

  final codeError = InputValidator.getVerificationCodeErrorMessage(code);
  if (codeError.isNotEmpty) {
    throw ValidationException(codeError);
  }
}
```

**장점**:
- 네트워크 요청 전에 프론트엔드에서 먼저 검증
- 불필요한 API 호출 방지
- 빠른 피드백 제공

---

#### 4. **백엔드 GlobalExceptionHandler**

**위치**: `money_back/src/main/java/com/moneyflow/exception/GlobalExceptionHandler.java`

```java
@ExceptionHandler(BusinessException.class)
public ResponseEntity<ErrorResponse> handleBusinessException(BusinessException ex) {
    log.error("Business exception: {}", ex.getMessage());
    ErrorResponse error = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            ex.getMessage(),
            LocalDateTime.now()
    );
    return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
}
```

**장점**:
- 모든 예외를 일관된 형식으로 변환
- 적절한 HTTP 상태 코드 반환
- 로깅 포함

---

### ⚠️ 개선 필요한 부분

#### 1. **UI에서 에러 처리 중복**

**위치**: `money_front/lib/features/auth/presentation/screens/register_screen.dart:131-135`

```dart
try {
  await ref.read(registerViewModelProvider.notifier)
      .sendVerificationCode(_emailController.text);
  // 성공 시 SnackBar 표시
} catch (e) {
  // try-catch는 UnhandledException 방지용
  // 실제 에러는 ref.listen에서 처리됨 (174행)
}
```

**문제**:
- try-catch가 있지만 실제로 에러를 처리하지 않음
- 에러는 ref.listen에서 처리됨
- 코드가 혼란스러움

**개선 방법**:
```dart
try {
  await ref.read(registerViewModelProvider.notifier)
      .sendVerificationCode(_emailController.text);

  if (mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('인증번호가 전송되었습니다.')),
      );
  }
} catch (e) {
  // 에러는 authViewModelProvider의 ref.listen에서 처리됨
  // 여기서는 아무것도 하지 않음
}
```

---

#### 2. **인증번호 만료 시간에 대한 사용자 안내 부족**

**문제**:
- 인증번호가 10분간 유효하다는 정보를 UI에 표시하지 않음
- 타이머나 남은 시간 표시 없음

**개선 방법**:
1. 인증번호 입력 필드 아래에 "인증번호는 10분간 유효합니다" 안내 문구 추가
2. 타이머 카운트다운 표시 (선택사항)
3. 만료 시 "인증번호가 만료되었습니다. 다시 요청해주세요" 메시지와 함께 재전송 버튼 활성화

---

#### 3. **회원가입 제한 시간 안내 부족**

**문제**:
- 인증 완료 후 10초(또는 5분) 이내에 회원가입해야 한다는 안내 없음
- 사용자가 왜 "인증 시간이 만료되었습니다" 에러를 받는지 이해하기 어려움

**개선 방법**:
1. 인증 완료 시 "5분 이내에 회원가입을 완료해주세요" 안내 메시지 표시
2. 또는 인증 완료 후 회원가입 버튼까지 자동 스크롤

---

## 테스트 케이스

### 단위 테스트 (Unit Tests)

#### 프론트엔드 - InputValidator

```dart
// test/core/validators/input_validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:moneyflow/core/validators/input_validator.dart';

void main() {
  group('InputValidator - Email', () {
    test('유효한 이메일은 통과해야 함', () {
      expect(InputValidator.getEmailErrorMessage('test@example.com'), '');
      expect(InputValidator.getEmailErrorMessage('user.name@domain.co.kr'), '');
    });

    test('빈 이메일은 에러 메시지 반환', () {
      expect(InputValidator.getEmailErrorMessage(''), '이메일을 입력해주세요.');
    });

    test('잘못된 형식의 이메일은 에러 메시지 반환', () {
      expect(InputValidator.getEmailErrorMessage('invalid-email'), '올바른 이메일 형식이 아닙니다.');
      expect(InputValidator.getEmailErrorMessage('@example.com'), '올바른 이메일 형식이 아닙니다.');
      expect(InputValidator.getEmailErrorMessage('test@'), '올바른 이메일 형식이 아닙니다.');
    });
  });

  group('InputValidator - Password', () {
    test('유효한 비밀번호는 통과해야 함 (대문자 불필요)', () {
      expect(InputValidator.getPasswordErrorMessage('password123', requireUppercase: false), '');
      expect(InputValidator.getPasswordErrorMessage('test1234', requireUppercase: false), '');
    });

    test('8자 미만은 에러 메시지 반환', () {
      expect(
        InputValidator.getPasswordErrorMessage('pass1', requireUppercase: false),
        '비밀번호는 최소 8자 이상이어야 합니다.',
      );
    });

    test('소문자 없으면 에러 메시지 반환', () {
      expect(
        InputValidator.getPasswordErrorMessage('12345678', requireUppercase: false),
        '비밀번호에 소문자를 포함해주세요.',
      );
    });

    test('숫자 없으면 에러 메시지 반환', () {
      expect(
        InputValidator.getPasswordErrorMessage('password', requireUppercase: false),
        '비밀번호에 숫자를 포함해주세요.',
      );
    });

    test('대문자 필요 시 대문자 없으면 에러 메시지 반환', () {
      expect(
        InputValidator.getPasswordErrorMessage('password123', requireUppercase: true),
        '비밀번호에 대문자를 포함해주세요.',
      );
    });
  });

  group('InputValidator - Nickname', () {
    test('유효한 닉네임은 통과해야 함', () {
      expect(InputValidator.getNicknameErrorMessage('테스트'), '');
      expect(InputValidator.getNicknameErrorMessage('User123'), '');
      expect(InputValidator.getNicknameErrorMessage('1234567890'), '');
    });

    test('2자 미만은 에러 메시지 반환', () {
      expect(
        InputValidator.getNicknameErrorMessage('A'),
        '닉네임은 최소 2자 이상이어야 합니다.',
      );
    });

    test('20자 초과는 에러 메시지 반환', () {
      expect(
        InputValidator.getNicknameErrorMessage('A' * 21),
        '닉네임은 최대 20자 이하여야 합니다.',
      );
    });
  });

  group('InputValidator - Verification Code', () {
    test('유효한 6자리 숫자는 통과해야 함', () {
      expect(InputValidator.getVerificationCodeErrorMessage('123456'), '');
      expect(InputValidator.getVerificationCodeErrorMessage('000000'), '');
    });

    test('6자리가 아니면 에러 메시지 반환', () {
      expect(
        InputValidator.getVerificationCodeErrorMessage('12345'),
        '인증번호는 6자리 숫자여야 합니다.',
      );
      expect(
        InputValidator.getVerificationCodeErrorMessage('1234567'),
        '인증번호는 6자리 숫자여야 합니다.',
      );
    });

    test('숫자가 아니면 에러 메시지 반환', () {
      expect(
        InputValidator.getVerificationCodeErrorMessage('12345a'),
        '인증번호는 6자리 숫자여야 합니다.',
      );
      expect(
        InputValidator.getVerificationCodeErrorMessage('abcdef'),
        '인증번호는 6자리 숫자여야 합니다.',
      );
    });
  });
}
```

---

#### 프론트엔드 - RegisterViewModel

```dart
// test/features/auth/presentation/viewmodels/register_view_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/register_view_model.dart';
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('RegisterViewModel - validateForSignup', () {
    test('모든 필드가 유효하면 null 반환', () {
      final viewModel = container.read(registerViewModelProvider.notifier);

      // 성별 선택
      viewModel.selectGender(Gender.male);

      // 이메일 인증 완료로 설정
      viewModel.state = viewModel.state.copyWith(
        isEmailVerified: true,
        isTermsAgreed: true,
      );

      final error = viewModel.validateForSignup(
        password: 'Password123!',
        confirmPassword: 'Password123!',
      );

      expect(error, null);
    });

    test('이메일 인증 안되면 에러 메시지 반환', () {
      final viewModel = container.read(registerViewModelProvider.notifier);
      viewModel.selectGender(Gender.male);
      viewModel.state = viewModel.state.copyWith(isTermsAgreed: true);

      final error = viewModel.validateForSignup(
        password: 'Password123!',
        confirmPassword: 'Password123!',
      );

      expect(error, '이메일 인증을 완료해주세요.');
    });

    test('성별 선택 안하면 에러 메시지 반환', () {
      final viewModel = container.read(registerViewModelProvider.notifier);
      viewModel.state = viewModel.state.copyWith(
        isEmailVerified: true,
        isTermsAgreed: true,
      );

      final error = viewModel.validateForSignup(
        password: 'Password123!',
        confirmPassword: 'Password123!',
      );

      expect(error, '성별을 선택해주세요.');
    });

    test('비밀번호 불일치하면 에러 메시지 반환', () {
      final viewModel = container.read(registerViewModelProvider.notifier);
      viewModel.selectGender(Gender.male);
      viewModel.state = viewModel.state.copyWith(
        isEmailVerified: true,
        isTermsAgreed: true,
      );

      final error = viewModel.validateForSignup(
        password: 'Password123!',
        confirmPassword: 'Different123!',
      );

      expect(error, '비밀번호가 일치하지 않습니다.');
    });

    test('약관 동의 안하면 에러 메시지 반환', () {
      final viewModel = container.read(registerViewModelProvider.notifier);
      viewModel.selectGender(Gender.male);
      viewModel.state = viewModel.state.copyWith(isEmailVerified: true);

      final error = viewModel.validateForSignup(
        password: 'Password123!',
        confirmPassword: 'Password123!',
      );

      expect(error, '약관 및 개인정보 이용동의에 체크해주세요.');
    });

    test('비밀번호가 정책에 맞지 않으면 에러 메시지 반환', () {
      final viewModel = container.read(registerViewModelProvider.notifier);
      viewModel.selectGender(Gender.male);
      viewModel.state = viewModel.state.copyWith(
        isEmailVerified: true,
        isTermsAgreed: true,
      );

      // 대문자 없음
      var error = viewModel.validateForSignup(
        password: 'password123!',
        confirmPassword: 'password123!',
      );
      expect(error, contains('대문자'));

      // 숫자 없음
      error = viewModel.validateForSignup(
        password: 'Password!',
        confirmPassword: 'Password!',
      );
      expect(error, contains('숫자'));

      // 특수문자 없음
      error = viewModel.validateForSignup(
        password: 'Password123',
        confirmPassword: 'Password123',
      );
      expect(error, contains('특수문자'));
    });
  });
}
```

---

### 통합 테스트 (Integration Tests)

#### 백엔드 - 회원가입 전체 흐름

```java
// AuthServiceIntegrationTest.java
package com.moneyflow.service;

import com.moneyflow.domain.user.User;
import com.moneyflow.domain.user.UserRepository;
import com.moneyflow.domain.verification.EmailVerification;
import com.moneyflow.domain.verification.EmailVerificationRepository;
import com.moneyflow.dto.request.RegisterRequest;
import com.moneyflow.dto.request.SendCodeRequest;
import com.moneyflow.dto.request.VerifyCodeRequest;
import com.moneyflow.dto.response.RegisterResponse;
import com.moneyflow.dto.response.VerificationResponse;
import com.moneyflow.exception.BusinessException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
@Transactional
class AuthServiceIntegrationTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailVerificationRepository emailVerificationRepository;

    @AfterEach
    void cleanup() {
        userRepository.deleteAll();
        emailVerificationRepository.deleteAll();
    }

    @Test
    void 회원가입_전체_흐름_성공() {
        // Given: 회원가입 정보
        String email = "test@example.com";
        String password = "password123";
        String nickname = "테스터";
        String gender = "MALE";

        // When 1: 인증번호 전송
        SendCodeRequest sendCodeRequest = new SendCodeRequest();
        sendCodeRequest.setEmail(email);
        VerificationResponse sendResponse = authService.sendSignupCode(sendCodeRequest);

        // Then 1: 인증번호 전송 성공
        assertThat(sendResponse.isSuccess()).isTrue();
        assertThat(sendResponse.getMessage()).contains("인증 코드가 발송되었습니다");

        // Given 2: 전송된 인증번호 조회
        EmailVerification verification = emailVerificationRepository
                .findFirstByEmailAndVerificationTypeAndVerifiedFalseOrderByCreatedAtDesc(
                        email, EmailVerification.VerificationType.SIGNUP)
                .orElseThrow();
        String code = verification.getVerificationCode();

        // When 2: 인증번호 검증
        VerifyCodeRequest verifyRequest = new VerifyCodeRequest();
        verifyRequest.setEmail(email);
        verifyRequest.setCode(code);
        VerificationResponse verifyResponse = authService.verifySignupCode(verifyRequest);

        // Then 2: 인증번호 검증 성공
        assertThat(verifyResponse.isSuccess()).isTrue();

        // When 3: 회원가입
        RegisterRequest registerRequest = new RegisterRequest();
        registerRequest.setEmail(email);
        registerRequest.setPassword(password);
        registerRequest.setNickname(nickname);
        registerRequest.setGender(gender);
        RegisterResponse registerResponse = authService.register(registerRequest);

        // Then 3: 회원가입 성공
        assertThat(registerResponse).isNotNull();
        assertThat(registerResponse.getAccessToken()).isNotBlank();
        assertThat(registerResponse.getRefreshToken()).isNotBlank();
        assertThat(registerResponse.getUserId()).isNotNull();

        // Verify: 사용자가 DB에 저장되었는지 확인
        User savedUser = userRepository.findByEmail(email).orElseThrow();
        assertThat(savedUser.getEmail()).isEqualTo(email);
        assertThat(savedUser.getNickname()).isEqualTo(nickname);
    }

    @Test
    void 이메일_중복_체크_실패() {
        // Given: 이미 가입된 사용자
        String email = "existing@example.com";
        User existingUser = User.builder()
                .email(email)
                .passwordHash("hashed")
                .nickname("기존사용자")
                .build();
        userRepository.save(existingUser);

        // When & Then: 인증번호 전송 시 에러 발생
        SendCodeRequest request = new SendCodeRequest();
        request.setEmail(email);

        assertThatThrownBy(() -> authService.sendSignupCode(request))
                .isInstanceOf(BusinessException.class)
                .hasMessage("이미 가입된 이메일입니다");
    }

    @Test
    void 인증번호_불일치_실패() {
        // Given: 인증번호 전송
        String email = "test@example.com";
        SendCodeRequest sendRequest = new SendCodeRequest();
        sendRequest.setEmail(email);
        authService.sendSignupCode(sendRequest);

        // When & Then: 잘못된 인증번호로 검증 시도
        VerifyCodeRequest verifyRequest = new VerifyCodeRequest();
        verifyRequest.setEmail(email);
        verifyRequest.setCode("000000");  // 잘못된 코드

        assertThatThrownBy(() -> authService.verifySignupCode(verifyRequest))
                .isInstanceOf(BusinessException.class)
                .hasMessage("인증 코드가 일치하지 않습니다");
    }

    @Test
    void 인증_완료_후_회원가입_제한_시간_초과_실패() throws InterruptedException {
        // Given: 인증 완료
        String email = "test@example.com";

        // 인증번호 전송
        SendCodeRequest sendRequest = new SendCodeRequest();
        sendRequest.setEmail(email);
        authService.sendSignupCode(sendRequest);

        // 인증번호 조회 및 검증
        EmailVerification verification = emailVerificationRepository
                .findFirstByEmailAndVerificationTypeAndVerifiedFalseOrderByCreatedAtDesc(
                        email, EmailVerification.VerificationType.SIGNUP)
                .orElseThrow();

        VerifyCodeRequest verifyRequest = new VerifyCodeRequest();
        verifyRequest.setEmail(email);
        verifyRequest.setCode(verification.getVerificationCode());
        authService.verifySignupCode(verifyRequest);

        // When: 11초 대기 (제한 시간 10초 초과)
        Thread.sleep(11000);

        // Then: 회원가입 시도 시 에러 발생
        RegisterRequest registerRequest = new RegisterRequest();
        registerRequest.setEmail(email);
        registerRequest.setPassword("password123");
        registerRequest.setNickname("테스터");
        registerRequest.setGender("MALE");

        assertThatThrownBy(() -> authService.register(registerRequest))
                .isInstanceOf(BusinessException.class)
                .hasMessage("인증 시간이 만료되었습니다. 다시 인증해주세요");
    }

    @Test
    void 인증_안한_상태에서_회원가입_시도_실패() {
        // Given: 인증번호 전송만 하고 검증 안함
        String email = "test@example.com";
        SendCodeRequest sendRequest = new SendCodeRequest();
        sendRequest.setEmail(email);
        authService.sendSignupCode(sendRequest);

        // When & Then: 인증 안하고 회원가입 시도
        RegisterRequest registerRequest = new RegisterRequest();
        registerRequest.setEmail(email);
        registerRequest.setPassword("password123");
        registerRequest.setNickname("테스터");
        registerRequest.setGender("MALE");

        assertThatThrownBy(() -> authService.register(registerRequest))
                .isInstanceOf(BusinessException.class)
                .hasMessage("이메일 인증을 먼저 완료해주세요");
    }
}
```

---

### E2E 테스트 (End-to-End Tests)

#### Flutter Widget Test

```dart
// test/features/auth/presentation/screens/register_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneyflow/features/auth/presentation/screens/register_screen.dart';

void main() {
  testWidgets('회원가입 화면 UI 렌더링 테스트', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Verify that all input fields are present
    expect(find.text('닉네임'), findsOneWidget);
    expect(find.text('이메일'), findsOneWidget);
    expect(find.text('비밀번호'), findsOneWidget);
    expect(find.text('비밀번호 확인'), findsOneWidget);

    // Verify gender selection buttons
    expect(find.text('남성'), findsOneWidget);
    expect(find.text('여성'), findsOneWidget);

    // Verify verification button
    expect(find.text('인증요청'), findsOneWidget);

    // Verify terms checkbox
    expect(find.text('이용약관'), findsOneWidget);
    expect(find.text('개인정보 이용동의'), findsOneWidget);

    // Verify register button
    expect(find.text('회원가입'), findsOneWidget);
  });

  testWidgets('닉네임 입력 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Find nickname field and enter text
    final nicknameField = find.widgetWithText(TextField, '닉네임');
    await tester.enterText(nicknameField, '테스터');

    expect(find.text('테스터'), findsOneWidget);
  });

  testWidgets('성별 선택 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Tap on male button
    await tester.tap(find.text('남성'));
    await tester.pump();

    // Verify UI updates (border color change)
    // This requires checking widget properties
  });

  testWidgets('이메일 인증 흐름 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Enter email
    final emailField = find.widgetWithText(TextField, '이메일');
    await tester.enterText(emailField, 'test@example.com');

    // Tap verification button
    await tester.tap(find.text('인증요청'));
    await tester.pumpAndSettle();

    // Verify that verification code field appears
    // (This requires mocking the API response)
  });
}
```

---

## 개선 방안

### 즉시 적용 가능한 개선사항

#### 1. **인증 완료 후 회원가입 제한 시간 수정**

**우선순위**: 🔴 높음
**난이도**: 쉬움
**위치**: `EmailVerification.java:110`

```java
// 변경 전
return LocalDateTime.now().isAfter(verifiedAt.plusSeconds(10));

// 변경 후
return LocalDateTime.now().isAfter(verifiedAt.plusMinutes(5));
```

**예상 효과**:
- 회원가입 성공률 대폭 향상
- 사용자 불만 감소

---

#### 2. **비밀번호 정책 통일**

**우선순위**: 🔴 높음
**난이도**: 중간

**Step 1**: RegisterViewModel 수정
```dart
// register_view_model.dart:117-128
bool _isValidPassword(String password) {
  // 최소 8자
  if (password.length < 8) return false;

  // 최소 1개의 소문자
  final hasLowerCase = password.contains(RegExp(r'[a-z]'));
  // 최소 1개의 숫자
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  // 최소 1개의 특수문자
  final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasLowerCase && hasDigit && hasSpecialChar;
}
```

**Step 2**: 에러 메시지 수정
```dart
// register_view_model.dart:101
return '비밀번호는 8자 이상이며, 소문자, 숫자, 특수문자를 각각 최소 1개 이상 포함해야 합니다.';
```

**Step 3**: InputValidator도 특수문자 검증 추가 (선택사항)
```dart
// input_validator.dart에 특수문자 정규식 추가
static final RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

// isValidPassword 메서드 수정
static bool isValidPassword(String password, {bool requireUppercase = false}) {
  if (password.length < passwordMinLength) return false;
  if (!lowercaseRegex.hasMatch(password)) return false;
  if (!digitRegex.hasMatch(password)) return false;
  if (!specialCharRegex.hasMatch(password)) return false;  // 추가
  if (requireUppercase && !uppercaseRegex.hasMatch(password)) return false;
  return true;
}
```

---

#### 3. **닉네임 길이 제한 통일**

**우선순위**: 🟡 중간
**난이도**: 쉬움

**Step 1**: 백엔드에서 실제 제한 확인
```java
// User 엔티티 확인
@Column(name = "nickname", nullable = false, length = ?)
```

**Step 2**: 프론트엔드와 문서 통일
- InputValidator의 상수 수정
- REGISTER_FLOW.md 수정

---

#### 4. **UI 개선 - 타이머 및 안내 문구 추가**

**우선순위**: 🟡 중간
**난이도**: 중간

**구현 예시**:
```dart
// register_screen.dart에 추가

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  Timer? _verificationTimer;
  int _remainingSeconds = 600; // 10분 = 600초

  void _startVerificationTimer() {
    _remainingSeconds = 600;
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          // 타이머 만료 시 처리
        }
      });
    });
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  // UI에 타이머 표시
  Widget _buildVerificationTimer() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Text(
      '남은 시간: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 12,
        color: _remainingSeconds < 60 ? Colors.red : AppColors.textSecondary,
      ),
    );
  }
}
```

---

### 중장기 개선사항

#### 1. **이메일 인증 완료 후 자동 회원가입 흐름**

**우선순위**: 🟢 낮음
**난이도**: 높음

**개선안**:
- 이메일 인증 완료 시 모든 필드가 채워져 있으면 자동으로 회원가입 진행
- 또는 인증 완료 시 회원가입 버튼까지 자동 스크롤

---

#### 2. **비밀번호 강도 표시**

**우선순위**: 🟢 낮음
**난이도**: 중간

**개선안**:
- 비밀번호 입력 시 실시간으로 강도 표시 (약함/보통/강함)
- 각 요구사항별 체크 표시 (소문자 ✓, 숫자 ✓, 특수문자 ✗)

---

#### 3. **인증번호 재전송 기능 개선**

**우선순위**: 🟢 낮음
**난이도**: 쉬움

**개선안**:
- 인증번호 재전송 시 1분 쿨다운 추가 (스팸 방지)
- 재전송 횟수 제한 (예: 5회)

---

## 요약

### 발견된 주요 문제점

1. 🔴 **인증 완료 후 회원가입 제한 시간이 10초로 너무 짧음** → 5분으로 수정 필요
2. 🔴 **비밀번호 정책 불일치** (RegisterViewModel vs RegisterUseCase) → 통일 필요
3. 🟡 **닉네임 길이 제한 불일치** (코드 vs 문서) → 통일 필요
4. 🟡 **특수문자 정책 불일치** (RegisterViewModel vs InputValidator) → 통일 필요
5. 🟢 **UI 개선 필요** (타이머, 안내 문구)

### 예외 처리 평가

✅ **잘 처리된 부분**:
- DioException → Custom Exception 변환
- ViewModel의 예외 처리 및 상태 관리
- UseCase 레벨 입력값 검증
- 백엔드 GlobalExceptionHandler

⚠️ **개선 필요한 부분**:
- UI에서 에러 처리 중복
- 인증번호 만료 시간 안내 부족
- 회원가입 제한 시간 안내 부족

### 우선순위 개선사항

1. **즉시 수정**: 인증 완료 후 회원가입 제한 시간 (10초 → 5분)
2. **즉시 수정**: 비밀번호 정책 통일
3. **단기**: UI 개선 (타이머, 안내 문구)
4. **중기**: 닉네임 길이 제한 통일
5. **장기**: 사용자 경험 개선 (자동 스크롤, 비밀번호 강도 표시)

---

**보고서 작성일**: 2025-12-08
**분석자**: Claude (AI Assistant)
