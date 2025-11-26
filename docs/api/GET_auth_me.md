# GET /api/auth/me

## 개요
현재 로그인한 사용자의 정보를 조회하는 API

## 기본 정보
- **HTTP Method**: `GET`
- **Endpoint**: `/api/auth/me`
- **인증 필요**: ✅ Yes (Bearer Token)

## 요청 (Request)

### Headers
```
Authorization: Bearer {accessToken}
Content-Type: application/json
```

### Request Body
없음

### 예시
```http
GET /api/auth/me HTTP/1.1
Host: localhost:8080
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

---

## 응답 (Response)

### 성공 응답 (200 OK)

#### Response Body
```json
{
  "userId": "string",
  "email": "string",
  "nickname": "string",
  "profileImageUrl": "string | null"
}
```

#### 필드 설명
| 필드명 | 타입 | 필수 | 설명 |
|--------|------|------|------|
| userId | string | ✅ | 사용자 고유 ID |
| email | string | ✅ | 사용자 이메일 |
| nickname | string | ✅ | 사용자 닉네임 |
| profileImageUrl | string \| null | ❌ | 프로필 이미지 URL (없으면 null) |

#### 예시
```json
{
  "userId": "user_1234567890",
  "email": "user@example.com",
  "nickname": "홍길동",
  "profileImageUrl": "https://example.com/profile/user123.jpg"
}
```

```json
{
  "userId": "user_9876543210",
  "email": "test@moneyflow.com",
  "nickname": "테스터",
  "profileImageUrl": null
}
```

---

### 에러 응답

#### 401 Unauthorized - 인증 실패
토큰이 없거나, 만료되었거나, 유효하지 않은 경우

```json
{
  "message": "인증이 필요합니다"
}
```

또는

```json
{
  "message": "토큰이 만료되었습니다"
}
```

#### 404 Not Found - 사용자를 찾을 수 없음
토큰은 유효하지만 해당 사용자가 DB에 존재하지 않는 경우

```json
{
  "message": "사용자를 찾을 수 없습니다"
}
```

#### 500 Internal Server Error - 서버 오류
```json
{
  "message": "서버 오류가 발생했습니다"
}
```

---

## 비즈니스 로직

### 동작 흐름
1. Request Header에서 `Authorization: Bearer {token}` 추출
2. Access Token 검증 (유효성, 만료 여부)
3. Token에서 userId 추출
4. DB에서 해당 userId로 사용자 조회
5. 사용자 정보 반환

### 주의사항
- **토큰 검증 필수**: 유효하지 않은 토큰은 401 에러 반환
- **사용자 존재 확인**: DB에 사용자가 없으면 404 에러 반환
- **민감 정보 제외**: 비밀번호 등 민감한 정보는 절대 반환하지 않음

---

## 사용 시나리오

### 1. 앱 초기 실행 시
- 저장된 토큰이 있으면 `/api/auth/me` 호출
- 사용자 정보를 가져와서 자동 로그인 처리

### 2. 토큰 갱신 후
- Refresh Token으로 새 Access Token을 받은 후
- 사용자 정보가 변경되었을 수 있으므로 최신 정보 조회

### 3. 프로필 화면 진입 시
- 현재 사용자의 최신 정보 표시

---

## 구현 참고사항

### Spring Boot 예시
```java
@GetMapping("/api/auth/me")
public ResponseEntity<?> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
    String userId = userDetails.getUsername();
    User user = userService.findById(userId)
        .orElseThrow(() -> new UserNotFoundException("사용자를 찾을 수 없습니다"));

    UserResponse response = UserResponse.builder()
        .userId(user.getId())
        .email(user.getEmail())
        .nickname(user.getNickname())
        .profileImageUrl(user.getProfileImageUrl())
        .build();

    return ResponseEntity.ok(response);
}
```

### 보안 체크리스트
- [ ] JWT 토큰 검증 (서명, 만료시간)
- [ ] 사용자 존재 여부 확인
- [ ] 비밀번호 등 민감정보 제외
- [ ] CORS 설정 확인

---

## 테스트 케이스

### 정상 케이스
- ✅ 유효한 토큰으로 요청 → 200 OK, 사용자 정보 반환

### 에러 케이스
- ❌ 토큰 없이 요청 → 401 Unauthorized
- ❌ 만료된 토큰으로 요청 → 401 Unauthorized
- ❌ 잘못된 토큰으로 요청 → 401 Unauthorized
- ❌ 존재하지 않는 사용자의 토큰 → 404 Not Found

---

## 프론트엔드 연동 정보

### 호출 위치
- `lib/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart`
- `getCurrentUser()` 메서드

### 사용 시점
1. 앱 시작 시 자동 로그인 체크
2. 토큰 갱신 후 사용자 정보 동기화
3. 프로필 화면 새로고침

### 에러 처리
- **401 Unauthorized**: 로그아웃 처리, 로그인 화면으로 이동
- **404 Not Found**: 로그아웃 처리
- **500 Server Error**: 로컬 캐시 데이터 사용 (있으면)

---

## 우선순위
**🔴 HIGH** - 앱 자동 로그인 기능에 필수적인 API

---

## 질문/문의
프론트엔드 개발자: hanwool
작성일: 2025-11-26
