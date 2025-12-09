# JWT Token 세션 관리 개선 작업

> 작성일: 2025-12-09
> 상태: TODO
> 우선순위: HIGH

## 📋 목차
1. [현재 상태 요약](#현재-상태-요약)
2. [발견된 문제점](#발견된-문제점)
3. [작업 목록](#작업-목록)
4. [참고 정보](#참고-정보)

---

## 현재 상태 요약

### ✅ 정상 작동하는 부분
- 로그인/회원가입 시 Access Token + Refresh Token 발급
- SharedPreferences에 토큰 저장
- 앱 시작 시 자동 로그인 (GET /api/auth/me)
- API 요청 시 Bearer 토큰 자동 첨부
- 백엔드의 완전한 Refresh Token 구현 (Rotation 정책 포함)

### ❌ 미완성/문제 있는 부분
1. **토큰 저장소 불일치**: 두 개의 독립적인 저장소 사용
2. **Refresh Token 로직 미구현**: 프론트엔드에서 구현 안됨
3. **401 에러 처리 없음**: Access Token 만료 시 자동 갱신 없음
4. **expiresIn 필드 미사용**: 백엔드가 제공하지 않음

---

## 발견된 문제점

### 🔴 CRITICAL: 토큰 저장소 불일치

**문제**: 두 개의 독립적인 저장소가 존재하여 토큰 동기화 안됨

#### 1. `StorageService` (사용 중: BaseApiService)
**파일**: `lib/core/services/storage_service.dart`
```dart
static const String _keyAccessToken = 'access_token';
static const String _keyRefreshToken = 'refresh_token';
```
- `BaseApiService`의 `_AuthInterceptor`가 여기서 토큰 읽음
- 단순히 문자열만 저장

#### 2. `AuthLocalDataSource` (사용 중: AuthRepository)
**파일**: `lib/features/auth/data/datasources/local/auth_local_datasource_impl.dart`
```dart
static const String _keyToken = 'auth_token';
static const String _keyUser = 'auth_user';
```
- 로그인 시 여기에 `AuthTokenModel` (JSON) 저장
- `expiresAt` 등 메타데이터 포함

**결과**:
- 로그인 후 `AuthLocalDataSource`에만 저장됨
- `_AuthInterceptor`는 `StorageService`에서 읽으려 하므로 토큰을 찾지 못할 가능성

**영향 범위**:
- `lib/core/services/base_api_service.dart:44` - 토큰 읽기
- `lib/features/auth/data/repositories/auth_repository_impl.dart:59-60` - 토큰 저장

---

### 🔴 HIGH: Refresh Token 로직 미구현

#### 백엔드: ✅ 완전 구현됨
- **엔드포인트**: `POST /api/auth/refresh`
- **파일**: `money_back/src/main/java/com/moneyflow/service/AuthService.java:532-584`
- **기능**:
  - Refresh Token 검증 (JWT + DB)
  - 기존 토큰 무효화 (Rotation)
  - 새 Access Token + Refresh Token 발급

**요청**:
```json
{
  "refreshToken": "eyJhbGc..."
}
```

**응답**:
```json
{
  "userId": "xxx",
  "accessToken": "new_access_token",
  "refreshToken": "new_refresh_token",
  "profile": {...}
}
```

#### 프론트엔드: ❌ 미구현

**파일**: `lib/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart:79-94`

```dart
@override
Future<AuthTokenModel> refreshToken(String refreshToken) async {
  // TODO: 백엔드에 refreshToken API가 없음. JWT 토큰 갱신 방법 확인 필요
  throw UnimplementedError('refreshToken API not implemented in backend');
}
```

⚠️ **주석이 잘못됨!** 백엔드는 이미 구현되어 있음. 프론트만 구현 필요.

---

### 🟡 MEDIUM: 401 에러 자동 처리 없음

**파일**: `lib/core/services/base_api_service.dart:52-58`

```dart
@override
void onError(DioException err, ErrorInterceptorHandler handler) {
  if (err.response?.statusCode == 401) {
    // 토큰 만료 처리
    // TODO: 로그인 화면으로 이동
  }
  handler.next(err);
}
```

**현재 동작**:
- Access Token 만료 시 → 401 에러 발생
- 자동 갱신 없이 그냥 에러 전파
- 사용자가 다시 로그인해야 함

**필요한 동작**:
1. 401 에러 감지
2. Refresh Token으로 자동 갱신 시도
3. 성공 시 원래 요청 재시도
4. 실패 시 로그아웃 + 로그인 화면 이동

---

### 🟡 MEDIUM: expiresIn 필드 미제공

**백엔드 응답**: `LoginResponse.java`에 `expiresIn` 필드 없음

**파일**: `money_back/src/main/java/com/moneyflow/dto/response/LoginResponse.java:14-30`

```java
public class LoginResponse {
    private UUID userId;
    private String accessToken;
    private String refreshToken;
    private UserProfile profile;
    // expiresIn 필드 없음!
}
```

**프론트엔드 기대**:
- `lib/features/auth/data/models/auth_token_model.dart:53-59`에서 `expiresIn`을 `DateTime`으로 변환
- 하지만 백엔드가 제공하지 않으므로 `expiresAt`이 null로 저장됨

---

## 작업 목록

### Phase 1: 토큰 저장소 통일 (우선순위: HIGH)

#### Task 1.1: StorageService 제거 및 AuthLocalDataSource 통합

**목표**: 모든 토큰 저장/읽기를 `AuthLocalDataSource`로 통일

**수정 파일**:
1. `lib/core/services/base_api_service.dart`
   ```dart
   // 변경 전
   final StorageService _storageService = StorageService();
   final token = await _storageService.getAccessToken();

   // 변경 후
   final AuthLocalDataSource _authLocalDataSource;
   final token = await _authLocalDataSource.getToken();
   ```

2. `lib/core/providers/core_providers.dart`
   - `baseApiServiceProvider` 수정하여 `AuthLocalDataSource` 주입

3. `lib/core/services/storage_service.dart`
   - 파일 전체 삭제 (또는 deprecated 처리)

**확인 사항**:
- [ ] 로그인 후 API 요청 시 토큰이 정상적으로 첨부되는지
- [ ] 앱 재시작 후에도 토큰이 유지되는지

---

### Phase 2: Refresh Token 구현 (우선순위: HIGH)

#### Task 2.1: Remote DataSource 구현

**파일**: `lib/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart:79-94`

```dart
@override
Future<AuthTokenModel> refreshToken(String refreshToken) async {
  try {
    final response = await dio.post(
      ApiConstants.refreshToken,  // '/api/auth/refresh'
      data: {
        'refreshToken': refreshToken,
      },
    );

    // 백엔드는 LoginResponse 형식으로 응답
    // AccessToken + RefreshToken + Profile 모두 포함
    return AuthTokenModel.fromJson({
      'accessToken': response.data['accessToken'],
      'refreshToken': response.data['refreshToken'],
      // expiresIn은 없으므로 생략
    });
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }
}
```

**추가 필요**:
`lib/core/constants/api_constants.dart`에 엔드포인트 추가
```dart
static const String refreshToken = '/api/auth/refresh';
```

#### Task 2.2: Repository 메서드 호출 가능하도록 수정

**파일**: `lib/features/auth/data/repositories/auth_repository_impl.dart:116-125`

현재 코드는 정상이므로 수정 불필요. 단, Remote DataSource 구현 후 테스트 필요.

---

### Phase 3: 401 에러 자동 처리 (우선순위: HIGH)

#### Task 3.1: Token Refresh Interceptor 구현

**파일**: `lib/core/services/base_api_service.dart`

**새로운 인터셉터 추가**:
```dart
class _TokenRefreshInterceptor extends Interceptor {
  final AuthLocalDataSource _authLocalDataSource;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<Function> _pendingRequests = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 1. 현재 Refresh 중인지 확인
      if (_isRefreshing) {
        // 대기 큐에 추가
        await _waitForRefresh();
        // Refresh 완료 후 재시도
        return _retry(err.requestOptions, handler);
      }

      try {
        _isRefreshing = true;

        // 2. Refresh Token 가져오기
        final tokenModel = await _authLocalDataSource.getToken();
        if (tokenModel == null) {
          // 토큰 없음 → 로그아웃
          throw UnauthorizedException('토큰이 없습니다');
        }

        // 3. Refresh Token으로 갱신 요청
        final response = await _dio.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': tokenModel.refreshToken},
        );

        // 4. 새 토큰 저장
        final newToken = AuthTokenModel.fromJson({
          'accessToken': response.data['accessToken'],
          'refreshToken': response.data['refreshToken'],
        });
        await _authLocalDataSource.saveToken(newToken);

        // 5. 대기 중인 요청들 처리
        _processPendingRequests();

        // 6. 원래 요청 재시도
        return _retry(err.requestOptions, handler);

      } catch (e) {
        // Refresh 실패 → 로그아웃
        await _authLocalDataSource.clearAll();
        // TODO: 로그인 화면으로 이동 (Navigation 처리)
        handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }

  Future<void> _retry(RequestOptions options, handler) async {
    final newToken = await _authLocalDataSource.getToken();
    options.headers['Authorization'] = 'Bearer ${newToken?.accessToken}';

    try {
      final response = await _dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.reject(e as DioException);
    }
  }
}
```

**주의 사항**:
- 동시 다발적인 401 에러 시 Refresh Token 중복 호출 방지
- Refresh 실패 시 무한 루프 방지
- Navigation 처리는 별도 로직 필요 (RouterProvider 연동)

---

### Phase 4: 백엔드 응답 개선 (우선순위: LOW)

#### Task 4.1: expiresIn 필드 추가

**백엔드 파일**: `money_back/src/main/java/com/moneyflow/dto/response/LoginResponse.java`

```java
@Data
@Builder
public class LoginResponse {
    private UUID userId;
    private String accessToken;
    private String refreshToken;
    private String expiresIn;  // 추가: "3600" (초단위)
    private UserProfile profile;
}
```

**백엔드 서비스**: `money_back/src/main/java/com/moneyflow/service/AuthService.java`

```java
return LoginResponse.builder()
    .userId(user.getUserId())
    .accessToken(accessToken)
    .refreshToken(refreshToken)
    .expiresIn("3600")  // 추가: JWT 설정값 사용
    .profile(profile)
    .build();
```

**프론트엔드 수정 불필요**: 이미 `expiresIn` 처리 로직 존재 (auth_token_model.dart:53-59)

---

## 참고 정보

### 백엔드 API 엔드포인트

#### 1. 로그인
- **URL**: `POST /api/auth/login`
- **Request**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response**:
  ```json
  {
    "userId": "uuid",
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc...",
    "profile": {
      "nickname": "홍길동",
      "email": "user@example.com",
      "profileImage": null
    }
  }
  ```

#### 2. Token Refresh
- **URL**: `POST /api/auth/refresh`
- **Request**:
  ```json
  {
    "refreshToken": "eyJhbGc..."
  }
  ```
- **Response**: (로그인 응답과 동일)

#### 3. 사용자 정보 조회
- **URL**: `GET /api/auth/me`
- **Headers**: `Authorization: Bearer {accessToken}`
- **Response**:
  ```json
  {
    "userId": "uuid",
    "email": "user@example.com",
    "nickname": "홍길동",
    "profileImageUrl": null
  }
  ```

#### 4. 로그아웃
- **URL**: `POST /api/auth/logout`
- **Request**:
  ```json
  {
    "refreshToken": "eyJhbGc..."
  }
  ```
- **Response**: `200 OK`

### 현재 토큰 저장 구조

#### AuthTokenModel
**파일**: `lib/features/auth/data/models/auth_token_model.dart`

```dart
{
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "expiresIn": "3600",      // API 응답용 (초단위 문자열)
  "expiresAt": "2025-12-09T10:00:00.000Z"  // Storage 저장용 (DateTime)
}
```

#### SharedPreferences Keys
- `auth_token`: AuthTokenModel JSON
- `auth_user`: UserModel JSON

### 백엔드 보안 정책

#### Refresh Token Rotation
- **정책**: 한 번 사용된 Refresh Token은 무효화됨
- **목적**: 토큰 탈취 시 피해 최소화
- **구현**: `money_back/src/main/java/com/moneyflow/service/AuthService.java:532-584`

#### Token 저장 방식
- **Access Token**: JWT만, DB 저장 안함
- **Refresh Token**: SHA-256 해시만 DB 저장 (실제 토큰 저장 X)
- **만료 시간**:
  - Access Token: 설정값 (`${jwt.access-token-validity}`)
  - Refresh Token: 30일 (하드코딩)

---

## 작업 시작 전 체크리스트

- [ ] 백엔드 API 서버 실행 중인지 확인 (localhost:8080)
- [ ] 테스트 계정 생성 또는 준비
- [ ] Git 브랜치 생성: `feature/jwt-token-improvement`
- [ ] 기존 토큰 저장 방식 백업 (마이그레이션 고려)

---

## 예상 작업 시간

- Phase 1 (토큰 저장소 통일): 2-3시간
- Phase 2 (Refresh Token 구현): 3-4시간
- Phase 3 (401 자동 처리): 4-5시간
- Phase 4 (백엔드 개선): 1-2시간
- **Total**: 10-14시간

---

## 관련 파일 경로

### 프론트엔드 (Flutter)
```
lib/
├── core/
│   ├── services/
│   │   ├── base_api_service.dart          # 수정 필요 (Phase 1, 3)
│   │   └── storage_service.dart           # 삭제 예정 (Phase 1)
│   ├── constants/
│   │   └── api_constants.dart             # 수정 필요 (Phase 2)
│   └── providers/
│       └── core_providers.dart            # 수정 필요 (Phase 1)
├── features/auth/
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── local/
│   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   └── auth_local_datasource_impl.dart  # 참조
│   │   │   └── remote/
│   │   │       └── auth_remote_datasource_impl.dart # 수정 필요 (Phase 2)
│   │   ├── models/
│   │   │   └── auth_token_model.dart      # 참조
│   │   └── repositories/
│   │       └── auth_repository_impl.dart  # 참조
│   └── presentation/
│       └── viewmodels/
│           └── auth_view_model.dart       # 참조
└── docs/
    └── jwt-token-todo.md                  # 이 문서
```

### 백엔드 (Spring Boot)
```
money_back/src/main/java/com/moneyflow/
├── config/
│   └── SecurityConfig.java               # 참조
├── security/
│   ├── JwtTokenProvider.java             # 참조
│   └── JwtAuthenticationFilter.java      # 참조
├── service/
│   └── AuthService.java                  # 참조 (Phase 4)
├── domain/
│   ├── user/
│   │   └── AuthController.java           # 참조
│   └── token/
│       └── RefreshToken.java             # 참조
└── dto/
    └── response/
        └── LoginResponse.java            # 수정 필요 (Phase 4)
```

---

## 참고 문서

- [GET /api/auth/me API 문서](./api/GET_auth_me.md)
- Backend README: `../../money_back/README.md`

---

## 작업 히스토리

| 날짜 | 작업자 | 작업 내용 | 상태 |
|------|--------|-----------|------|
| 2025-12-09 | hanwool | JWT 토큰 분석 및 문서 작성 | 완료 |
| - | - | Phase 1 작업 시작 예정 | 대기 |
