# Router Provider 리팩토링 PRD
작업 시간: 2026-02-04

## 개요

`router_provider.dart`의 안정성과 사용자 경험을 개선하기 위한 리팩토링 작업입니다.

## 현재 상태

- **파일**: `lib/router/router_provider.dart`
- **역할**: GoRouter 기반 라우팅 및 인증 상태에 따른 자동 리다이렉션
- **문제점**: 잠재적 크래시 가능성, 누락된 기능, 중복 코드 존재

---

## 티켓 목록

| 티켓 | 제목 | 중요도 | 예상 소요 |
|------|------|--------|----------|
| [ROUTER-001](#router-001) | requireValue 크래시 방지 | 🔴 Critical | 15분 |
| [ROUTER-002](#router-002) | 로그인 후 원래 경로 복귀 기능 | 🟡 Medium | 30분 |
| [ROUTER-003](#router-003) | Root/Splash 중복 코드 통합 | 🟢 Low | 15분 |
| [ROUTER-004](#router-004) | 토큰 만료 시 자동 로그아웃 연동 | 🟡 Medium | 1시간 |
| [ROUTER-005](#router-005) | 딥링크 처리 로직 추가 | 🟢 Low | 2시간 |

---

## 티켓 상세

### ROUTER-001
**requireValue 크래시 방지**

**중요도**: 🔴 Critical

**문제**:
```dart
// Line 109-111
final hasSeenOnboarding = appInitState.requireValue.sharedPreferences
        .getBool('has_seen_onboarding') ?? false;
```
- `requireValue`는 값이 없으면 예외를 던짐
- 앱 초기화 중 타이밍 이슈로 크래시 발생 가능

**해결 방안**:
```dart
/// 온보딩 완료 여부를 안전하게 가져오는 헬퍼 함수
bool _getHasSeenOnboarding(AsyncValue<AppInitialization> appInitState) {
  return appInitState.when(
    data: (data) =>
        data.sharedPreferences.getBool('has_seen_onboarding') ?? false,
    loading: () => false,
    error: (e, _) {
      if (kDebugMode) {
        debugPrint('[RouterProvider] 온보딩 상태 조회 실패: $e');
      }
      return false;
    },
  );
}
```

**영향 범위**: `router_provider.dart`

---

### ROUTER-002
**로그인 후 원래 경로 복귀 기능**

**중요도**: 🟡 Medium

**문제**:
- 미인증 사용자가 `/notifications` 접근 → `/login`으로 리다이렉트 → 로그인 성공 → `/home`으로 이동
- 사용자가 원래 가려던 `/notifications`로 가지 않음

**해결 방안**:
```dart
/// 로그인 후 돌아갈 경로를 저장하는 Provider
final redirectPathProvider = StateProvider<String?>((ref) => null);

// redirect 로직 내
if (!isAuthenticated) {
  if (isGoingToAuth) return null;
  
  // Protected 화면 접근 시 → 현재 경로 저장 후 로그인으로
  ref.read(redirectPathProvider.notifier).state = currentLocation;
  return RouteNames.login;
}

// 로그인 성공 후
if (isAuthenticated && hasUser && isGoingToAuth) {
  final redirectPath = ref.read(redirectPathProvider);
  if (redirectPath != null) {
    ref.read(redirectPathProvider.notifier).state = null;
    return redirectPath;
  }
  return RouteNames.home;
}
```

**영향 범위**: `router_provider.dart`

---

### ROUTER-003
**Root/Splash 중복 코드 통합**

**중요도**: 🟢 Low

**문제**:
```dart
// Line 132-145: Root 처리
if (isRoot) {
  if (isAuthenticated && hasUser) {
    return RouteNames.home;
  } else {
    return RouteNames.login;
  }
}

// Line 147-160: Splash 처리 (거의 동일한 로직)
if (currentLocation == RouteNames.splash) {
  if (isAuthenticated && hasUser) {
    return RouteNames.home;
  } else {
    return RouteNames.login;
  }
}
```

**해결 방안**:
```dart
final isRootOrSplash = currentLocation == '/' || currentLocation == RouteNames.splash;

if (isRootOrSplash) {
  return (isAuthenticated && hasUser) ? RouteNames.home : RouteNames.login;
}
```

**영향 범위**: `router_provider.dart`

---

### ROUTER-004
**토큰 만료 시 자동 로그아웃 연동**

**중요도**: 🟡 Medium

**문제**:
- API 호출 중 401 Unauthorized 응답 시 자동으로 로그인 화면으로 이동하는 로직 없음
- 사용자가 만료된 세션으로 계속 앱 사용 시도 가능

**해결 방안**:
- Dio Interceptor에서 401 에러 감지
- `authViewModelProvider`의 상태를 unauthenticated로 변경
- `refreshListenable`이 자동으로 redirect 트리거

**영향 범위**: 
- `router_provider.dart`
- `dio_client.dart` 또는 API 클라이언트

---

### ROUTER-005
**딥링크 처리 로직 추가**

**중요도**: 🟢 Low

**문제**:
- 외부에서 특정 URL로 앱 진입 시 (예: 푸시 알림 탭) 처리 로직 미흡
- 현재는 `navigatorKey`만 존재, 실제 딥링크 파싱/처리 없음

**해결 방안**:
- `go_router`의 `redirect`에서 딥링크 파라미터 처리
- 인증 필요한 딥링크는 로그인 후 해당 경로로 이동

**영향 범위**: 
- `router_provider.dart`
- `main.dart` (딥링크 초기화)

---

## 작업 순서 권장

1. **ROUTER-001** (Critical) - 크래시 방지 최우선
2. **ROUTER-003** (Low, but quick) - 5분 작업으로 코드 정리
3. **ROUTER-002** (Medium) - UX 개선
4. **ROUTER-004** (Medium) - 보안 강화
5. **ROUTER-005** (Low) - 추후 필요 시

---

## 완료 조건

- [ ] ROUTER-001: `requireValue` 를 안전한 접근 방식으로 변경
- [ ] ROUTER-002: 로그인 후 원래 경로로 복귀 확인
- [ ] ROUTER-003: 중복 코드 제거 및 테스트
- [ ] ROUTER-004: 401 에러 시 자동 로그아웃 확인
- [ ] ROUTER-005: 딥링크로 앱 진입 시 올바른 화면 표시

---

## 관련 파일

- `lib/router/router_provider.dart`
- `lib/router/app_router.dart`
- `lib/router/route_names.dart`
