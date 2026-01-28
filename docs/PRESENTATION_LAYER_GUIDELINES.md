# Presentation Layer 가이드라인

> Presentation Layer는 **UI와 사용자 상호작용**을 담당합니다.
> Domain Layer의 UseCase를 호출하고, 결과를 화면에 표시합니다.

---

## 📌 Presentation Layer 구조

```
lib/features/{feature}/presentation/
├── screens/           # 화면 (페이지)
├── widgets/           # 재사용 가능한 위젯
├── providers/         # Riverpod Provider 정의
├── viewmodels/        # 상태 관리 ViewModel (StateNotifier 등)
└── states/            # 상태 클래스 (freezed 사용 가능)
```

---

## ✅ 허용되는 것들

### 1. Flutter UI 코드

```dart
// ✅ 허용
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('홈')),
      body: ListView(...),
    );
  }
}
```

### 2. `setState` 사용 (로컬 UI 상태)

```dart
// ✅ 허용 - 간단한 UI 상태
class _MyWidgetState extends State<MyWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(...),
    );
  }
}
```

### 3. Riverpod Provider 사용

```dart
// ✅ 허용
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    
    return homeState.when(
      loading: () => CircularProgressIndicator(),
      data: (data) => HomeContent(data: data),
      error: (e, st) => ErrorWidget(error: e),
    );
  }
}
```

### 4. Domain Entity 직접 사용

```dart
// ✅ 허용 - Entity는 어디서든 사용 가능
import 'package:myapp/features/user/domain/entities/user.dart';

class UserProfile extends StatelessWidget {
  final User user; // ✅ Domain Entity 사용 OK

  const UserProfile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Text(user.nickname);
  }
}
```

### 5. UseCase 호출 (Provider를 통해)

```dart
// ✅ 허용 - Provider를 통해 UseCase 호출
class HomeViewModel extends StateNotifier<HomeState> {
  final GetMonthlyDataUseCase _getMonthlyDataUseCase;

  HomeViewModel(this._getMonthlyDataUseCase) : super(HomeState.initial());

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final result = await _getMonthlyDataUseCase.execute(); // ✅ UseCase 호출
    state = state.copyWith(isLoading: false, data: result);
  }
}
```

### 6. Presentation Layer 전용 State 클래스 (freezed 허용)

```dart
// ✅ 허용 - Presentation Layer의 State는 freezed 사용 가능
// lib/features/home/presentation/states/home_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool isLoading,
    required List<Transaction> transactions,
    String? errorMessage,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState(
    isLoading: false,
    transactions: [],
  );
}
```

> **주의**: Domain Entity에는 freezed 금지, Presentation State에는 허용

---

## ❌ 금지되는 것들

### 1. Data Layer 직접 접근

```dart
// ❌ 금지 - DataSource 직접 호출
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(remoteDataSourceProvider);
    final data = await dataSource.fetchData(); // ❌ 직접 호출 금지!
  }
}
```

```dart
// ✅ 올바른 방법 - UseCase/Repository 통해 접근
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider); // ✅
  }
}
```

### 2. Repository Implementation Import

```dart
// ❌ 금지
import 'package:myapp/features/user/data/repositories/user_repository_impl.dart';

// ✅ 허용 - Interface만 import
import 'package:myapp/features/user/domain/repositories/user_repository.dart';
```

### 3. Model 클래스 직접 사용

```dart
// ❌ 금지 - Data Layer의 Model 직접 사용
import 'package:myapp/features/user/data/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user; // ❌ Model 사용 금지
}

// ✅ 허용 - Domain Entity 사용
import 'package:myapp/features/user/domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user; // ✅ Entity 사용
}
```

### 4. API 직접 호출

```dart
// ❌ 금지 - Dio/http 직접 사용
class HomeScreen extends StatelessWidget {
  final Dio dio;

  Future<void> _fetchData() async {
    final response = await dio.get('/api/users'); // ❌ 직접 호출 금지!
  }
}
```

### 5. JSON 직렬화/역직렬화

```dart
// ❌ 금지 - Presentation에서 JSON 처리
void _handleResponse(Map<String, dynamic> json) {
  final user = User.fromJson(json); // ❌ fromJson 호출 금지!
}
```

---

## 📋 Presentation Layer 체크리스트

### Screen/Widget 작성 시

- [ ] Domain Entity만 사용 (Model 클래스 사용 X)
- [ ] UseCase는 Provider/ViewModel을 통해 호출
- [ ] API 직접 호출 없음
- [ ] Repository Interface만 참조 (Implementation 참조 X)

### ViewModel/Provider 작성 시

- [ ] UseCase 주입받아 사용
- [ ] State 변경은 `copyWith` 또는 새 인스턴스 생성
- [ ] 비즈니스 로직은 UseCase에 위임
- [ ] UI 표시용 로직만 포함 (포맷팅, 정렬 등)

---

## 🔍 올바른 의존성 흐름

```
┌─────────────────────────────────────────────────────────────┐
│  Screen (UI)                                                │
│    ↓ watch                                                  │
│  Provider (ViewModel)                                       │
│    ↓ call                                                   │
│  UseCase (Domain)                                           │
│    ↓ call                                                   │
│  Repository Interface (Domain)                              │
│    ↓ implemented by                                         │
│  Repository Implementation (Data)                           │
│    ↓ call                                                   │
│  DataSource (Data)                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Best Practices

### 1. 화면별 ViewModel 분리

```dart
// ✅ 권장 - 화면마다 전용 ViewModel
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(...);
final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(...);
```

### 2. UI 로직과 비즈니스 로직 분리

```dart
// ✅ UI 로직 (Presentation) - 포맷팅, 정렬 등
String formatCurrency(int amount) => '₩${amount.toStringAsFixed(0)}';

// ✅ 비즈니스 로직 (Domain UseCase) - 계산, 검증 등
class CalculateBudgetUseCase {
  double execute(int spent, int total) => spent / total * 100;
}
```

### 3. Error Handling

```dart
// ✅ ViewModel에서 에러 처리
class HomeViewModel extends StateNotifier<HomeState> {
  Future<void> loadData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final data = await _useCase.execute();
      state = state.copyWith(isLoading: false, data: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

---

## 📝 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-01-28 | 초안 작성 |
