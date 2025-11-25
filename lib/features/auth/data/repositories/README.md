# Repositories

## 개요

Repository는 **Domain Layer와 Data Layer를 연결하는 계층**입니다.
- Domain Layer의 Repository Interface를 구현 (`implements`)
- Data Source(Remote, Local)를 조합하여 데이터 흐름 제어
- Data Model ↔ Domain Entity 변환 담당

---

## 역할

### 1. 데이터 흐름 제어
- **Remote 우선**: 서버에서 최신 데이터를 가져옴
- **Local 캐싱**: 가져온 데이터를 로컬에 저장하여 오프라인 지원 또는 성능 향상
- **Fallback**: 네트워크 오류 시 로컬 데이터 반환

### 2. 데이터 변환
- **Data Source**: `Model` 반환
- **Repository**: `Model` → `Entity` 변환 후 반환
- **이유**: Domain Layer는 Data Layer의 구현(Model)을 몰라야 함

---

## AuthRepositoryImpl

### 주요 기능

#### 1. 로그인 (`login`)
1. `RemoteDataSource.login()` 호출 (API 통신)
2. 응답받은 토큰과 사용자 정보를 `LocalDataSource`에 저장 (캐싱)
3. `AuthResult` Entity로 변환하여 반환

#### 2. 회원가입 (`register`)
1. `RemoteDataSource.register()` 호출
2. 토큰과 사용자 정보 저장
3. `AuthResult` Entity 반환

#### 3. 현재 사용자 조회 (`getCurrentUser`)
1. `RemoteDataSource.getCurrentUser()` 시도
2. 성공 시: 로컬에 저장 후 반환
3. 실패 시 (`NetworkException`): 로컬 데이터(`LocalDataSource.getUser()`) 반환
4. 실패 시 (`UnauthorizedException`): 로컬 데이터 삭제 후 `null` 반환

#### 4. 토큰 관리
- `refreshToken()`: 토큰 갱신 후 로컬 저장소 업데이트
- `logout()`: 로컬 저장소의 모든 데이터 삭제 (`clearAll`)

---

## 에러 처리 전략

Repository는 Data Source에서 발생한 예외를 처리하거나 전파합니다.

| 예외 상황 | 처리 방식 |
|---|---|
| **NetworkException** | 로컬 데이터가 있으면 반환, 없으면 예외 전파 |
| **UnauthorizedException** | 로컬 데이터 삭제 (로그아웃 처리) |
| **ServerException** | 그대로 전파 (UI에서 에러 메시지 표시) |

---

## 의존성

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource; // API
  final AuthLocalDataSource localDataSource;   // Local Storage
}
```
