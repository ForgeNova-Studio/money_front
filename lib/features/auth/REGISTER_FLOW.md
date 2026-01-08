# 회원가입 전체 흐름 상세 가이드

이 문서는 MoneyFlow 앱의 회원가입 프로세스를 자세히 설명합니다.

## 목차
- [회원가입 흐름 개요](#회원가입-흐름-개요)
- [아키텍처](#아키텍처)
- [단계별 상세 흐름](#단계별-상세-흐름)
- [코드 구조](#코드-구조)
- [상태 관리](#상태-관리)
- [에러 처리](#에러-처리)
- [주요 파일 설명](#주요-파일-설명)

---

## 회원가입 흐름 개요

```
┌─────────────────────────────────────────────────────────────────────┐
│                         회원가입 프로세스                              │
└─────────────────────────────────────────────────────────────────────┘

1. 사용자 정보 입력
   ├─ 닉네임 입력
   ├─ 성별 선택 (남성/여성)
   ├─ 이메일 입력
   ├─ 비밀번호 입력
   └─ 비밀번호 확인 입력

2. 이메일 인증
   ├─ [인증요청] 버튼 클릭
   ├─ 백엔드에 인증번호 전송 요청
   ├─ 이메일로 6자리 인증번호 수신
   ├─ 인증번호 입력
   └─ [인증확인] 버튼 클릭 → 인증 완료

3. 약관 동의
   └─ 이용약관 및 개인정보 이용동의 체크

4. 회원가입 완료
   ├─ [회원가입] 버튼 클릭
   ├─ 백엔드에 회원가입 요청
   ├─ JWT 토큰 수신 및 저장
   └─ 홈 화면으로 자동 이동
```

---

## 아키텍처

MoneyFlow 앱은 **Clean Architecture**를 기반으로 구현되었습니다.

```
┌──────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│                                                               │
│  ┌─────────────┐  ┌──────────────────┐  ┌────────────────┐  │
│  │   Screen    │→ │   ViewModel      │→ │     State      │  │
│  │ (UI Widget) │  │ (Riverpod)       │  │ (Freezed)      │  │
│  └─────────────┘  └──────────────────┘  └────────────────┘  │
│                            ↓                                  │
└────────────────────────────┼──────────────────────────────────┘
                             ↓
┌────────────────────────────┼──────────────────────────────────┐
│                      Domain Layer                             │
│                            ↓                                  │
│  ┌──────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │   Use Case       │→ │  Repository    │  │   Entity     │  │
│  │ (Business Logic) │  │  (Interface)   │  │ (Domain Model)│ │
│  └──────────────────┘  └────────────────┘  └──────────────┘  │
│                            ↓                                  │
└────────────────────────────┼──────────────────────────────────┘
                             ↓
┌────────────────────────────┼──────────────────────────────────┐
│                       Data Layer                              │
│                            ↓                                  │
│  ┌──────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │ Repository Impl  │→ │  Data Source   │→ │    Model     │  │
│  │                  │  │  (Remote/Local)│  │ (JSON Parse) │  │
│  └──────────────────┘  └────────────────┘  └──────────────┘  │
│                            ↓                                  │
└────────────────────────────┼──────────────────────────────────┘
                             ↓
                    ┌────────────────┐
                    │  Backend API   │
                    │  (Dio HTTP)    │
                    └────────────────┘
```

---

## 단계별 상세 흐름

### Step 1: 사용자 정보 입력

#### 1.1 닉네임 입력
- 사용자가 `CustomTextField`에 닉네임을 입력합니다.
- 입력값은 `_displayNameController`에 저장됩니다.

**유효성 검사 (회원가입 시):**
- 2자 이상 12자 이하
- 한글, 영문, 숫자만 허용

**코드 위치:** `register_screen.dart:262-266`

#### 1.2 성별 선택
- 사용자가 "남성" 또는 "여성" 버튼을 탭합니다.
- `RegisterViewModel.selectGender(Gender gender)`가 호출됩니다.
- `RegisterFormState.selectedGender`가 업데이트됩니다.

**상태 흐름:**
```dart
User Tap → RegisterViewModel.selectGender(Gender.male)
         → state.copyWith(selectedGender: Gender.male)
         → UI 자동 업데이트 (Riverpod watch)
```

**코드 위치:**
- UI: `register_screen.dart:270-345`
- ViewModel: `register_view_model.dart:26-28`
- State: `register_form_state.dart:20`

#### 1.3 이메일 입력
- 사용자가 `CustomTextField`에 이메일을 입력합니다.
- 입력값은 `_emailController`에 저장됩니다.

**유효성 검사 (회원가입 시):**
- 이메일 형식 검증 (정규식)
- 중복 체크는 인증번호 전송 시 백엔드에서 처리

**코드 위치:** `register_screen.dart:349-391`

#### 1.4 비밀번호 입력
- 사용자가 두 개의 비밀번호 필드에 입력합니다.
- 각각 `_passwordController`와 `_confirmPasswordController`에 저장됩니다.
- 눈 아이콘을 탭하면 비밀번호 표시/숨김을 토글할 수 있습니다.

**유효성 검사 (회원가입 시):**
- 8자 이상
- 영문, 숫자, 특수문자 포함
- 대문자는 선택사항 (백엔드 정책에 따라)

**코드 위치:** `register_screen.dart:437-463`

---

### Step 2: 이메일 인증

#### 2.1 인증번호 전송 요청

**사용자 액션:**
1. 이메일을 입력한 후 **[인증요청]** 버튼 클릭

**처리 흐름:**
```
RegisterScreen._handleSendVerificationCode()
  ↓
RegisterViewModel.sendVerificationCode(email)
  ↓
AuthViewModel.sendSignupCode(email)
  ↓
SendSignupCodeUseCase.call(email)
  ↓ (이메일 형식 검증)
AuthRepository.sendSignupCode(email)
  ↓
AuthRepositoryImpl.sendSignupCode(email)
  ↓
AuthRemoteDataSource.sendSignupCode(email)
  ↓
AuthRemoteDataSourceImpl.sendSignupCode(email)
  ↓ (Dio HTTP POST)
Backend API: POST /api/auth/send-signup-code
  ↓ (이메일 중복 체크 + 인증번호 생성 + 이메일 전송)
Response: { "message": "인증번호가 전송되었습니다" }
  ↓
RegisterFormState 업데이트
  ↓ (isVerificationCodeSent = true)
UI 업데이트: 인증번호 입력 필드 표시
```

**백엔드 처리:**
- 이메일 중복 체크 (이미 가입된 이메일이면 409 Conflict 반환)
- 6자리 랜덤 인증번호 생성
- 인증번호를 이메일로 전송
- 인증번호는 10분간 유효

**상태 변화:**
- `RegisterFormState.isVerificationCodeSent = true`
- 인증번호 입력 필드가 화면에 나타남

**코드 위치:**
- UI: `register_screen.dart:131-161`
- ViewModel: `register_view_model.dart:47-57`
- UseCase: `send_signup_code_usecase.dart`
- DataSource: `auth_remote_datasource_impl.dart:96-108`

#### 2.2 인증번호 확인

**사용자 액션:**
1. 이메일로 받은 6자리 인증번호를 입력
2. **[인증확인]** 버튼 클릭

**처리 흐름:**
```
RegisterScreen._handleVerifyCode()
  ↓
RegisterViewModel.verifyCode(email, code)
  ↓
AuthViewModel.verifySignupCode(email, code)
  ↓
VerifySignupCodeUseCase.call(email, code)
  ↓ (이메일 및 인증번호 형식 검증)
AuthRepository.verifySignupCode(email, code)
  ↓
AuthRepositoryImpl.verifySignupCode(email, code)
  ↓
AuthRemoteDataSource.verifySignupCode(email, code)
  ↓
AuthRemoteDataSourceImpl.verifySignupCode(email, code)
  ↓ (Dio HTTP POST)
Backend API: POST /api/auth/verify-signup-code
  ↓ (인증번호 검증)
Response: { "success": true }
  ↓
RegisterFormState 업데이트
  ↓ (isEmailVerified = true)
UI 업데이트: [인증완료] 버튼으로 변경, 이메일 입력 필드 비활성화
```

**백엔드 처리:**
- 이메일과 인증번호를 매칭하여 검증
- 인증번호가 일치하고 만료되지 않았으면 `success: true` 반환
- 인증번호 불일치 또는 만료 시 `success: false` 반환

**상태 변화:**
- `RegisterFormState.isEmailVerified = true`
- 이메일 입력 필드가 비활성화됨
- **[인증요청]** 버튼이 **[인증완료]**로 변경되고 비활성화됨

**코드 위치:**
- UI: `register_screen.dart:163-196`
- ViewModel: `register_view_model.dart:59-79`
- UseCase: `verify_signup_code_usecase.dart`
- DataSource: `auth_remote_datasource_impl.dart:110-126`

---

### Step 3: 약관 동의

**사용자 액션:**
1. "이용약관 및 개인정보 이용동의에 확인하고 동의합니다" 체크박스 클릭

**처리 흐름:**
```
User Tap → RegisterViewModel.toggleTermsAgreed()
         → state.copyWith(isTermsAgreed: !state.isTermsAgreed)
         → UI 자동 업데이트
```

**상태 변화:**
- `RegisterFormState.isTermsAgreed = true`

**향후 개선:**
- "이용약관" 및 "개인정보 이용동의" 링크를 탭하면 상세 페이지로 이동 (현재는 TODO)

**코드 위치:**
- UI: `register_screen.dart:467-555`
- ViewModel: `register_view_model.dart:31-33`

---

### Step 4: 회원가입 완료

#### 4.1 유효성 검사

**사용자 액션:**
1. **[회원가입]** 버튼 클릭

**처리 흐름:**
```
RegisterScreen._handleSignUp()
  ↓
유효성 검사 시작
  ↓
1. 이메일 인증 확인
   └─ if (!isEmailVerified) → SnackBar: "이메일 인증을 완료해주세요"
  ↓
2. 성별 선택 확인
   └─ if (selectedGender == null) → SnackBar: "성별을 선택해주세요"
  ↓
3. 비밀번호 일치 확인
   └─ if (password != confirmPassword) → SnackBar: "비밀번호가 일치하지 않습니다"
  ↓
4. 약관 동의 확인
   └─ if (!isTermsAgreed) → SnackBar: "약관 및 개인정보 이용동의에 체크해주세요"
  ↓
유효성 검사 통과
```

**코드 위치:** `register_screen.dart:43-93`

#### 4.2 회원가입 API 호출

**처리 흐름:**
```
AuthViewModel.register(email, password, confirmPassword, nickname, gender)
  ↓
RegisterUseCase.call(email, password, confirmPassword, nickname, gender)
  ↓ (입력값 재검증: 이메일, 비밀번호, 닉네임)
AuthRepository.register(email, password, nickname, gender)
  ↓
AuthRepositoryImpl.register(email, password, nickname, gender)
  ↓
AuthRemoteDataSource.register(email, password, nickname, gender)
  ↓
AuthRemoteDataSourceImpl.register(email, password, nickname, gender)
  ↓ (Dio HTTP POST)
Backend API: POST /api/auth/register
  ↓ (사용자 계정 생성 + JWT 토큰 발급)
Response: RegisterResponseModel
  {
    "accessToken": "eyJhbGci...",
    "refreshToken": "eyJhbGci...",
    "expiresIn": "3600",
    "userId": "user_123456"
  }
  ↓
Token 및 User 로컬 저장 (Flutter Secure Storage)
  ↓
AuthResult Entity 생성
  {
    user: User(userId, email, nickname, gender, ...),
    token: AuthToken(accessToken, refreshToken, expiresIn)
  }
  ↓
AuthState 업데이트
  ↓ (isAuthenticated = true, user = User(...))
UI 업데이트: 홈 화면으로 자동 이동
```

**백엔드 처리:**
1. 입력값 검증 (이메일, 비밀번호, 닉네임)
2. 이메일 중복 체크 (이미 가입된 이메일이면 409 Conflict 반환)
3. 비밀번호 해싱
4. 사용자 계정 생성 (DB 저장)
5. JWT Access Token 및 Refresh Token 발급
6. 토큰 및 userId 반환

**로컬 저장:**
1. `AuthTokenModel`을 Flutter Secure Storage에 저장
2. `UserModel`을 Flutter Secure Storage에 저장
3. 이후 앱 재시작 시 자동 로그인에 사용

**상태 변화:**
- `AuthState.isAuthenticated = true`
- `AuthState.user = User(...)`
- `AuthState.isLoading = false`

**코드 위치:**
- UI: `register_screen.dart:95-111`
- ViewModel: `auth_view_model.dart:139-173`
- UseCase: `register_usecase.dart`
- Repository: `auth_repository_impl.dart:67-106`
- DataSource: `auth_remote_datasource_impl.dart:43-65`

#### 4.3 홈 화면 이동

**처리 흐름:**
```
RegisterScreen.ref.listen(authViewModelProvider)
  ↓
if (next.isAuthenticated && next.user != null)
  ↓
Navigator.of(context).pushReplacementNamed('/home')
```

**주의 사항:**
- `pushReplacementNamed`를 사용하여 뒤로가기 시 회원가입 화면으로 돌아가지 않도록 합니다.

**코드 위치:** `register_screen.dart:209-214`

---

## 코드 구조

### Presentation Layer

#### RegisterScreen (`register_screen.dart`)
회원가입 UI를 담당하는 화면입니다.

**주요 컴포넌트:**
- TextEditingController (닉네임, 이메일, 비밀번호, 비밀번호 확인, 인증번호)
- 성별 선택 버튼 (남성/여성)
- 이메일 인증 UI (인증요청 → 인증번호 입력 → 인증확인)
- 약관 동의 체크박스
- 회원가입 버튼

**주요 메서드:**
- `_handleSignUp()`: 회원가입 버튼 클릭 시 호출
- `_handleSendVerificationCode()`: 인증요청 버튼 클릭 시 호출
- `_handleVerifyCode()`: 인증확인 버튼 클릭 시 호출

#### RegisterViewModel (`register_view_model.dart`)
회원가입 폼 상태를 관리하는 ViewModel입니다.

**주요 메서드:**
- `selectGender(Gender gender)`: 성별 선택
- `toggleTermsAgreed()`: 약관 동의 토글
- `togglePasswordVisibility()`: 비밀번호 표시/숨김 토글
- `sendVerificationCode(String email)`: 인증번호 전송
- `verifyCode(String email, String code)`: 인증번호 확인

#### RegisterFormState (`register_form_state.dart`)
회원가입 폼의 상태를 나타내는 Freezed State입니다.

**상태 필드:**
- `displayName`: 닉네임
- `email`: 이메일
- `password`: 비밀번호
- `confirmPassword`: 비밀번호 확인
- `verificationCode`: 인증번호
- `selectedGender`: 선택된 성별 (Gender?)
- `isPasswordVisible`: 비밀번호 표시 여부
- `isConfirmPasswordVisible`: 비밀번호 확인 표시 여부
- `isTermsAgreed`: 약관 동의 여부
- `isVerificationCodeSent`: 인증번호 전송 여부
- `isEmailVerified`: 이메일 인증 완료 여부

#### AuthViewModel (`auth_view_model.dart`)
인증 관련 비즈니스 로직을 처리하는 메인 ViewModel입니다.

**주요 메서드:**
- `register(...)`: 회원가입 처리
- `sendSignupCode(String email)`: 인증번호 전송
- `verifySignupCode(String email, String code)`: 인증번호 확인
- `login(...)`: 로그인
- `logout()`: 로그아웃
- `loginWithGoogle()`: Google 로그인
- `loginWithApple()`: Apple 로그인

#### AuthState (`auth_state.dart`)
인증 상태를 나타내는 Freezed State입니다.

**상태 필드:**
- `isAuthenticated`: 인증 여부
- `user`: 현재 로그인한 사용자 (User?)
- `isLoading`: 로딩 상태
- `errorMessage`: 에러 메시지 (String?)

---

### Domain Layer

#### RegisterUseCase (`register_usecase.dart`)
회원가입 비즈니스 로직을 처리하는 UseCase입니다.

**역할:**
- 입력값 검증 (이메일, 비밀번호, 비밀번호 확인, 닉네임)
- Repository 호출
- AuthResult 반환

#### SendSignupCodeUseCase (`send_signup_code_usecase.dart`)
인증번호 전송 비즈니스 로직을 처리하는 UseCase입니다.

**역할:**
- 이메일 형식 검증
- Repository 호출

#### VerifySignupCodeUseCase (`verify_signup_code_usecase.dart`)
인증번호 검증 비즈니스 로직을 처리하는 UseCase입니다.

**역할:**
- 이메일 및 인증번호 형식 검증
- Repository 호출
- 검증 결과 반환 (bool)

#### AuthRepository (`auth_repository.dart`)
인증 관련 Repository 인터페이스입니다.

**주요 메서드:**
- `register(...)`: 회원가입
- `login(...)`: 로그인
- `logout()`: 로그아웃
- `sendSignupCode(String email)`: 인증번호 전송
- `verifySignupCode(String email, String code)`: 인증번호 확인
- `getCurrentUser()`: 현재 사용자 정보 조회
- `loginWithGoogle(...)`: Google 로그인
- `loginWithApple(...)`: Apple 로그인

#### Entities
- `User`: 사용자 Entity
- `AuthToken`: 인증 토큰 Entity
- `AuthResult`: 인증 결과 (User + AuthToken)
- `Gender`: 성별 Enum (male, female, other)

---

### Data Layer

#### AuthRepositoryImpl (`auth_repository_impl.dart`)
AuthRepository의 구현체입니다.

**역할:**
1. RemoteDataSource 호출 (API 통신)
2. LocalDataSource 호출 (로컬 저장)
3. Model을 Entity로 변환
4. Entity 반환

**회원가입 처리:**
1. RemoteDataSource.register() 호출 → RegisterResponseModel 수신
2. AuthTokenModel 생성
3. UserModel 생성 (회원가입 시 입력한 정보 사용)
4. LocalDataSource에 Token 및 User 저장
5. AuthResult Entity 변환 및 반환

#### AuthRemoteDataSource (`auth_remote_datasource.dart`)
백엔드 API와 통신하는 DataSource 인터페이스입니다.

#### AuthRemoteDataSourceImpl (`auth_remote_datasource_impl.dart`)
AuthRemoteDataSource의 구현체입니다.

**역할:**
- Dio를 사용하여 HTTP 요청
- API 응답을 Model로 파싱
- DioException 처리

**주요 메서드:**
- `register(...)`: POST /api/auth/register
- `sendSignupCode(String email)`: POST /api/auth/send-signup-code
- `verifySignupCode(String email, String code)`: POST /api/auth/verify-signup-code

#### AuthLocalDataSource (`auth_local_datasource.dart`)
로컬 저장소와 통신하는 DataSource 인터페이스입니다.

#### AuthLocalDataSourceImpl (`auth_local_datasource_impl.dart`)
AuthLocalDataSource의 구현체입니다.

**역할:**
- Flutter Secure Storage를 사용하여 안전한 데이터 저장
- Token 및 User 정보 저장/조회/삭제

**주요 메서드:**
- `saveToken(AuthTokenModel token)`: 토큰 저장
- `getToken()`: 토큰 조회
- `saveUser(UserModel user)`: 사용자 정보 저장
- `getUser()`: 사용자 정보 조회
- `clearAll()`: 모든 저장 데이터 삭제

#### Models
- `RegisterResponseModel`: 회원가입 API 응답 모델
- `AuthResponseModel`: 로그인 API 응답 모델
- `AuthTokenModel`: 인증 토큰 모델
- `UserModel`: 사용자 모델

---

## 상태 관리

MoneyFlow 앱은 **Riverpod**를 사용하여 상태 관리를 수행합니다.

### 상태 관리 흐름

```
┌─────────────────────────────────────────────────────────────┐
│                         UI (Widget)                          │
│                                                               │
│  ref.watch(authViewModelProvider)                            │
│  ref.watch(registerViewModelProvider)                        │
│                                                               │
│  → State 변화 시 자동으로 UI 재렌더링                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    ViewModel (Notifier)                      │
│                                                               │
│  state = state.copyWith(...)                                 │
│                                                               │
│  → State를 불변(Immutable)하게 업데이트                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                     State (Freezed)                          │
│                                                               │
│  @freezed class RegisterFormState                            │
│                                                               │
│  → 불변 객체로 안전한 상태 관리                                 │
└─────────────────────────────────────────────────────────────┘
```

### 두 개의 ViewModel을 사용하는 이유

#### AuthViewModel
- **역할:** 인증 관련 비즈니스 로직 처리
- **관리 상태:**
  - `isAuthenticated`: 로그인 여부
  - `user`: 현재 로그인한 사용자
  - `isLoading`: API 호출 중인지 여부
  - `errorMessage`: 에러 메시지
- **사용처:** 로그인, 회원가입, 로그아웃, 소셜 로그인

#### RegisterViewModel
- **역할:** 회원가입 폼 상태 관리
- **관리 상태:**
  - 폼 입력값 (닉네임, 이메일, 비밀번호 등)
  - 성별 선택 상태
  - 이메일 인증 상태
  - 약관 동의 상태
  - 비밀번호 표시/숨김 상태
- **사용처:** RegisterScreen (회원가입 화면)

**장점:**
- **관심사 분리:** 인증 로직과 폼 상태 관리를 분리하여 코드 가독성 향상
- **재사용성:** AuthViewModel은 다른 화면(로그인, 홈)에서도 사용 가능
- **테스트 용이성:** 각 ViewModel을 독립적으로 테스트 가능

---

## 에러 처리

### 에러 발생 흐름

```
Backend API Error
  ↓
DioException (Dio)
  ↓
ExceptionHandler.handleDioException(e)
  ↓
Custom Exception (NetworkException, ValidationException, etc.)
  ↓
UseCase에서 예외 전파
  ↓
ViewModel에서 catch
  ↓
state = state.copyWith(isLoading: false, errorMessage: e.message)
  ↓
UI에서 ref.listen으로 감지
  ↓
SnackBar 표시
```

### 에러 종류

#### ValidationException
- **발생 시점:** 입력값 검증 실패
- **예시:**
  - 이메일 형식 오류
  - 비밀번호 길이 부족
  - 비밀번호 불일치
  - 이미 가입된 이메일

#### NetworkException
- **발생 시점:** 네트워크 연결 오류
- **예시:**
  - 인터넷 연결 끊김
  - 타임아웃

#### UnauthorizedException
- **발생 시점:** 인증 실패
- **예시:**
  - 잘못된 이메일/비밀번호
  - 토큰 만료

#### ServerException
- **발생 시점:** 서버 오류
- **예시:**
  - 500 Internal Server Error
  - 503 Service Unavailable

### UI 에러 표시

**RegisterScreen에서 에러 처리:**

```dart
ref.listen(authViewModelProvider, (previous, next) {
  // 에러 발생 시
  if (next.errorMessage != null && !next.isLoading) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(next.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    // 에러 메시지 표시 후 초기화
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });
  }
});
```

**코드 위치:** `register_screen.dart:209-232`

---

## 주요 파일 설명

### Presentation Layer

| 파일 | 경로 | 설명 |
|------|------|------|
| RegisterScreen | `presentation/screens/register_screen.dart` | 회원가입 UI 화면 |
| RegisterViewModel | `presentation/viewmodels/register_view_model.dart` | 회원가입 폼 상태 관리 |
| RegisterFormState | `presentation/states/register_form_state.dart` | 회원가입 폼 상태 (Freezed) |
| AuthViewModel | `presentation/viewmodels/auth_view_model.dart` | 인증 비즈니스 로직 처리 |
| AuthState | `presentation/states/auth_state.dart` | 인증 상태 (Freezed) |
| CustomTextField | `presentation/widgets/custom_text_field.dart` | 커스텀 텍스트 입력 필드 |

### Domain Layer

| 파일 | 경로 | 설명 |
|------|------|------|
| RegisterUseCase | `domain/usecases/register_usecase.dart` | 회원가입 비즈니스 로직 |
| SendSignupCodeUseCase | `domain/usecases/send_signup_code_usecase.dart` | 인증번호 전송 비즈니스 로직 |
| VerifySignupCodeUseCase | `domain/usecases/verify_signup_code_usecase.dart` | 인증번호 검증 비즈니스 로직 |
| AuthRepository | `domain/repositories/auth_repository.dart` | 인증 Repository 인터페이스 |
| User | `domain/entities/user.dart` | 사용자 Entity |
| AuthToken | `domain/entities/auth_token.dart` | 인증 토큰 Entity |
| AuthResult | `domain/entities/auth_result.dart` | 인증 결과 Entity |
| Gender | `domain/entities/gender.dart` | 성별 Enum |

### Data Layer

| 파일 | 경로 | 설명 |
|------|------|------|
| AuthRepositoryImpl | `data/repositories/auth_repository_impl.dart` | AuthRepository 구현체 |
| AuthRemoteDataSource | `data/datasources/remote/auth_remote_datasource.dart` | Remote DataSource 인터페이스 |
| AuthRemoteDataSourceImpl | `data/datasources/remote/auth_remote_datasource_impl.dart` | Remote DataSource 구현체 (Dio) |
| AuthLocalDataSource | `data/datasources/local/auth_local_datasource.dart` | Local DataSource 인터페이스 |
| AuthLocalDataSourceImpl | `data/datasources/local/auth_local_datasource_impl.dart` | Local DataSource 구현체 (Secure Storage) |
| RegisterResponseModel | `data/models/register_response_model.dart` | 회원가입 API 응답 모델 |
| AuthResponseModel | `data/models/auth_response_model.dart` | 로그인 API 응답 모델 |
| AuthTokenModel | `data/models/auth_token_model.dart` | 인증 토큰 모델 |
| UserModel | `data/models/user_model.dart` | 사용자 모델 |

---

## 보안 고려사항

### 1. 비밀번호 저장
- **백엔드:** 비밀번호는 bcrypt 등의 해싱 알고리즘으로 해싱하여 저장됩니다.
- **프론트엔드:** 비밀번호는 평문으로 전송되지만 HTTPS를 통해 암호화됩니다.

### 2. 토큰 저장
- **Flutter Secure Storage 사용:** Access Token과 Refresh Token은 Flutter Secure Storage에 안전하게 저장됩니다.
- **자동 암호화:** iOS는 Keychain, Android는 KeyStore를 사용하여 자동으로 암호화됩니다.

### 3. 이메일 인증
- **중복 가입 방지:** 이메일 인증을 통해 중복 가입을 방지합니다.
- **봇 방지:** 인증번호 전송을 통해 자동화된 봇의 가입을 어렵게 만듭니다.

### 4. 입력값 검증
- **클라이언트 검증:** 사용자 경험 향상을 위해 클라이언트에서 먼저 검증합니다.
- **서버 검증:** 보안을 위해 서버에서도 동일한 검증을 수행합니다.

---

## 향후 개선 사항

### 1. 이용약관 및 개인정보 이용동의 페이지
- 현재는 TODO로 남아있으며, 실제 약관 페이지로 이동하는 기능이 필요합니다.

### 2. 비밀번호 재설정 (find_password_screen.dart, reset_password_screen.dart)
- 현재 화면은 구현되어 있지만, 백엔드 API 연동이 필요합니다.
- API 엔드포인트는 이미 정의되어 있습니다:
  - `POST /api/auth/reset-password/send-code`
  - `POST /api/auth/reset-password`

### 3. Token 갱신 (Refresh Token)
- 현재 백엔드에 Token 갱신 API가 구현되지 않았습니다.
- `auth_remote_datasource_impl.dart`의 `refreshToken` 메서드는 `UnimplementedError`를 발생시킵니다.
- 향후 백엔드에서 Token 갱신 API가 추가되면 구현 예정입니다.

### 4. 소셜 로그인 성별 정보
- Google 및 Apple 로그인 시 성별 정보를 받아오는 로직이 필요할 수 있습니다.
- 현재는 소셜 로그인 시 성별을 `null`로 저장합니다.

### 5. 프로필 이미지
- 회원가입 시 프로필 이미지를 설정할 수 있는 기능이 필요할 수 있습니다.
- 현재는 `profileImageUrl`을 `null`로 저장합니다.

---

## FAQ

### Q1. 왜 회원가입 응답에 사용자 정보(profile)가 없나요?

**A:** 회원가입 시 클라이언트가 이미 이메일, 닉네임, 성별을 알고 있기 때문에 백엔드에서 다시 보낼 필요가 없습니다. 따라서 회원가입 응답은 토큰과 userId만 포함하며, 클라이언트는 이 정보와 입력했던 정보를 조합하여 User Entity를 생성합니다.

**코드 위치:** `register_response_model.dart:32-59`

### Q2. RegisterViewModel과 AuthViewModel을 따로 나눈 이유는?

**A:**
- **RegisterViewModel:** 회원가입 폼의 상태(성별 선택, 이메일 인증 상태, 약관 동의 등)를 관리합니다.
- **AuthViewModel:** 인증 관련 비즈니스 로직(로그인, 회원가입, 로그아웃)을 처리합니다.

이렇게 분리하면 관심사가 명확히 구분되어 코드 가독성과 유지보수성이 향상됩니다.

### Q3. gender 필드가 백엔드에 전송되나요?

**A:** 네, 현재 코드는 gender 필드를 백엔드에 전송하도록 수정되었습니다. 이전에는 주석 처리되어 있었지만, 이제는 활성화되어 있습니다.

**코드 위치:** `auth_remote_datasource_impl.dart:57`

### Q4. 이메일 인증번호는 몇 분간 유효한가요?

**A:** 이메일 인증번호는 **10분간** 유효합니다. 10분이 지나면 인증번호가 만료되어 새로 요청해야 합니다.

### Q5. 비밀번호 유효성 검사 규칙은?

**A:**
- 8자 이상
- 영문, 숫자, 특수문자 포함
- 대문자는 선택사항 (백엔드 정책에 따라 `requireUppercase: false`)

**코드 위치:** `register_usecase.dart:76-77`

---

## 참고 자료

- [API 응답 구조 문서](./API_RESPONSE.md)
- [Flutter Riverpod 공식 문서](https://riverpod.dev/)
- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [Dio 공식 문서](https://pub.dev/packages/dio)
- [Flutter Secure Storage 공식 문서](https://pub.dev/packages/flutter_secure_storage)

---

**작성일:** 2025년 12월 4일
**버전:** 1.0.0
**작성자:** MoneyFlow Development Team
