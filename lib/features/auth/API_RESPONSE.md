# Auth API 응답 구조 문서

이 문서는 인증(Auth) 관련 백엔드 API의 요청/응답 구조를 정리한 문서입니다.

## 목차
- [회원가입 인증번호 전송](#회원가입-인증번호-전송)
- [회원가입 인증번호 검증](#회원가입-인증번호-검증)
- [회원가입](#회원가입)
- [로그인](#로그인)
- [소셜 로그인](#소셜-로그인)
- [현재 사용자 정보 조회](#현재-사용자-정보-조회)

---

## 회원가입 인증번호 전송

**Endpoint:** `POST /api/auth/send-signup-code`

### 요청 (Request)
```json
{
  "email": "user@example.com"
}
```

### 응답 (Response)

#### 성공 (200 OK)
```json
{
  "message": "인증번호가 전송되었습니다"
}
```
또는 응답 본문 없이 성공 상태만 반환할 수 있습니다.

#### 실패 사례

**이메일 형식 오류 (400 Bad Request)**
```json
{
  "error": "유효하지 않은 이메일 형식입니다"
}
```

**이미 가입된 이메일 (409 Conflict)**
```json
{
  "error": "이미 가입된 이메일입니다"
}
```

### 비즈니스 로직
- 이메일 형식 검증
- 이메일 중복 체크 (이미 가입된 이메일이면 오류 반환)
- 6자리 랜덤 인증번호 생성
- 인증번호를 이메일로 전송
- 인증번호는 10분간 유효

---

## 회원가입 인증번호 검증

**Endpoint:** `POST /api/auth/verify-signup-code`

### 요청 (Request)
```json
{
  "email": "user@example.com",
  "code": "123456"
}
```

### 응답 (Response)

#### 성공 (200 OK)
```json
{
  "success": true
}
```

#### 실패 (200 OK - 검증 실패)
```json
{
  "success": false,
  "error": "인증번호가 일치하지 않습니다"
}
```

또는

```json
{
  "success": false,
  "error": "인증번호가 만료되었습니다"
}
```

### 비즈니스 로직
- 이메일과 인증번호를 검증
- 인증번호가 일치하고 만료되지 않았으면 `success: true` 반환
- 인증번호 불일치 또는 만료 시 `success: false` 반환

---

## 회원가입

**Endpoint:** `POST /api/auth/register`

### 요청 (Request)
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "nickname": "사용자닉네임",
  "gender": "MALE"
}
```

**gender 값:**
- `"MALE"` - 남성
- `"FEMALE"` - 여성
- `"OTHER"` - 기타

### 응답 (Response)

#### 성공 (201 Created)
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": "3600",
  "userId": "user_123456"
}
```

**응답 필드 설명:**
- `accessToken` (string, required): JWT Access Token
- `refreshToken` (string, required): JWT Refresh Token
- `expiresIn` (string, optional): Access Token 만료 시간 (초 단위)
- `userId` (string, required): 생성된 사용자의 고유 ID

**참고:** 회원가입 응답은 토큰만 포함하며, 사용자 정보(이메일, 닉네임 등)는 클라이언트가 이미 알고 있으므로 프로필 정보는 포함하지 않습니다.

#### 실패 사례

**입력값 검증 오류 (400 Bad Request)**
```json
{
  "error": "비밀번호는 8자 이상이어야 합니다"
}
```

**이메일 중복 (409 Conflict)**
```json
{
  "error": "이미 가입된 이메일입니다"
}
```

---

## 로그인

**Endpoint:** `POST /api/auth/login`

### 요청 (Request)
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}
```

### 응답 (Response)

#### 성공 (200 OK)
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": "3600",
  "userId": "user_123456",
  "profile": {
    "userId": "user_123456",
    "email": "user@example.com",
    "nickname": "사용자닉네임",
    "profileImageUrl": "https://example.com/profile.jpg",
    "gender": "MALE"
  }
}
```

**응답 필드 설명:**
- `accessToken` (string, required): JWT Access Token
- `refreshToken` (string, required): JWT Refresh Token
- `expiresIn` (string, optional): Access Token 만료 시간 (초 단위)
- `userId` (string, required): 사용자 고유 ID
- `profile` (object, required): 사용자 프로필 정보
  - `userId` (string, required): 사용자 고유 ID
  - `email` (string, required): 사용자 이메일
  - `nickname` (string, required): 사용자 닉네임
  - `profileImageUrl` (string, optional): 프로필 이미지 URL
  - `gender` (string, optional): 성별 (`MALE`, `FEMALE`, `OTHER`)

#### 실패 사례

**인증 실패 (401 Unauthorized)**
```json
{
  "error": "이메일 또는 비밀번호가 올바르지 않습니다"
}
```

---

## 소셜 로그인

**Endpoint:** `POST /api/auth/social-login`

### 요청 (Request)
```json
{
  "provider": "GOOGLE",
  "idToken": "google_id_token_here",
  "nickname": "Google 사용자"
}
```

**provider 값:**
- `"GOOGLE"` - Google 로그인
- `"APPLE"` - Apple 로그인

**참고:**
- Google 로그인의 경우 `idToken`은 Google ID Token입니다.
- Apple 로그인의 경우 `idToken`은 Apple Authorization Code입니다.

### 응답 (Response)

#### 성공 (200 OK)
로그인 API와 동일한 응답 구조:

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": "3600",
  "userId": "user_123456",
  "profile": {
    "userId": "user_123456",
    "email": "user@example.com",
    "nickname": "Google 사용자",
    "profileImageUrl": "https://example.com/profile.jpg",
    "gender": null
  }
}
```

#### 실패 사례

**소셜 인증 실패 (401 Unauthorized)**
```json
{
  "error": "Google 인증에 실패했습니다"
}
```

---

## 현재 사용자 정보 조회

**Endpoint:** `GET /api/auth/me`

### 요청 (Request)
헤더에 JWT Access Token 포함:
```
Authorization: Bearer {accessToken}
```

### 응답 (Response)

#### 성공 (200 OK)
```json
{
  "userId": "user_123456",
  "email": "user@example.com",
  "nickname": "사용자닉네임",
  "profileImageUrl": "https://example.com/profile.jpg",
  "gender": "MALE"
}
```

**응답 필드 설명:**
- `userId` (string, required): 사용자 고유 ID
- `email` (string, required): 사용자 이메일
- `nickname` (string, required): 사용자 닉네임
- `profileImageUrl` (string, optional): 프로필 이미지 URL
- `gender` (string, optional): 성별 (`MALE`, `FEMALE`, `OTHER`)

#### 실패 사례

**인증 실패 (401 Unauthorized)**
```json
{
  "error": "유효하지 않은 토큰입니다"
}
```

**토큰 만료 (401 Unauthorized)**
```json
{
  "error": "토큰이 만료되었습니다"
}
```

---

## 에러 응답 코드 정리

| HTTP Status Code | 설명 | 예시 |
|-----------------|------|------|
| 400 Bad Request | 입력값 검증 오류 | 이메일 형식 오류, 비밀번호 길이 부족 |
| 401 Unauthorized | 인증 실패 | 잘못된 이메일/비밀번호, 토큰 만료 |
| 409 Conflict | 리소스 충돌 | 이미 가입된 이메일 |
| 500 Internal Server Error | 서버 오류 | 서버 내부 오류 |

---

## 참고 사항

### JWT Token 저장 위치
- Access Token과 Refresh Token은 Flutter Secure Storage에 안전하게 저장됩니다.
- 토큰은 API 요청 시 자동으로 헤더에 추가됩니다.

### Token 갱신
- 현재 백엔드에 Token 갱신 API가 구현되지 않았습니다.
- `auth_remote_datasource_impl.dart`의 `refreshToken` 메서드는 `UnimplementedError`를 발생시킵니다.
- 향후 백엔드에서 Token 갱신 API가 추가되면 구현 예정입니다.

### 인증번호 유효 시간
- 회원가입 인증번호: 10분
- 비밀번호 재설정 인증번호: 10분 (백엔드 API 구현 시)
