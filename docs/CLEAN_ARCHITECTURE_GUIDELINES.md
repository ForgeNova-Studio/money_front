# Clean Architecture 가이드라인

> 본 문서는 프로젝트의 **도메인 레이어(Domain Layer)** 를 순수하게 유지하고, **Clean Architecture** 원칙을 준수하기 위한 가이드입니다.

---

## 📌 핵심 원칙

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (Screens, Widgets, ViewModels, Providers)                  │
├─────────────────────────────────────────────────────────────┤
│                       Domain Layer                           │
│  (Entities, UseCases, Repository Interfaces)                │
│  ⚠️ 외부 의존성 금지! 순수 Dart만 사용                        │
├─────────────────────────────────────────────────────────────┤
│                        Data Layer                            │
│  (Models, DataSources, Repository Implementations)          │
│  ✅ JSON 직렬화, API 통신, 캐싱 등 구현                       │
└─────────────────────────────────────────────────────────────┘
```

**의존성 방향**: `Presentation → Domain ← Data`
- Domain Layer는 **아무것에도 의존하지 않습니다**
- Presentation과 Data는 Domain에 의존합니다

---

## ✅ Domain Entity 작성 규칙

### 1. 순수 Dart 클래스로 작성

```dart
// ✅ 올바른 예시
class User {
  final String userId;
  final String email;
  final String nickname;

  const User({
    required this.userId,
    required this.email,
    required this.nickname,
  });
}
```

```dart
// ❌ 잘못된 예시 - freezed 사용
@freezed
class User with _$User {
  const factory User({...}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 2. `const` 생성자 사용

```dart
// ✅ 올바른 예시
const User({
  required this.userId,
  required this.email,
});

// ❌ 잘못된 예시
User({
  required this.userId,
  required this.email,
});
```

### 3. Value Equality 구현 (`==`, `hashCode`)

```dart
class User {
  final String userId;
  final String email;

  const User({required this.userId, required this.email});

  // ✅ 반드시 구현
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          email == other.email;

  @override
  int get hashCode => userId.hashCode ^ email.hashCode;
}
```

> **왜 중요한가?**
> - Riverpod 등 상태 관리에서 객체 비교 시 내용이 같으면 동일하다고 인식
> - 불필요한 리빌드 방지
> - `Set`, `Map` 등 컬렉션에서 올바르게 동작

### 4. List 필드가 있는 경우

```dart
import 'package:flutter/foundation.dart'; // listEquals 사용

class AccountBook {
  final List<MemberInfo>? members;
  // ...

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBook &&
          // ... 다른 필드들 ...
          listEquals(members, other.members); // ✅ List는 listEquals 사용

  @override
  int get hashCode => /* ... */ ^ Object.hashAll(members ?? []);
}
```

### 5. `copyWith` 메서드 (필요시 수동 구현)

```dart
class Expense {
  final int amount;
  final DateTime date;

  const Expense({required this.amount, required this.date});

  // ✅ 필요한 경우 수동 구현
  Expense copyWith({int? amount, DateTime? date}) {
    return Expense(
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
```

---

## ❌ Domain Layer에서 금지되는 것들

### 1. `fromJson` / `toJson` 메서드

```dart
// ❌ Domain Entity에 있으면 안 됨
factory User.fromJson(Map<String, dynamic> json) => ...
Map<String, dynamic> toJson() => ...
```

> **이유**: JSON 직렬화는 **Data Layer의 책임**입니다.

### 2. 외부 패키지 import

```dart
// ❌ 금지
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

// ✅ 허용 (Flutter 기본 제공)
import 'package:flutter/foundation.dart'; // listEquals만 사용
```

### 3. `@freezed`, `@JsonSerializable` 등 코드 생성 어노테이션

```dart
// ❌ 금지
@freezed
@JsonSerializable()
```

---

## ✅ Data Layer에서 해야 할 것들

### 1. Model 클래스에서 JSON 처리

```dart
// data/models/user_model.dart
@JsonSerializable()
class UserModel {
  final String userId;
  final String email;

  UserModel({required this.userId, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // ✅ Entity로 변환
  User toEntity() => User(userId: userId, email: email);

  // ✅ Entity에서 Model로 변환
  factory UserModel.fromEntity(User entity) => UserModel(
    userId: entity.userId,
    email: entity.email,
  );
}
```

### 2. Repository Implementation에서 변환

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    final model = await remoteDataSource.fetchUser(id);
    return model.toEntity(); // ✅ Model → Entity 변환
  }

  @override
  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user); // ✅ Entity → Model 변환
    await remoteDataSource.saveUser(model);
  }
}
```

---

## 📋 새 Entity 생성 체크리스트

새로운 Domain Entity를 만들 때 아래 사항을 확인하세요:

- [ ] `lib/features/{feature}/domain/entities/` 경로에 위치
- [ ] 순수 Dart 클래스로 작성 (외부 패키지 import 없음)
- [ ] `const` 생성자 사용
- [ ] `operator ==` 오버라이드
- [ ] `hashCode` 오버라이드
- [ ] `fromJson` / `toJson` 메서드 **없음**
- [ ] `@freezed`, `@JsonSerializable` 어노테이션 **없음**
- [ ] List 필드가 있다면 `listEquals` 사용
- [ ] 대응되는 Model 클래스가 Data Layer에 존재

---

## 🔍 위반 사례 식별 방법

### 1. grep으로 확인

```bash
# freezed 사용 확인
grep -r "@freezed" lib/features/*/domain/entities/

# fromJson 사용 확인
grep -r "fromJson" lib/features/*/domain/entities/

# 외부 패키지 import 확인
grep -r "package:" lib/features/*/domain/entities/ | grep -v "flutter/foundation"
```

### 2. IDE 린트 규칙 (권장)

`analysis_options.yaml`에 추가:

```yaml
analyzer:
  errors:
    # Domain Layer에서 특정 패키지 import 시 경고
    # (커스텀 린트 플러그인 필요)
```

---

## 📚 참고 자료

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture - Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Dependency Rule](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 📝 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-01-28 | 초안 작성 - BudgetEntity, AccountBook 등 리팩토링 후 |
