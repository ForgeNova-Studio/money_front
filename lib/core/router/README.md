# GoRouter 라우팅 시스템

MoneyFlow 앱의 GoRouter 기반 라우팅 시스템 설명서입니다.

---

## 📁 파일 구조

```
lib/core/router/
├── route_names.dart      → 라우트 경로 상수 관리
├── app_router.dart       → 라우트 정의 (18개 화면)
├── router_provider.dart  → GoRouter 인스턴스 + Redirect 로직
└── README.md            → 이 문서
```

---

## 🎯 GoRouter란?

**GoRouter**는 Flutter의 선언적 라우팅 패키지로, URL 기반 네비게이션을 지원합니다.

### 기존 Navigator 1.0 vs GoRouter

```dart
// ❌ Navigator 1.0 (명령형)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => LoginScreen())
);

// ✅ GoRouter (선언형)
context.push('/login');
```

### 주요 장점
- ✅ **URL 기반 라우팅**: `/login`, `/home`, `/expenses/123`
- ✅ **자동 리다이렉션**: 인증 상태 변화 시 자동으로 화면 전환
- ✅ **Deep Link 지원**: 외부 링크로 특정 화면 진입 가능
- ✅ **타입 안전성**: 경로 상수로 오타 방지
- ✅ **선언적 보안**: redirect 한 곳에서 모든 인증 체크

---

## 🔧 핵심 구성 요소

### 1. route_names.dart - 라우트 경로 상수

모든 라우트 경로를 케밥 케이스로 정의합니다.

```dart
class RouteNames {
  // Public Routes (인증 불필요)
  static const String login = '/login';
  static const String register = '/register';
  static const String findPassword = '/find-password';
  static const String resetPassword = '/reset-password';

  // Protected Routes (인증 필요)
  static const String home = '/home';
  static const String expenses = '/expenses';
  static const String addExpense = '/expenses/add';

  // 동적 경로 생성 함수
  static String expenseDetail(String id) => '/expenses/$id';
  static String editExpense(String id) => '/expenses/$id/edit';

  // 헬퍼 메서드
  static bool isAuthRoute(String location) { ... }
  static bool isPublicRoute(String location) { ... }
  static bool isProtectedRoute(String location) { ... }
}
```

**사용 예시:**
```dart
context.push(RouteNames.login);              // '/login'
context.push(RouteNames.expenseDetail('123')); // '/expenses/123'
```

---

### 2. app_router.dart - 라우트 정의

18개 화면의 라우트를 정의합니다.

```dart
class AppRouter {
  static List<RouteBase> get routes => [
    // Root
    GoRoute(
      path: '/',
      redirect: (context, state) => RouteNames.login,
    ),

    // Public Routes
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Protected Routes
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // extra 파라미터로 객체 전달
    GoRoute(
      path: '/expenses/:id',
      name: 'expenseDetail',
      builder: (context, state) {
        final expense = state.extra as ExpenseModel?;
        if (expense == null) {
          return ErrorScreen();
        }
        return ExpenseDetailScreen(expense: expense);
      },
    ),
  ];

  // 에러 화면
  static Widget errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
      ),
    );
  }
}
```

---

### 3. router_provider.dart - GoRouter 인스턴스 + Redirect

**가장 중요한 파일입니다.** Riverpod Provider로 GoRouter를 제공하고, 인증 상태에 따른 자동 리다이렉션을 처리합니다.

#### 3-1. refreshListenable - 자동 새로고침

```dart
final routerProvider = Provider<GoRouter>((ref) {
  // AuthViewModel의 상태 구독
  final authState = ref.watch(authViewModelProvider);

  // authState.isAuthenticated 값을 추적하는 Notifier
  final authStateNotifier = ValueNotifier<bool>(authState.isAuthenticated);

  // authState 변화 감지 → Notifier 업데이트
  ref.listen<AuthState>(authViewModelProvider, (previous, next) {
    authStateNotifier.value = next.isAuthenticated;
  });

  return GoRouter(
    // authStateNotifier가 변경되면 redirect 재실행
    refreshListenable: authStateNotifier,
    ...
  );
});
```

**동작 방식:**
```
로그인 성공
  → authState.isAuthenticated = false → true
  → authStateNotifier.value = true
  → refreshListenable 감지
  → redirect 함수 재실행
  → /home으로 자동 리다이렉션 ✨
```

#### 3-2. redirect - 조건부 리다이렉션 로직

```dart
redirect: (context, state) {
  final currentAuthState = ref.read(authViewModelProvider);
  final isLoading = currentAuthState.isLoading;
  final isAuthenticated = currentAuthState.isAuthenticated;
  final hasUser = currentAuthState.user != null;

  final currentLocation = state.matchedLocation;
  final isGoingToAuth = RouteNames.isAuthRoute(currentLocation);

  // Priority 1: 로딩 중일 때는 redirect 하지 않음
  if (isLoading) {
    return null;  // 현재 위치 유지
  }

  // Priority 2: 인증된 사용자 → public 화면 접근 차단
  if (isAuthenticated && hasUser) {
    if (isGoingToAuth) {
      return RouteNames.home;  // /login 접근 → /home으로
    }
    return null;  // 그 외는 허용
  }

  // Priority 3: 미인증 사용자 → protected 화면 접근 차단
  if (!isAuthenticated) {
    if (isGoingToAuth) {
      return null;  // /login 등은 허용
    }
    return RouteNames.login;  // 그 외는 /login으로
  }

  return null;
}
```

**반환 값:**
- `null`: 리다이렉션 없음, 현재 경로 유지
- `'/login'`: 해당 경로로 리다이렉션

**실행 시점:**
1. 앱 최초 실행 시
2. URL 변경 시 (`context.go`, `context.push` 등)
3. **refreshListenable 변경 시** ← 가장 중요!

---

## 🚀 실제 동작 시나리오

### 시나리오 1: 앱 최초 실행 (미인증)

```
1. main.dart 실행
   └─> AuthViewModel.build()
       └─> AuthState.loading() 반환
       └─> _checkCurrentUser() 실행 (비동기)

2. router_provider 초기화
   └─> initialLocation: '/'
   └─> redirect 실행:
       - isLoading = true
       - return null (로딩 중이므로 redirect 안 함)
   └─> app_router의 '/' 라우트 확인
       └─> redirect: '/login'
       └─> /login으로 이동

3. _checkCurrentUser() 완료 (토큰 없음)
   └─> AuthState.unauthenticated() 반환
   └─> authStateNotifier 변화 감지
   └─> redirect 재실행:
       - isLoading = false
       - isAuthenticated = false
       - currentLocation = '/login'
       - isGoingToAuth = true
       - return null (이미 로그인 화면)

✅ 결과: 로그인 화면 표시
```

### 시나리오 2: 로그인 성공

```
1. LoginScreen에서 로그인 버튼 클릭
   └─> authViewModel.login(email, password)

2. 로그인 API 성공
   └─> AuthState.authenticated(user) 반환
   └─> authStateNotifier.value = false → true (변화!)

3. refreshListenable 감지 → redirect 재실행
   └─> isAuthenticated = true
   └─> hasUser = true
   └─> currentLocation = '/login'
   └─> isGoingToAuth = true
   └─> return RouteNames.home ← 자동 리다이렉션!

✅ 결과: /home으로 자동 이동 (Navigator 코드 불필요!)
```

### 시나리오 3: 로그인된 상태에서 /login 직접 접근

```
1. 사용자가 context.go('/login') 호출

2. redirect 실행:
   └─> isAuthenticated = true
   └─> hasUser = true
   └─> currentLocation = '/login'
   └─> isGoingToAuth = true
   └─> return RouteNames.home ← 즉시 차단!

✅ 결과: /home으로 리다이렉션 (보안 강화)
```

### 시나리오 4: 미인증 상태에서 protected 화면 접근

```
1. 사용자가 context.go('/expenses') 호출

2. redirect 실행:
   └─> isAuthenticated = false
   └─> currentLocation = '/expenses'
   └─> isGoingToAuth = false
   └─> return RouteNames.login ← 차단!

✅ 결과: /login으로 리다이렉션
```

### 시나리오 5: 401 에러 (토큰 만료)

```
1. API 호출 시 401 에러 발생
   └─> core_providers.dart의 _AuthInterceptor 감지

2. Refresh Token 시도 실패
   └─> authLocalDataSource.clearAll()
   └─> authViewModel.state = AuthState.unauthenticated()
   └─> authStateNotifier.value = true → false (변화!)

3. refreshListenable 감지 → redirect 재실행
   └─> isAuthenticated = false
   └─> currentLocation = '/expenses' (예시)
   └─> return RouteNames.login

✅ 결과: /login으로 자동 리다이렉션
```

---

## 🎨 네비게이션 메서드

### context.go() - 화면 교체

현재 화면을 **제거**하고 새 화면으로 이동합니다.

```dart
context.go('/home');  // 현재 화면 제거 + /home으로 이동
```

- `Navigator.pushReplacement()`와 유사
- 뒤로가기 시 이전 화면이 아닌 그 전 화면으로 이동

**사용 예시:**
```dart
// ❌ 사용 불필요 (redirect가 자동 처리)
// await authViewModel.login(...);
// context.go('/home');  ← 필요 없음!

// ✅ redirect가 알아서 처리합니다!
await authViewModel.login(...);
// → 자동으로 /home으로 이동
```

### context.push() - 화면 스택에 추가

현재 화면 **위에** 새 화면을 추가합니다.

```dart
context.push('/register');
```

- `Navigator.push()`와 유사
- 뒤로가기 시 이전 화면으로 복귀

**사용 예시:**
```dart
// 로그인 화면에서 회원가입 버튼
ElevatedButton(
  onPressed: () => context.push(RouteNames.register),
  child: Text('회원가입'),
)
```

### context.pop() - 현재 화면 닫기

현재 화면을 닫고 이전 화면으로 돌아갑니다.

```dart
context.pop();        // 그냥 뒤로가기
context.pop(result);  // 결과값과 함께 뒤로가기
```

- `Navigator.pop()`과 동일

**사용 예시:**
```dart
// 취소 버튼
TextButton(
  onPressed: () => context.pop(),
  child: Text('취소'),
)

// 결과값 반환
ElevatedButton(
  onPressed: () => context.pop(true),  // true 반환
  child: Text('확인'),
)
```

---

## 📦 extra 파라미터로 객체 전달

복잡한 객체를 화면 간에 전달할 때 사용합니다.

### 객체 전달하기

```dart
// ExpenseListScreen
final expense = ExpenseModel(id: '123', amount: 5000, ...);

ElevatedButton(
  onPressed: () {
    context.push(
      '/expenses/${expense.id}',  // URL 경로
      extra: expense,               // 객체 전달
    );
  },
  child: Text('상세 보기'),
)
```

### 객체 받기

```dart
// app_router.dart
GoRoute(
  path: '/expenses/:id',
  builder: (context, state) {
    // state.extra로 전달된 객체 받기
    final expense = state.extra as ExpenseModel?;

    if (expense == null) {
      // Deep Link로 직접 접근한 경우 (extra가 없음)
      return Scaffold(
        body: Center(
          child: Text('잘못된 접근입니다.'),
        ),
      );
    }

    return ExpenseDetailScreen(expense: expense);
  },
)
```

### 장단점

**장점:**
- ✅ 복잡한 객체를 간단하게 전달 가능
- ✅ URL에 모든 데이터를 포함하지 않아도 됨
- ✅ 코드가 간결함

**단점:**
- ❌ Deep Link로 직접 접근 시 extra가 null
- ❌ 브라우저 새로고침 시 데이터 손실
- ❌ URL만으로는 화면 복원 불가

**대안 (권장):**
```dart
// ID만 전달하고, 화면에서 Provider로 데이터 조회
context.push('/expenses/123');  // ID만 전달

// ExpenseDetailScreen
final expense = ref.watch(expenseProvider('123'));  // Provider에서 조회
```

---

## 🔥 핵심 정리

### refreshListenable의 역할

```dart
final authStateNotifier = ValueNotifier<bool>(authState.isAuthenticated);
//                                             ↑ 이 값의 변화를 감지

ref.listen<AuthState>(authViewModelProvider, (previous, next) {
  authStateNotifier.value = next.isAuthenticated;
  //                        ↑ isAuthenticated 값만 추출
});

refreshListenable: authStateNotifier,
// ↑ GoRouter가 이 Notifier를 watching
```

**즉, `isAuthenticated`가 `false ↔ true`로 변경되면 redirect가 자동 재실행됩니다!**

### 자동 화면 전환 마법 ✨

**기존 방식 (Navigator 1.0):**
```dart
// 로그인 성공 후 수동으로 화면 전환
await authViewModel.login(...);
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
);

// 로그아웃 후 수동으로 화면 전환
await authViewModel.logout();
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => LoginScreen()),
  (route) => false,
);

// 401 에러 후 수동으로 화면 전환
// ... 복잡한 로직 ...
```

**GoRouter 방식:**
```dart
// 로그인 성공
await authViewModel.login(...);
// → redirect가 자동으로 /home으로 이동 ✅

// 로그아웃
await authViewModel.logout();
// → redirect가 자동으로 /login으로 이동 ✅

// 401 에러
authViewModel.state = AuthState.unauthenticated();
// → redirect가 자동으로 /login으로 이동 ✅
```

**화면 전환 코드를 작성하지 않아도 GoRouter가 알아서 처리합니다!** 🎉

---

## 📝 사용 가이드

### 새로운 화면 추가하기

1. **route_names.dart에 경로 추가**
```dart
static const String settings = '/settings';
```

2. **app_router.dart에 라우트 정의**
```dart
GoRoute(
  path: RouteNames.settings,
  name: 'settings',
  builder: (context, state) => const SettingsScreen(),
),
```

3. **네비게이션 사용**
```dart
context.push(RouteNames.settings);
```

### Protected 화면 vs Public 화면

**Protected 화면은 따로 설정하지 않아도 됩니다!**

- `route_names.dart`의 `isAuthRoute()`에 포함되지 않은 모든 화면은 자동으로 protected
- redirect 로직이 자동으로 미인증 사용자를 `/login`으로 리다이렉션

**Public 화면을 추가하려면:**
```dart
// route_names.dart
static bool isAuthRoute(String location) {
  return location == login ||
         location == register ||
         location == findPassword ||
         location == resetPassword ||
         location == newPublicRoute;  // ← 추가
}
```

---

## 🐛 디버깅

### redirect 로그 확인

`router_provider.dart`에서 `debugLogDiagnostics: true`로 설정되어 있어, 콘솔에서 redirect 동작을 확인할 수 있습니다.

```
[GoRouter] redirecting to /home
[GoRouter] matching /home
```

### 일반적인 문제

**Q: 로그인 후 화면이 전환되지 않아요**
```dart
// ❌ authState를 직접 수정하지 마세요
authState.isAuthenticated = true;

// ✅ authViewModel을 통해 상태를 변경하세요
await authViewModel.login(...);
```

**Q: extra로 전달한 객체가 null이에요**
- Deep Link로 직접 접근한 경우 extra가 null입니다
- ID만 전달하고 Provider에서 데이터를 조회하는 방식을 권장합니다

**Q: redirect가 무한 루프에 빠졌어요**
- redirect 로직에서 `return null`을 반환하는 조건이 있는지 확인하세요
- `debugLogDiagnostics: true`로 로그를 확인하세요

---

## 📚 참고 자료

- [GoRouter 공식 문서](https://pub.dev/packages/go_router)
- [Flutter Navigation 가이드](https://docs.flutter.dev/ui/navigation)
- [Riverpod 공식 문서](https://riverpod.dev/)

---

**작성일:** 2025-12-11
**작성자:** Claude Sonnet 4.5
