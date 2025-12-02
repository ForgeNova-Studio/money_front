# 회원가입 기능 구현 체크리스트

## 📋 전체 진행 상황
- [ ] Domain Layer (UseCase)
- [ ] Data Layer (DataSource, Repository)
- [ ] Presentation Layer (ViewModel)
- [ ] UI Layer (RegisterScreen)

---

## 1️⃣ Domain Layer

### 1.1 새로운 UseCase 생성

#### ✅ SendSignupCodeUseCase
**파일**: `domain/usecases/send_signup_code_usecase.dart`
- [ ] 파일 생성
- [ ] 이메일 형식 검증 로직
- [ ] Repository.sendSignupCode() 호출
- [ ] 예외 처리 (ValidationException, NetworkException)

#### ✅ VerifySignupCodeUseCase
**파일**: `domain/usecases/verify_signup_code_usecase.dart`
- [ ] 파일 생성
- [ ] 인증번호 형식 검증 (6자리 숫자)
- [ ] Repository.verifySignupCode() 호출
- [ ] 예외 처리 (ValidationException, NetworkException)

### 1.2 기존 UseCase 수정

#### 🔧 RegisterUseCase
**파일**: `domain/usecases/register_usecase.dart`
- [ ] checkEmailDuplicate() 제거 (백엔드에 API 없음)
- [ ] 비밀번호 확인 파라미터 추가
- [ ] 비밀번호 일치 검증 추가
- [ ] 기존 validation 로직 유지

### 1.3 Repository 인터페이스 확장

#### 🔧 AuthRepository
**파일**: `domain/repositories/auth_repository.dart`
- [ ] sendSignupCode(String email) 메서드 추가
- [ ] verifySignupCode(String email, String code) 메서드 추가
- [ ] checkEmailDuplicate() 메서드 제거 (미사용)

---

## 2️⃣ Data Layer

### 2.1 Remote DataSource 인터페이스 확장

#### 🔧 AuthRemoteDataSource
**파일**: `data/datasources/remote/auth_remote_datasource.dart`
- [ ] sendSignupCode(String email) 메서드 추가
- [ ] verifySignupCode(String email, String code) 메서드 추가
- [ ] checkEmailDuplicate() 메서드 제거

### 2.2 Remote DataSource 구현

#### 🔧 AuthRemoteDataSourceImpl
**파일**: `data/datasources/remote/auth_remote_datasource_impl.dart`
- [ ] sendSignupCode() 구현
  - [ ] POST /api/auth/send-signup-code
  - [ ] 요청: { email }
  - [ ] Dio 예외 처리
- [ ] verifySignupCode() 구현
  - [ ] POST /api/auth/verify-signup-code
  - [ ] 요청: { email, code }
  - [ ] 응답: { success }
  - [ ] Dio 예외 처리
- [ ] checkEmailDuplicate() 주석 처리된 코드 제거

### 2.3 Repository 구현

#### 🔧 AuthRepositoryImpl
**파일**: `data/repositories/auth_repository_impl.dart`
- [ ] sendSignupCode() 구현
  - [ ] remoteDataSource.sendSignupCode() 호출
  - [ ] 예외 처리
- [ ] verifySignupCode() 구현
  - [ ] remoteDataSource.verifySignupCode() 호출
  - [ ] 예외 처리
- [ ] checkEmailDuplicate() 제거

---

## 3️⃣ Presentation Layer

### 3.1 Provider 확장

#### 🔧 auth_providers.dart
**파일**: `presentation/providers/auth_providers.dart`
- [ ] sendSignupCodeUseCaseProvider 추가
- [ ] verifySignupCodeUseCaseProvider 추가

### 3.2 ViewModel 확장

#### 🔧 AuthViewModel
**파일**: `presentation/viewmodels/auth_view_model.dart`
- [ ] sendSignupCode(String email) 메서드 추가
  - [ ] state = loading
  - [ ] UseCase 호출
  - [ ] 성공 시 state 업데이트
  - [ ] 실패 시 error 처리
- [ ] verifySignupCode(String email, String code) 메서드 추가
  - [ ] state = loading
  - [ ] UseCase 호출
  - [ ] 성공 시 state 업데이트
  - [ ] 실패 시 error 처리
- [ ] register() 메서드 수정
  - [ ] confirmPassword 파라미터 추가
  - [ ] 비밀번호 확인 검증 추가

---

## 4️⃣ UI Layer

### 4.1 RegisterScreen 연동

#### 🔧 RegisterScreen
**파일**: `presentation/screens/register_screen.dart`
- [ ] _handleSendVerificationCode() 구현
  - [ ] ref.read(authViewModel).sendSignupCode() 호출
  - [ ] 성공 시 _isVerificationCodeSent = true
  - [ ] 에러 처리
- [ ] _handleVerifyCode() 구현
  - [ ] ref.read(authViewModel).verifySignupCode() 호출
  - [ ] 성공 시 _isEmailVerified = true
  - [ ] 에러 처리
- [ ] _handleSignUp() 구현
  - [ ] 모든 입력값 검증
    - [ ] 이메일 인증 완료 확인
    - [ ] 비밀번호 == 비밀번호 확인
    - [ ] 약관 동의 확인
  - [ ] ref.read(authViewModel).register() 호출
  - [ ] 성공 시 홈 화면 이동
  - [ ] 에러 처리
- [ ] ViewModel 상태 구독
  - [ ] ref.listen으로 상태 변화 감지
  - [ ] 로딩 인디케이터 표시
  - [ ] 에러 메시지 SnackBar

---

## 🧪 테스트 시나리오

### 정상 플로우
- [ ] 1. 이메일 입력 → "인증요청" 클릭 → 인증번호 전송 성공
- [ ] 2. 인증번호 입력 → "인증확인" 클릭 → 인증 성공
- [ ] 3. 닉네임, 비밀번호, 비밀번호 확인 입력 → 약관 동의
- [ ] 4. "회원가입" 클릭 → 회원가입 성공 → 홈 화면 이동

### 에러 케이스
- [ ] 이메일 형식 오류
- [ ] 이미 가입된 이메일
- [ ] 인증번호 불일치
- [ ] 인증번호 만료 (10분)
- [ ] 비밀번호 복잡도 미달
- [ ] 비밀번호 확인 불일치
- [ ] 닉네임 길이 오류
- [ ] 약관 미동의
- [ ] 이메일 인증 미완료
- [ ] 네트워크 오류

---

## 📝 구현 순서

1. ✅ Domain Layer → UseCase 생성/수정
2. ✅ Data Layer → DataSource, Repository 구현
3. ✅ Presentation Layer → Provider, ViewModel 구현
4. ✅ UI Layer → RegisterScreen 연동
5. ✅ 테스트 및 디버깅

---

## 🔗 관련 백엔드 API

- `POST /api/auth/send-signup-code` - 인증번호 전송
- `POST /api/auth/verify-signup-code` - 인증번호 확인
- `POST /api/auth/register` - 회원가입
