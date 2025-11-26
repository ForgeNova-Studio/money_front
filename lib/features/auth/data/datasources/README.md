# Data Sources

## 개요

Data Source는 **실제 데이터를 가져오고 저장하는 계층**입니다.
- Repository와 실제 데이터 저장소 사이의 인터페이스
- 데이터의 출처(API, Local Storage 등)를 추상화
- Clean Architecture의 Data Layer에 속함

---

## Data Source 종류

### 1. Remote Data Source
**역할**: 외부 API 서버와 통신
- API 호출
- 응답 데이터를 Model로 변환
- 네트워크 에러 처리

### 2. Local Data Source
**역할**: 로컬 저장소 관리
- SharedPreferences
- SQLite
- Secure Storage
- 캐싱

---

## 아키텍처 흐름

```
Presentation (UI)
       ↓
   Use Case
       ↓
  Repository (Interface) ← Domain Layer
       ↓
Repository Implementation
       ↓
   ┌──────┴──────┐
   ↓             ↓
Remote DS    Local DS ← Data Layer
   ↓             ↓
  API        Storage
```

---

## 기본 구조

### Remote Data Source
```
datasources/
  ├── auth_remote_datasource.dart          # 인터페이스
  └── auth_remote_datasource_impl.dart     # 구현체
```

### Local Data Source
```
datasources/
  ├── auth_local_datasource.dart           # 인터페이스
  └── auth_local_datasource_impl.dart      # 구현체
```

---

## 왜 인터페이스와 구현체를 분리하나?

### 1. 테스트 용이성
```dart
// 테스트 시 Mock으로 대체 가능
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login(...) async {
    return AuthResponseModel(...);  // 가짜 데이터
  }
}
```

### 2. 구현체 교체 가능
```dart
// Dio → Retrofit 변경 가능
class AuthRemoteDataSourceRetrofitImpl implements AuthRemoteDataSource {
  // Retrofit으로 구현
}

// Repository는 변경 불필요!
```

### 3. 의존성 역전 (DIP)
```dart
// Repository가 구체적인 구현에 의존하지 않음
class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource;  // 인터페이스에 의존
}
```

---

## Remote Data Source vs Repository

### Remote Data Source
- **역할**: API 호출만 담당
- **반환**: Data Model (AuthResponseModel)
- **예외**: DioException → Custom Exception 변환
- **관심사**: "어떻게 데이터를 가져오는가?"

```dart
Future<AuthResponseModel> login(...) async {
  final response = await dio.post('/auth/login', ...);
  return AuthResponseModel.fromJson(response.data);
}
```

### Repository
- **역할**: 여러 Data Source 조합 + 비즈니스 로직
- **반환**: Domain Entity (AuthResult)
- **관심사**: "어떤 데이터를 어디서 가져올지 결정"

```dart
Future<AuthResult> login(...) async {
  // 1. Remote에서 데이터 가져오기
  final response = await remoteDataSource.login(...);

  // 2. Local에 저장
  await localDataSource.saveToken(...);

  // 3. Domain Entity로 변환
  return response.toEntity();
}
```

---

## 작성 규칙

### 1. 인터페이스는 순수 Dart
```dart
// ✅ 외부 패키지 의존 없음
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(...);
}
```

### 2. 구현체는 외부 패키지 사용
```dart
// ✅ Dio, SharedPreferences 등 사용
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;  // 외부 패키지
}
```

### 3. Model 반환 (Entity 아님!)
```dart
// ✅ Data Model 반환
Future<AuthResponseModel> login(...);

// ❌ Domain Entity 반환 금지
Future<AuthResult> login(...);
```

**이유**: Data Source는 Data Layer에 속하므로 Data Model 사용

---

## 예외 처리

### Remote Data Source
```dart
@override
Future<AuthResponseModel> login(...) async {
  try {
    final response = await dio.post(...);
    return AuthResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    // ✅ Custom Exception으로 변환
    throw ExceptionHandler.handleDioException(e);
  }
}
```

### Local Data Source
```dart
@override
Future<void> saveToken(AuthTokenModel token) async {
  try {
    await prefs.setString('token', jsonEncode(token.toJson()));
  } catch (e) {
    // ✅ Storage Exception으로 변환
    throw StorageException('토큰 저장 실패: $e');
  }
}
```

---

## 네이밍 컨벤션

### Remote Data Source
```dart
// API 엔드포인트와 유사하게
Future<AuthResponseModel> login(...)         // POST /auth/login
Future<AuthResponseModel> register(...)      // POST /auth/register
Future<UserModel> getCurrentUser()           // GET /auth/me
Future<AuthTokenModel> refreshToken(...)     // POST /auth/refresh
```

### Local Data Source
```dart
// 동작 중심 네이밍
Future<void> saveToken(...)         // 저장
Future<AuthTokenModel?> getToken()  // 조회
Future<void> deleteToken()          // 삭제
Future<void> clearAll()             // 전체 삭제
```

---

## 작성 체크리스트

### Remote Data Source
- [ ] 인터페이스 작성 (`auth_remote_datasource.dart`)
- [ ] 구현체 작성 (`auth_remote_datasource_impl.dart`)
- [ ] Dio 의존성 주입
- [ ] API 엔드포인트 정의
- [ ] DioException → Custom Exception 변환
- [ ] Model 반환 (fromJson 사용)

### Local Data Source
- [ ] 인터페이스 작성 (`auth_local_datasource.dart`)
- [ ] 구현체 작성 (`auth_local_datasource_impl.dart`)
- [ ] SharedPreferences 의존성 주입
- [ ] JSON 직렬화/역직렬화
- [ ] 에러 처리 (StorageException)
- [ ] Key 상수 정의

---

## 현재 작성 상태

### ✅ 작성 완료

#### Remote Data Source
- **파일**: `auth_remote_datasource.dart`, `auth_remote_datasource_impl.dart`
- **메서드**:
  - login() - 로그인 API
  - register() - 회원가입 API
  - getCurrentUser() - 현재 사용자 정보 조회
  - refreshToken() - 토큰 갱신
  - checkEmailDuplicate() - 이메일 중복 확인

#### Local Data Source
- **파일**: `auth_local_datasource.dart`, `auth_local_datasource_impl.dart`
- **메서드**:
  - saveToken() - 토큰 저장
  - getToken() - 토큰 불러오기
  - deleteToken() - 토큰 삭제
  - saveUser() - 사용자 정보 저장
  - getUser() - 사용자 정보 불러오기
  - deleteUser() - 사용자 정보 삭제
  - clearAll() - 모든 데이터 삭제
  - hasToken() - 토큰 존재 여부 확인

---

## Remote Data Source 상세

### 인터페이스 (`auth_remote_datasource.dart`)

**역할**: API 통신 메서드 정의
- 순수 Dart 인터페이스 (외부 패키지 의존 없음)
- Data Model 반환
- 메서드 시그니처만 정의

**포함된 메서드:**
```dart
Future<AuthResponseModel> login({...})          // POST /api/auth/login
Future<AuthResponseModel> register({...})       // POST /api/auth/register
Future<UserModel> getCurrentUser()              // GET /api/auth/me
Future<AuthTokenModel> refreshToken(String)     // POST /api/auth/refresh
Future<bool> checkEmailDuplicate(String)        // GET /api/auth/check-email
```

---

### 구현체 (`auth_remote_datasource_impl.dart`)

**역할**: Dio를 사용한 실제 API 호출 구현

**의존성:**
- `Dio` - HTTP 클라이언트
- `ApiConstants` - API 엔드포인트 상수
- `ExceptionHandler` - 예외 변환

**API 엔드포인트:**
```dart
login:              POST   /api/auth/login
register:           POST   /api/auth/register
getCurrentUser:     GET    /api/auth/me
refreshToken:       POST   /api/auth/refresh
checkEmailDuplicate:GET    /api/auth/check-email
```

**예외 처리 흐름:**
```
DioException 발생
    ↓
ExceptionHandler.handleDioException(e)
    ↓
Custom Exception (NetworkException, UnauthorizedException 등)
    ↓
Repository로 전파
```

**사용 예시:**
```dart
// 의존성 주입
final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
final remoteDataSource = AuthRemoteDataSourceImpl(dio: dio);

// 로그인 호출
try {
  final response = await remoteDataSource.login(
    email: 'user@example.com',
    password: 'password123',
  );
  // response: AuthResponseModel
} on UnauthorizedException catch (e) {
  print('로그인 실패: ${e.message}');
} on NetworkException catch (e) {
  print('네트워크 오류: ${e.message}');
}
```

---

## Local Data Source 상세

### 인터페이스 (`auth_local_datasource.dart`)

**역할**: 로컬 저장소 메서드 정의
- 순수 Dart 인터페이스 (외부 패키지 의존 없음)
- Data Model 사용
- 메서드 시그니처만 정의

**포함된 메서드:**
```dart
Future<void> saveToken(AuthTokenModel)      // 토큰 저장
Future<AuthTokenModel?> getToken()          // 토큰 불러오기
Future<void> deleteToken()                  // 토큰 삭제
Future<void> saveUser(UserModel)            // 사용자 정보 저장
Future<UserModel?> getUser()                // 사용자 정보 불러오기
Future<void> deleteUser()                   // 사용자 정보 삭제
Future<void> clearAll()                     // 모든 데이터 삭제
Future<bool> hasToken()                     // 토큰 존재 여부
```

---

### 구현체 (`auth_local_datasource_impl.dart`)

**역할**: SharedPreferences를 사용한 실제 저장소 구현

**의존성:**
- `SharedPreferences` - 로컬 저장소
- `dart:convert` - JSON 직렬화/역직렬화

**Storage Key 상수:**
```dart
_keyToken = 'auth_token'    // 토큰 저장 키
_keyUser = 'auth_user'      // 사용자 정보 저장 키
```

**데이터 저장 흐름:**
```
Model (AuthTokenModel/UserModel)
    ↓
.toJson() - Map<String, dynamic>
    ↓
jsonEncode() - String
    ↓
SharedPreferences.setString()
    ↓
로컬 저장소
```

**데이터 불러오기 흐름:**
```
SharedPreferences.getString()
    ↓
jsonDecode() - Map<String, dynamic>
    ↓
Model.fromJson() or Model.fromStorage()
    ↓
Model (AuthTokenModel/UserModel)
```

**주요 특징:**

1. **토큰 저장 시 fromStorage 사용**
   ```dart
   // 저장할 때
   token.toJson() → JSON String → Storage

   // 불러올 때
   Storage → JSON String → fromStorage() → Model
   // fromStorage는 expiresAt(DateTime)을 처리
   ```

2. **에러 처리**
   ```dart
   try {
     await prefs.setString(...);
   } catch (e) {
     throw StorageException('저장 실패: $e');
   }
   ```

3. **일괄 삭제 (clearAll)**
   ```dart
   await Future.wait([
     prefs.remove(_keyToken),
     prefs.remove(_keyUser),
   ]);
   // 여러 작업을 병렬로 실행
   ```

**사용 예시:**
```dart
// 의존성 주입
final prefs = await SharedPreferences.getInstance();
final localDataSource = AuthLocalDataSourceImpl(prefs: prefs);

// 토큰 저장
final token = AuthTokenModel(
  accessToken: 'abc',
  refreshToken: 'xyz',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);
await localDataSource.saveToken(token);

// 토큰 불러오기
final savedToken = await localDataSource.getToken();
if (savedToken != null && !savedToken.toEntity().isExpired) {
  print('유효한 토큰: ${savedToken.accessToken}');
}

// 로그아웃 (모든 데이터 삭제)
await localDataSource.clearAll();
```

**기존 StorageService와의 차이:**

| 구분 | 기존 StorageService | AuthLocalDataSource |
|------|-------------------|-------------------|
| **구조** | 단일 클래스 | 인터페이스 + 구현체 |
| **데이터 타입** | String (개별 필드) | Model (전체 객체) |
| **저장 방식** | 필드별 저장 | JSON 직렬화 |
| **테스트** | 어려움 | 쉬움 (Mock 가능) |
| **확장성** | 낮음 | 높음 |

```dart
// 기존 방식
await storage.saveTokens(accessToken, refreshToken);
await storage.saveUserId(userId);

// 새 방식
await localDataSource.saveToken(tokenModel);  // 한 번에 저장
await localDataSource.saveUser(userModel);    // 한 번에 저장
```

---

## 참고 자료

- [Clean Architecture - Data Layer](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Repository Pattern](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design)

---

## 자동 로그인 & 지속 로그인 메커니즘

### 왜 Local DataSource가 필수인가?

**Q: Local DataSource 없이 앱을 만들면?**

**A: 앱을 종료할 때마다 매번 다시 로그인해야 합니다!** ❌

#### 메모리만 사용하는 경우 (Local DataSource 없음)

```dart
// ❌ 메모리에만 저장
String? accessToken;
String? refreshToken;

login() {
  accessToken = response.accessToken;  // 메모리에만 저장
  refreshToken = response.refreshToken;
}

// 앱 종료 → 메모리 초기화 → 토큰 사라짐 💨
// 앱 재시작 → 토큰 없음 → 다시 로그인 필요!
```

**문제점:**
- 앱 종료 시 → 메모리 초기화 → 토큰 삭제
- 앱 재시작 시 → 로그인 필요
- **앱을 닫을 때마다 재로그인** (매우 나쁜 UX)

#### Local DataSource를 사용하는 경우 (현재 구조)

```dart
// ✅ 영구 저장소에 저장
login() async {
  final response = await remoteDataSource.login(...);

  // SharedPreferences(디스크)에 저장
  await localDataSource.saveToken(tokenModel);  // 💾 영구 저장
  await localDataSource.saveUser(userModel);
}

// 앱 재시작 시
checkLogin() async {
  final token = await localDataSource.getToken();  // 토큰이 여전히 있음! ✅

  if (token != null && !token.isExpired) {
    // 자동 로그인!
  }
}
```

**장점:**
- 앱 종료해도 토큰이 **디바이스에 저장**되어 있음 💾
- 앱 재시작 시 → 저장된 토큰 확인 → **자동 로그인** ✅
- 사용자가 명시적으로 로그아웃하기 전까지 **계속 로그인 유지**

---

### 자동 로그인 전체 흐름

#### 1️⃣ 최초 로그인 시

```
사용자 로그인
    ↓
POST /api/auth/login
    ↓
Access Token + Refresh Token 수신
    ↓
localDataSource.saveToken(tokenModel)  ← 💾 디스크에 저장
localDataSource.saveUser(userModel)
    ↓
로그인 성공 (홈 화면 이동)
```

#### 2️⃣ 앱 재시작 시 (자동 로그인)

```
앱 시작
    ↓
AuthViewModel.build() 실행
    ↓
_checkCurrentUser() 호출
    ↓
localDataSource.getToken() ← 💾 저장된 토큰 확인
    ↓
토큰이 있나?
    ├─ 없음 → 로그인 화면 표시
    └─ 있음 ↓
        ↓
    GET /api/auth/me (토큰 유효성 검증 + 최신 사용자 정보)
        ↓
    토큰이 유효한가?
        ├─ 유효함 (200 OK)
        │   ↓
        │   localDataSource.saveUser(최신 정보)  ← 캐시 업데이트
        │   ↓
        │   자동 로그인 성공! ✅
        │
        └─ 만료됨 (401 Unauthorized)
            ↓
            Refresh Token으로 갱신 시도
            ↓
            성공? → 자동 로그인 ✅
            실패? → 로그아웃 처리 ❌
```

#### 3️⃣ 오프라인 상태

```
앱 시작 (인터넷 없음)
    ↓
GET /api/auth/me 호출 → NetworkException 발생
    ↓
Repository의 catch 블록에서 처리
    ↓
localDataSource.getUser()  ← 캐시된 사용자 정보 사용
    ↓
캐시 데이터로 자동 로그인! ✅ (오프라인 대응)
```

---

### 토큰 갱신 전략

#### Access Token vs Refresh Token

| 토큰 종류 | 유효 기간 | 용도 | 저장 위치 |
|----------|---------|------|----------|
| **Access Token** | 짧음 (1시간) | API 요청 시 사용 | localDataSource |
| **Refresh Token** | 김 (30일) | Access Token 갱신용 | localDataSource |

#### 토큰 만료 처리 흐름

```
API 요청 (예: GET /api/expenses)
    ↓
Authorization: Bearer {accessToken}
    ↓
401 Unauthorized (토큰 만료!)
    ↓
Dio Interceptor가 감지 (onError)
    ↓
localDataSource.getToken() → Refresh Token 조회
    ↓
POST /api/auth/refresh (Refresh Token 전송)
    ↓
새 Access Token 수신
    ↓
localDataSource.saveToken(새 토큰)  ← 💾 저장
    ↓
원래 요청 재시도 (새 Access Token으로)
    ↓
성공! ✅ (사용자는 모르게 처리됨)
```

#### 현재 구현 상태

⚠️ **주의**: 현재 Interceptor의 토큰 자동 갱신 로직은 TODO 상태입니다!

```dart
// lib/core/providers/core_providers.dart (55-61행)
@override
void onError(DioException err, ErrorInterceptorHandler handler) {
  if (err.response?.statusCode == 401) {
    // 토큰 만료 처리
    // TODO: 로그인 화면으로 이동  ⚠️ 구현 필요!
  }
  handler.next(err);
}
```

**개선 필요 사항:**
- 401 에러 발생 시 Refresh Token으로 자동 갱신
- Refresh Token도 만료된 경우 로그아웃 처리
- 갱신 성공 시 원래 요청 재시도

---

### 데이터 저장 메커니즘

#### AuthRepository에서 Local/Remote 협력

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart

@override
Future<User?> getCurrentUser() async {
  try {
    // 1. Remote에서 최신 정보 가져오기 ⭐
    final userModel = await remoteDataSource.getCurrentUser();  // GET /api/auth/me

    // 2. Local 캐시 업데이트 ⭐
    await localDataSource.saveUser(userModel);  // 💾 디스크에 저장

    return userModel.toEntity();
  } catch (e) {
    if (e is NetworkException) {
      // 3. 네트워크 오류 시 로컬 캐시 사용 ⭐
      final localUser = await localDataSource.getUser();  // 💾 캐시에서 로드
      if (localUser != null) {
        return localUser.toEntity();  // 오프라인 대응!
      }
    } else if (e is UnauthorizedException) {
      // 4. 인증 실패 시 로컬 데이터 삭제 ⭐
      await localDataSource.clearAll();  // 💾 캐시 삭제
      return null;
    }

    rethrow;
  }
}
```

**주요 포인트:**
1. **Remote 우선**: 항상 최신 정보를 가져오려고 시도
2. **Local 캐싱**: 성공 시 Local에 저장 (다음번 오프라인 대응)
3. **오프라인 대응**: 실패 시 Local 캐시 사용
4. **인증 실패 처리**: 401 에러 시 Local 데이터 삭제

---

### 영구 저장소 비교

#### 1. SharedPreferences (현재 사용 중)

```dart
// 장점
✅ 간단하고 사용하기 쉬움
✅ 빠른 read/write 성능
✅ key-value 저장에 적합

// 단점
⚠️ 암호화되지 않음 (토큰이 평문으로 저장)
⚠️ 보안에 취약
⚠️ 루팅/탈옥 기기에서 접근 가능
```

**저장 위치:**
- Android: `/data/data/com.app/shared_prefs/`
- iOS: `~/Library/Preferences/`

**데이터 예시:**
```json
{
  "auth_token": "{\"accessToken\":\"abc123\",\"refreshToken\":\"xyz789\",...}",
  "auth_user": "{\"userId\":\"user123\",\"email\":\"test@test.com\",...}"
}
```

#### 2. flutter_secure_storage (권장)

```dart
// 장점
✅ 암호화하여 저장 🔒
✅ iOS Keychain / Android Keystore 사용
✅ 안전한 토큰 저장
✅ 루팅/탈옥에도 상대적으로 안전

// 단점
⚠️ SharedPreferences보다 느림
⚠️ 설정이 조금 더 복잡
```

**사용 예시:**
```dart
final storage = FlutterSecureStorage();

// 저장 (암호화됨)
await storage.write(key: 'access_token', value: token);

// 조회 (복호화됨)
final token = await storage.read(key: 'access_token');
```

#### 비교표

| 기능 | SharedPreferences | SecureStorage |
|------|------------------|---------------|
| 암호화 | ❌ 평문 저장 | ✅ 암호화 저장 |
| 속도 | ⚡ 빠름 | 🐢 상대적으로 느림 |
| 보안 | ⚠️ 취약 | ✅ 안전 |
| 사용 편의성 | ✅ 매우 쉬움 | ✅ 쉬움 |
| 토큰 저장 | ⚠️ 비권장 | ✅ 권장 |

---

### 보안 고려사항

#### 1. 토큰 저장 보안

**현재 (SharedPreferences):**
```dart
// ⚠️ 평문으로 저장됨!
await prefs.setString('access_token', 'eyJhbGciOiJIUz...');

// 누구나 읽을 수 있음:
// adb shell
// run-as com.yourapp
// cat shared_prefs/FlutterSharedPreferences.xml
```

**권장 (SecureStorage):**
```dart
// ✅ 암호화되어 저장
await storage.write(key: 'access_token', value: token);

// iOS: Keychain에 암호화 저장
// Android: Android Keystore에 암호화 저장
```

#### 2. Refresh Token 관리

- Access Token: 짧은 유효기간 (1시간) → 탈취되어도 피해 최소화
- Refresh Token: 긴 유효기간 (30일) → **반드시 암호화 저장 필요**
- Refresh Token 탈취 시 → 장기간 접근 가능 → 매우 위험!

#### 3. 로그아웃 시 완전 삭제

```dart
@override
Future<void> logout() async {
  // ✅ 모든 인증 데이터 삭제
  await localDataSource.clearAll();

  // 필요 시 서버에도 알림
  // await remoteDataSource.logout();
}
```

#### 4. 토큰 만료 시간 검증

```dart
// 저장된 토큰 사용 전 만료 확인
final token = await localDataSource.getToken();
if (token != null && !token.toEntity().isExpired) {
  // 유효한 토큰 사용
} else {
  // 만료된 토큰 → 재로그인 또는 갱신
}
```

---

### 결론: Local DataSource의 역할

| 기능 | Local DataSource의 역할 |
|------|----------------------|
| **자동 로그인** | 저장된 토큰으로 앱 재시작 시 자동 로그인 |
| **지속 로그인** | 사용자가 로그아웃하기 전까지 계속 로그인 유지 |
| **오프라인 대응** | 네트워크 오류 시 캐시된 데이터 사용 |
| **성능 향상** | API 호출 없이 로컬 데이터로 빠른 응답 |
| **토큰 관리** | Access Token, Refresh Token 영구 저장 |

**핵심 메시지:**
> Local DataSource 없이는 진정한 의미의 **자동 로그인/지속 로그인이 불가능**합니다.
> 사용자가 앱을 닫을 때마다 다시 로그인해야 하는 불편함을 겪게 됩니다.

---

### 개선 권장사항

#### 1. SecureStorage로 마이그레이션
```dart
// 현재: SharedPreferences 사용
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;  // ⚠️ 평문 저장
}

// 개선: SecureStorage 사용
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;  // ✅ 암호화 저장
}
```

#### 2. Interceptor 토큰 자동 갱신 구현
```dart
// TODO 제거하고 실제 구현 필요
@override
void onError(DioException err, ErrorInterceptorHandler handler) async {
  if (err.response?.statusCode == 401) {
    // ✅ Refresh Token으로 자동 갱신 로직 추가
    final newToken = await authRepository.refreshToken(...);
    // ✅ 원래 요청 재시도
  }
  handler.next(err);
}
```

#### 3. 토큰 만료 시간 체크
```dart
// 토큰 사용 전 항상 만료 확인
final token = await localDataSource.getToken();
if (token == null || token.toEntity().isExpired) {
  // Refresh Token으로 갱신 또는 재로그인
}
```

---