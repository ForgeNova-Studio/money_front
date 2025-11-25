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
- **Remote Data Source** (`auth_remote_datasource.dart`, `auth_remote_datasource_impl.dart`)
  - login() - 로그인 API
  - register() - 회원가입 API
  - getCurrentUser() - 현재 사용자 정보 조회
  - refreshToken() - 토큰 갱신
  - checkEmailDuplicate() - 이메일 중복 확인

### ⏳ 예정
- Local Data Source

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

## 참고 자료

- [Clean Architecture - Data Layer](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Repository Pattern](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design)
