# Auth Domain Entities

## 개요
Auth 도메인의 핵심 비즈니스 모델들을 정의합니다.

---

## AuthToken 엔티티

### 역할
사용자 인증을 위한 토큰 정보를 관리하는 도메인 엔티티

### 왜 필요한가?

#### 1. 타입 안정성
```dart
// ❌ String으로 관리 (위험)
String accessToken = "abc123";
String refreshToken = "xyz789";
api.setToken(refreshToken);  // 실수로 뒤바뀔 수 있음!

// ✅ 엔티티로 관리 (안전)
AuthToken token = AuthToken(...);
api.setToken(token.accessToken);  // 명확함
```

#### 2. 만료 시간 관리
토큰이 만료되었는지 비즈니스 로직에서 판단 가능

#### 3. 비즈니스 로직 캡슐화
토큰 검증, 만료 체크 등의 로직을 엔티티에 포함

#### 4. Storage와 분리
- Storage: JSON으로 저장
- 메모리: 엔티티로 관리
- 변환 로직이 명확해짐

---

## AuthToken 사용 흐름

### 1. 로그인 요청 흐름
```
UI (LoginScreen)
  └─> LoginUseCase.call(email, password)
      └─> AuthRepository.login()
          └─> AuthApiService.login()  // API 호출
              └─> 응답: { accessToken, refreshToken, expiresIn, user }
                  └─> AuthTokenModel.fromJson()  // Data Model
                      └─> AuthTokenModel.toEntity() → AuthToken (Domain Entity)
                          └─> StorageService에 저장
                          └─> AuthResult(user, token) 반환
```

### 2. 토큰 검증 흐름
```
앱 시작 / Provider 초기화
  └─> StorageService에서 토큰 읽기
      └─> AuthTokenModel.fromStorage()
          └─> AuthTokenModel.toEntity() → AuthToken
              └─> token.isExpired 체크
                  ├─> 만료됨 → null 반환 (재로그인 필요)
                  ├─> 곧 만료 → refreshToken() 호출
                  └─> 유효함 → 현재 User 반환
```

### 3. 토큰 갱신 흐름
```
API 요청 중 401 에러 발생
  └─> Interceptor가 감지
      └─> StorageService에서 refreshToken 읽기
          └─> AuthRepository.refreshToken(refreshToken)
              └─> API 호출: POST /auth/refresh
                  └─> 새로운 AuthToken 발급
                      └─> StorageService에 저장
                      └─> 원래 요청 재시도
```

---

## UseCase에서 사용 예시

### LoginUseCase
```dart
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) async {
    // Repository가 User와 Token을 함께 반환
    return await repository.login(email: email, password: password);
  }
}
```

### AuthResult (로그인 결과)
```dart
class AuthResult {
  final User user;
  final AuthToken token;

  const AuthResult({
    required this.user,
    required this.token,
  });
}
```

---

## Repository Interface에서 사용

```dart
abstract class AuthRepository {
  /// 로그인 - User와 Token을 함께 반환
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  /// 회원가입 - User와 Token을 함께 반환
  Future<AuthResult> register({
    required String email,
    required String password,
    required String nickname,
  });

  /// 로그아웃 - 저장된 토큰 삭제
  Future<void> logout();

  /// 토큰 갱신 - 새로운 Token 반환
  Future<AuthToken> refreshToken(String refreshToken);

  /// 현재 로그인한 사용자 정보 가져오기
  Future<User?> getCurrentUser();

  /// 저장된 토큰 가져오기
  Future<AuthToken?> getStoredToken();
}
```

---

## Riverpod Provider에서 사용

```dart
@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async {
    // 저장된 토큰 확인
    final token = await ref.read(authRepositoryProvider)
        .getStoredToken();

    if (token == null || token.isExpired) {
      return null;
    }

    // 토큰이 곧 만료되면 갱신
    if (token.isExpiringSoon) {
      final newToken = await ref.read(authRepositoryProvider)
          .refreshToken(token.refreshToken);
      // 새 토큰은 Repository에서 자동 저장
    }

    return ref.read(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider)
          .login(email: email, password: password);

      // 토큰은 Repository에서 자동으로 저장됨
      return result.user;
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
```

---

## Data Layer - Model 변환

### AuthTokenModel (Data Model)
```dart
class AuthTokenModel {
  final String accessToken;
  final String refreshToken;
  final String? expiresIn;  // API는 초단위로 줄 수 있음

  // API 응답에서 생성
  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }

  // Domain Entity로 변환
  AuthToken toEntity() {
    DateTime? expiresAt;
    if (expiresIn != null) {
      final seconds = int.parse(expiresIn!);
      expiresAt = DateTime.now().add(Duration(seconds: seconds));
    }

    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  // Storage 저장용 JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  // Storage에서 불러오기
  factory AuthTokenModel.fromStorage(Map<String, dynamic> json) {
    DateTime? expiresAt;
    if (json['expiresAt'] != null) {
      expiresAt = DateTime.parse(json['expiresAt']);
    }

    return AuthTokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: null,  // Storage에서는 expiresAt 사용
    )..expiresAt = expiresAt;
  }
}
```

---

## 전체 데이터 흐름 요약

### 로그인 성공 시
```
1. API 응답 → AuthTokenModel (Data)
2. toEntity() → AuthToken (Domain)
3. Storage 저장 (Data)
4. Provider 상태 업데이트 (Presentation)
```

### 앱 재시작 시
```
1. Storage 읽기 → AuthTokenModel (Data)
2. toEntity() → AuthToken (Domain)
3. 만료 체크 (token.isExpired)
4. 유효하면 User 로드 (Domain)
5. Provider 상태 업데이트 (Presentation)
```

### API 요청 시
```
1. Interceptor에서 토큰 체크
2. Storage에서 accessToken 읽기
3. Header에 자동 추가
4. 401 에러 시 refreshToken() 자동 호출
```

---

## User 엔티티와의 관계

### 분리하는 이유
- **User**: "사용자가 누구인가?" (비즈니스 개념)
- **AuthToken**: "어떻게 인증하는가?" (기술적 개념)

### 함께 사용
```dart
class AuthResult {
  final User user;        // 사용자 정보
  final AuthToken token;  // 인증 정보
}
```

---

## 핵심 정리

### AuthToken 엔티티의 장점
1. ✅ 타입 안전성 (accessToken과 refreshToken 혼동 방지)
2. ✅ 만료 로직을 한 곳에서 관리
3. ✅ 비즈니스 로직 캡슐화 (isExpired, isExpiringSoon)
4. ✅ 테스트 용이 (Mock 객체 생성 쉬움)
5. ✅ Clean Architecture 원칙 준수

### AuthToken이 없다면
- ❌ String으로 관리하면서 만료 체크 로직 중복
- ❌ 타입 실수 가능성 증가
- ❌ 테스트 어려움
- ❌ 비즈니스 로직이 여기저기 흩어짐
