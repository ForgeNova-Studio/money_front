# JWT Token 세션 관리 개선 작업

> 작성일: 2025-12-09
> 최종 수정: 2025-12-09
> 상태: IN PROGRESS
> 우선순위: HIGH

## 📋 목차
1. [현재 상태 요약](#현재-상태-요약)
2. [아키텍처 현황](#아키텍처-현황)
3. [발견된 문제점](#발견된-문제점)
4. [작업 목록](#작업-목록)
5. [참고 정보](#참고-정보)

---

## 현재 상태 요약

### ✅ 정상 작동하는 부분
- 로그인/회원가입 시 Access Token + Refresh Token 발급
- SharedPreferences에 토큰 저장 (`'auth_token'` 키)
- 앱 시작 시 자동 로그인 (GET /api/auth/me)
- 백엔드의 완전한 Refresh Token 구현 (Rotation 정책 포함)

### ❌ 미완성/문제 있는 부분
1. **🔴 CRITICAL: 토큰 키 불일치**: 저장 키(`auth_token`)와 읽기 키(`access_token`)가 달라 **인증이 작동하지 않음**
2. **Refresh Token 로직 미구현**: 프론트엔드에서 구현 안됨
3. **401 에러 처리 없음**: Access Token 만료 시 자동 갱신 없음
4. **expiresIn 필드 미사용**: 백엔드가 제공하지 않음

---

## 아키텍처 현황

### ✅ 클린 아키텍처 적용 Feature (Auth)
**구조**:
```
lib/features/auth/
├── data/
│   ├── datasources/remote/  # Dio 사용
│   ├── datasources/local/   # AuthLocalDataSource ('auth_token' 키)
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/           # Riverpod
    └── viewmodels/
```

**Dio 인스턴스**: `core_providers.dart`의 `dioProvider` (Riverpod)
**Interceptor**: `core_providers.dart:38-62`의 `_AuthInterceptor`
**토큰 읽기**: SharedPreferences에서 `'access_token'` 키로 직접 읽기 ❌

---

### 🚧 미적용 Features (Budget, Expense, Income, Couple, Statistics)
**구조**:
```
lib/features/[feature]/
├── data/
│   └── services/          # BaseApiService 상속
├── domain/
│   └── entities/
└── presentation/
    └── providers/
```

**Dio 인스턴스**: `BaseApiService` 클래스 내부에서 생성
**Interceptor**: `base_api_service.dart:36-59`의 `_AuthInterceptor`
**토큰 읽기**: `StorageService.getAccessToken()` (`'access_token'` 키) ❌

**마이그레이션 전략**:
- 현재는 BaseApiService 유지
- Auth feature 완성 후 점진적으로 클린 아키텍처로 마이그레이션
- Phase 5에서 가이드 제공

---

## 발견된 문제점

### 🔴 CRITICAL: 토큰 키 불일치 (저장 vs 읽기)

**문제**: 로그인 시 저장하는 키와 API 요청 시 읽는 키가 달라 **인증이 전혀 작동하지 않음**

#### 토큰 저장 (로그인 시)
**파일**: `lib/features/auth/data/datasources/local/auth_local_datasource_impl.dart:21`
```dart
static const String _keyToken = 'auth_token';  // ← 이 키에 저장
```
- `auth_repository_impl.dart:59-60`에서 호출
- `AuthTokenModel` JSON 형태로 저장
- `expiresAt` 등 메타데이터 포함

#### 토큰 읽기 (API 요청 시) - 3개 위치
1. **core_providers.dart:47** (Auth feature용)
   ```dart
   final token = prefs.getString('access_token');  // ← 'access_token' 키에서 읽기 ❌
   ```
   - `dioProvider`의 `_AuthInterceptor`
   - Auth feature의 모든 API 요청

2. **base_api_service.dart:44** (다른 features용)
   ```dart
   final token = await _storageService.getAccessToken();  // ← 'access_token' 키에서 읽기 ❌
   ```
   - Budget, Expense, Income 등 features
   - `StorageService` 사용

3. **storage_service.dart:14-17** (실제 구현)
   ```dart
   static const String _keyAccessToken = 'access_token';
   Future<String?> getAccessToken() async {
     return prefs.getString(_keyAccessToken);  // ← 'access_token' 키
   }
   ```

**결과**:
- 로그인 시: `'auth_token'` 키에 토큰 저장 ✓
- API 요청 시: `'access_token'` 키에서 토큰 읽기 시도 ✗
- **모든 인증 API 요청이 실패함** (401 Unauthorized)

**영향 범위**:
- 모든 인증 필요 API 요청
- GET /api/auth/me (자동 로그인)
- Budget, Expense, Income 등 모든 protected endpoints

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

### Phase 1: Auth Feature 토큰 저장소 통일 (우선순위: CRITICAL)

#### Task 1.1: core_providers.dart의 dioProvider 수정

**목표**: Auth feature의 Interceptor가 `AuthLocalDataSource`에서 토큰을 읽도록 수정

**수정 파일**: `lib/core/providers/core_providers.dart`

**변경 전** (core_providers.dart:38-62):
```dart
class _AuthInterceptor extends Interceptor {
  final Ref ref;

  _AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final token = prefs.getString('access_token');  // ❌ 잘못된 키
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  // ...
}
```

**변경 후**:
```dart
class _AuthInterceptor extends Interceptor {
  final Ref ref;

  _AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // AuthLocalDataSource 사용
    final authLocalDataSource = ref.read(authLocalDataSourceProvider);
    final tokenModel = await authLocalDataSource.getToken();

    if (tokenModel != null) {
      options.headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';
    }
    handler.next(options);
  }
  // ...
}
```

**추가 작업**:
- `core_providers.dart`에 `authLocalDataSourceProvider` import 추가
  ```dart
  import 'package:moneyflow/features/auth/presentation/providers/auth_providers.dart';
  ```

**확인 사항**:
- [ ] 로그인 후 GET /api/auth/me 호출 시 토큰이 정상적으로 첨부되는지
- [ ] 앱 재시작 후에도 토큰이 유지되는지

**주의**:
- BaseApiService는 수정하지 않음 (다른 features에서 사용 중)
- StorageService도 유지 (향후 마이그레이션 시 제거)

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

**파일**: `lib/core/providers/core_providers.dart`

**기존 _AuthInterceptor 확장**:
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

### Phase 5: 다른 Features 클린 아키텍처 마이그레이션 (우선순위: FUTURE)

#### 마이그레이션 가이드 (향후 작업)

**대상 Features**: Budget, Expense, Income, Couple, Statistics

**마이그레이션 순서** (Feature별):
1. `data/datasources/remote/` 생성
   - `[feature]_remote_datasource.dart` (interface)
   - `[feature]_remote_datasource_impl.dart` (Dio 주입)
   - 기존 ApiService의 메서드 이동

2. `data/datasources/local/` 생성 (필요 시)
   - 로컬 캐싱이 필요한 경우

3. `data/repositories/` 생성
   - `[feature]_repository_impl.dart`
   - DataSource 조합

4. `domain/usecases/` 생성
   - 비즈니스 로직 분리

5. `presentation/providers/` 수정
   - Riverpod으로 의존성 주입
   - dioProvider 사용

6. 기존 ApiService 제거
   - `data/services/[feature]_api_service.dart` 삭제

**완료 후**:
- `lib/core/services/base_api_service.dart` 삭제
- `lib/core/services/storage_service.dart` 삭제

**참고**: Auth feature 구조를 템플릿으로 사용

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

- Phase 1 (Auth Interceptor 수정): 30분-1시간
- Phase 2 (Refresh Token 구현): 2-3시간
- Phase 3 (401 자동 처리): 3-4시간
- Phase 4 (백엔드 개선): 1-2시간
- Phase 5 (다른 Features 마이그레이션): Feature당 4-6시간 (향후 작업)
- **Total (Phase 1-4)**: 6.5-10시간

---

## 관련 파일 경로

### 프론트엔드 (Flutter)

#### Phase 1-3 수정 대상 (Auth Feature)
```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart             # 수정 필요 (Phase 2)
│   └── providers/
│       └── core_providers.dart            # 🔴 수정 필요 (Phase 1, 3)
└── features/auth/
    ├── data/
    │   ├── datasources/
    │   │   ├── local/
    │   │   │   ├── auth_local_datasource.dart
    │   │   │   └── auth_local_datasource_impl.dart  # 참조 (Phase 1)
    │   │   └── remote/
    │   │       └── auth_remote_datasource_impl.dart # 🔴 수정 필요 (Phase 2)
    │   ├── models/
    │   │   └── auth_token_model.dart      # 참조
    │   └── repositories/
    │       └── auth_repository_impl.dart  # 참조
    └── presentation/
        ├── providers/
        │   └── auth_providers.dart        # 참조 (Phase 1)
        └── viewmodels/
            └── auth_view_model.dart       # 참조
```

#### 현재 유지 (향후 Phase 5에서 제거)
```
lib/
└── core/
    └── services/
        ├── base_api_service.dart          # ⚠️ 유지 (다른 features 사용 중)
        └── storage_service.dart           # ⚠️ 유지 (다른 features 사용 중)
```

#### Phase 5 마이그레이션 대상
```
lib/
└── features/
    ├── budget/
    ├── expense/
    ├── income/
    ├── couple/
    └── statistics/
        └── data/
            └── services/               # BaseApiService 상속 중
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
| 2025-12-09 | hanwool | JWT 토큰 분석 및 문서 작성 | ✅ 완료 |
| 2025-12-09 | hanwool | 실제 코드 분석 - 토큰 키 불일치 발견 | ✅ 완료 |
| 2025-12-09 | hanwool | 문서 업데이트 - 아키텍처 현황 및 점진적 마이그레이션 전략 반영 | ✅ 완료 |
| 2025-12-09 | hanwool | Phase 1 작업 시작 예정 | ⏳ 대기 |

## 주요 발견 사항

### Critical Bug 발견
- **문제**: 토큰 저장 키(`'auth_token'`)와 읽기 키(`'access_token'`)가 불일치
- **영향**: 모든 인증 API 요청이 실패 (토큰이 첨부되지 않음)
- **해결**: Phase 1에서 core_providers.dart의 Interceptor 수정

### 아키텍처 혼재 상황
- **Auth**: 클린 아키텍처 완전 적용 (dioProvider 사용)
- **나머지**: BaseApiService 사용 (향후 마이그레이션 예정)
- **전략**: Auth 완성 후 점진적으로 다른 features 마이그레이션
