# Flutter Splash Screen 활성화 가이드

현재 앱은 **Native Splash**만 사용하도록 설정되어 있습니다.
나중에 **Flutter Splash Screen**을 활성화하려면 아래 단계를 따르세요.

## 목차

- [언제 Flutter Splash를 사용해야 하나요?](#언제-flutter-splash를-사용해야-하나요)
- [활성화 방법](#활성화-방법)
- [테스트 딜레이 설정](#테스트-딜레이-설정)
- [비활성화 방법](#비활성화-방법)

---

## 언제 Flutter Splash를 사용해야 하나요?

### Flutter Splash가 필요한 경우:

1. **초기화 진행률 표시가 필요할 때**
   - 로딩바, 퍼센트, "데이터 로딩 중..." 등의 UI

2. **애니메이션이 필요할 때**
   - 로고 애니메이션
   - 페이드 인/아웃 효과
   - 브랜딩 애니메이션

3. **초기화 시간이 길 때** (3초 이상)
   - 사용자에게 피드백 제공
   - 로딩 상태 표시

4. **복잡한 초기 설정이 필요할 때**
   - Firebase Remote Config
   - 앱 버전 체크
   - 필수 데이터 프리로드

### Native Splash만으로 충분한 경우:

- 초기화가 빠르게 끝남 (1-2초 이내)
- 특별한 UI나 애니메이션이 필요 없음
- 심플한 사용자 경험을 원할 때

---

## 활성화 방법

### 1. router_provider.dart 수정

**파일 위치**: `lib/core/router/router_provider.dart`

```dart
// 변경 전
return GoRouter(
  initialLocation: '/',
  // ...
);
```

```dart
// 변경 후
return GoRouter(
  initialLocation: RouteNames.splash, // Flutter Splash 화면에서 시작
  // ...
);
```

**redirect 로직 수정** - Priority 1에 다음 코드 추가:

```dart
redirect: (context, state) {
  // ... 기존 코드 ...

  final currentLocation = state.matchedLocation;

  // Public 화면 확인
  final isGoingToAuth = RouteNames.isAuthRoute(currentLocation);
  final isGoingToSplash = currentLocation == RouteNames.splash;  // 추가
  final isRoot = currentLocation == '/';

  // 디버그 로그 - isGoingToSplash 추가
  debugPrint('[GoRouter Redirect] location: $currentLocation, '
      'isLoading: $isLoading, isAuthenticated: $isAuthenticated, '
      'hasUser: $hasUser, isGoingToAuth: $isGoingToAuth, '
      'isGoingToSplash: $isGoingToSplash, isRoot: $isRoot');  // 수정

  // ⭐ Priority 1: Splash 화면에서는 redirect 하지 않음 - 이 부분 추가
  if (isGoingToSplash) {
    debugPrint('[GoRouter Redirect] Splash 화면 - redirect 안 함');
    return null;
  }

  // Priority 2: 로딩 중일 때는 redirect 하지 않음
  if (isLoading) {
    // ...
  }

  // ... 나머지 코드 ...
}
```

### 2. main.dart 수정

**파일 위치**: `lib/main.dart`

```dart
// 변경 전
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('ko_KR', null);
  final sharedPreferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );

  // ❌ 제거: 초기화 로직을 SplashScreen으로 이동
  await container.read(authViewModelProvider.notifier).isInitialized;

  FlutterNativeSplash.remove();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MoneyFlowApp(),
    ),
  );
}
```

```dart
// 변경 후
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('ko_KR', null);
  final sharedPreferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );

  // ✅ Native Splash 제거하고 Flutter Splash로 전환
  // 추가 초기화 작업은 SplashScreen에서 수행
  FlutterNativeSplash.remove();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MoneyFlowApp(),
    ),
  );
}
```

**import 제거** (사용하지 않게 되므로):

```dart
// 제거
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
```

---

## 테스트 딜레이 설정

### 스플래시 화면 확인을 위한 2초 딜레이 추가

**파일 위치**: `lib/presentation/screens/splash_screen.dart:44`

```dart
Future<void> _initializeApp() async {
  try {
    await ref.read(authViewModelProvider.notifier).isInitialized;

    // ============================================================
    // [테스트용] 2초 딜레이 - 스플래시 화면 확인용
    // 실제 배포 시에는 아래 라인을 주석 처리하거나 제거하세요
    // ============================================================
    await Future.delayed(const Duration(seconds: 2));  // 주석 제거하여 활성화

    if (mounted) {
      context.go('/');
    }
  } catch (e) {
    // ...
  }
}
```

### 배포 시 딜레이 제거

```dart
// await Future.delayed(const Duration(seconds: 2));  // 주석 처리 또는 삭제
```

---

## 비활성화 방법

Flutter Splash를 다시 비활성화하려면 위 변경 사항을 되돌리면 됩니다:

1. **router_provider.dart**: `initialLocation: '/'`로 변경, splash 관련 redirect 로직 제거
2. **main.dart**: `await container.read(authViewModelProvider.notifier).isInitialized;` 다시 추가, import 복구

---

## 앱 실행 흐름 비교

### Native Splash만 사용 (현재)

```
앱 시작
  ↓
Native Splash
  - 인증 상태 확인
  - 초기화 완료
  ↓
Native Splash 제거 → 바로 메인 화면
```

### Flutter Splash 사용 시

```
앱 시작
  ↓
Native Splash (매우 짧음)
  ↓
Flutter Splash Screen
  - 인증 상태 확인
  - 추가 초기화 작업
  - 로딩 UI 표시
  ↓
자동 이동 (인증 상태에 따라)
```

---

## 관련 파일

- `lib/presentation/screens/splash_screen.dart` - Flutter Splash Screen 구현
- `lib/core/router/route_names.dart:7` - splash 경로 정의
- `lib/core/router/app_router.dart:52` - splash 라우트 등록
- `lib/core/router/router_provider.dart` - 라우터 설정 및 redirect 로직
- `lib/main.dart` - 앱 진입점 및 초기화

---

## 추가 커스터마이징

`splash_screen.dart`를 수정하여 다음과 같은 커스터마이징이 가능합니다:

- 로고 이미지 변경 (line 76)
- 앱 이름 변경 (line 86)
- 배경색 변경 (line 69)
- 로딩 애니메이션 변경 (line 100)
- 진행률 표시 추가
- 초기화 단계별 메시지 표시

예시:

```dart
// 로고 이미지로 교체
Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
)

// 배경 그라디언트 적용
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    ),
  ),
  child: Center(
    // ...
  ),
)
```

---

**작성일**: 2025-12-17
**버전**: 1.0.0
