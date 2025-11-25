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

1. Auth 기능에서 Local DataSource가 없다면?
앱을 껐다 켤 때마다 매번 다시 로그인해야 합니다.

Local이 하는 일: 로그인 성공 시 받은 
Token
을 기기에 저장해둠.
앱 실행 시: 저장된 
Token
이 있는지 확인해서 있으면 자동 로그인 처리.
결론: "사용자가 앱을 켤 때마다 아이디/비번을 치게 할 것인가?" → 아니라면 Local DataSource(토큰 저장소)는 필수입니다.