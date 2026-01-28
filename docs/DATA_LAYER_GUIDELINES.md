# Data Layer 가이드라인

> Data Layer는 **데이터 소스와의 통신 및 데이터 변환**을 담당합니다.
> API 호출, 로컬 저장소, JSON 직렬화 등 모든 "더러운 작업"이 여기서 이루어집니다.

---

## 📌 Data Layer 구조

```
lib/features/{feature}/data/
├── datasources/
│   ├── local/         # 로컬 저장소 (Hive, SharedPreferences 등)
│   └── remote/        # 원격 API (Dio, Retrofit 등)
├── models/            # JSON 직렬화용 Model 클래스
└── repositories/      # Repository 구현체
```

---

## ✅ Data Layer의 책임

### 1. JSON 직렬화/역직렬화

```dart
// ✅ Data Layer에서 처리
// lib/features/user/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userId;
  final String email;
  final String nickname;

  UserModel({
    required this.userId,
    required this.email,
    required this.nickname,
  });

  // ✅ JSON 변환은 여기서
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

### 2. Entity ↔ Model 변환

```dart
// lib/features/user/data/models/user_model.dart

@JsonSerializable()
class UserModel {
  // ... 필드들 ...

  // ✅ Model → Entity 변환
  User toEntity() {
    return User(
      userId: userId,
      email: email,
      nickname: nickname,
    );
  }

  // ✅ Entity → Model 변환
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      userId: entity.userId,
      email: entity.email,
      nickname: entity.nickname,
    );
  }
}
```

### 3. API 통신

```dart
// lib/features/user/data/datasources/remote/user_remote_datasource.dart

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String userId);
  Future<void> updateUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUser(String userId) async {
    final response = await dio.get('/users/$userId');
    return UserModel.fromJson(response.data); // ✅ JSON → Model
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await dio.put('/users/${user.userId}', data: user.toJson()); // ✅ Model → JSON
  }
}
```

### 4. Repository 구현

```dart
// lib/features/user/data/repositories/user_repository_impl.dart

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> getUser(String userId) async {
    try {
      // 1. 원격에서 가져오기
      final model = await remoteDataSource.getUser(userId);
      
      // 2. 로컬에 캐시
      await localDataSource.cacheUser(model);
      
      // 3. Entity로 변환하여 반환
      return model.toEntity(); // ✅ Model → Entity
    } catch (e) {
      // 4. 실패 시 로컬 캐시 사용
      final cached = await localDataSource.getCachedUser(userId);
      return cached.toEntity();
    }
  }

  @override
  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user); // ✅ Entity → Model
    await remoteDataSource.updateUser(model);
  }
}
```

### 5. 로컬 캐싱

```dart
// lib/features/user/data/datasources/local/user_local_datasource.dart

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<Map> userBox;

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put(user.userId, user.toJson()); // ✅ JSON으로 저장
  }

  @override
  Future<UserModel> getCachedUser(String userId) async {
    final json = userBox.get(userId);
    if (json == null) throw CacheException();
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }
}
```

---

## ✅ 허용되는 것들

| 항목 | 설명 |
|------|------|
| `@JsonSerializable` | Model 클래스에서 사용 |
| `@freezed` + `@JsonSerializable` | Model 클래스에서 사용 가능 |
| `fromJson` / `toJson` | Model 클래스에서 구현 |
| Dio, Retrofit | DataSource에서 사용 |
| Hive, SharedPreferences | Local DataSource에서 사용 |
| Exception 처리 | DataSource/Repository에서 처리 |

---

## ❌ 금지되는 것들

### 1. Domain Entity에서 직접 JSON 처리

```dart
// ❌ 금지 - Domain Entity
class User {
  factory User.fromJson(Map<String, dynamic> json) => ...; // ❌
  Map<String, dynamic> toJson() => ...; // ❌
}

// ✅ 허용 - Data Model
class UserModel {
  factory UserModel.fromJson(Map<String, dynamic> json) => ...; // ✅
  Map<String, dynamic> toJson() => ...; // ✅
}
```

### 2. UI 로직 포함

```dart
// ❌ 금지 - Repository에서 UI 관련 처리
class UserRepositoryImpl implements UserRepository {
  Future<String> getFormattedUsername() async {
    final user = await getUser();
    return '${user.nickname}님 환영합니다!'; // ❌ UI 텍스트는 Presentation에서
  }
}
```

### 3. 비즈니스 로직 포함

```dart
// ❌ 금지 - Repository에서 비즈니스 로직
class BudgetRepositoryImpl implements BudgetRepository {
  Future<bool> isOverBudget() async {
    final budget = await getBudget();
    return budget.spent > budget.limit; // ❌ 비즈니스 로직은 UseCase에서
  }
}

// ✅ 올바른 위치 - Domain UseCase
class CheckBudgetStatusUseCase {
  bool execute(Budget budget) {
    return budget.spent > budget.limit; // ✅ UseCase에서 처리
  }
}
```

---

## 📋 Model 클래스 작성 규칙

### 1. 기본 구조

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/features/user/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userId;
  final String email;
  
  @JsonKey(name: 'nick_name') // API 필드명이 다른 경우
  final String nickname;

  UserModel({
    required this.userId,
    required this.email,
    required this.nickname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // ✅ 필수: Entity 변환 메서드
  User toEntity() => User(
    userId: userId,
    email: email,
    nickname: nickname,
  );

  factory UserModel.fromEntity(User entity) => UserModel(
    userId: entity.userId,
    email: entity.email,
    nickname: entity.nickname,
  );
}
```

### 2. 중첩 객체 처리

```dart
@JsonSerializable()
class AccountBookModel {
  final String id;
  final String name;
  final List<MemberInfoModel> members; // ✅ 중첩 Model

  AccountBookModel({...});

  AccountBook toEntity() => AccountBook(
    id: id,
    name: name,
    members: members.map((m) => m.toEntity()).toList(), // ✅ 각각 변환
  );
}
```

### 3. DateTime 처리

```dart
@JsonSerializable()
class TransactionModel {
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime date;

  static DateTime _dateFromJson(String date) => DateTime.parse(date);
  static String _dateToJson(DateTime date) => date.toIso8601String();
}
```

---

## 📋 DataSource 작성 규칙

### 1. Interface 정의

```dart
// lib/features/user/data/datasources/user_remote_datasource.dart

abstract class UserRemoteDataSource {
  /// 사용자 정보 조회
  /// 
  /// Throws [ServerException] 서버 오류 시
  /// Throws [UnauthorizedException] 인증 실패 시
  Future<UserModel> getUser(String userId);

  Future<List<UserModel>> getUsers();

  Future<void> updateUser(UserModel user);
}
```

### 2. Implementation

```dart
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final response = await dio.get('/users/$userId');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e); // ✅ 에러 변환
    }
  }

  Exception _handleError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return UnauthorizedException();
      case 404:
        return NotFoundException();
      default:
        return ServerException(e.message);
    }
  }
}
```

---

## 📋 Repository Implementation 규칙

### 1. Interface는 Domain Layer에

```dart
// lib/features/user/domain/repositories/user_repository.dart (Domain)

abstract class UserRepository {
  Future<User> getUser(String userId);
  Future<void> saveUser(User user);
}
```

### 2. Implementation은 Data Layer에

```dart
// lib/features/user/data/repositories/user_repository_impl.dart (Data)

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  @override
  Future<User> getUser(String userId) async {
    final model = await remoteDataSource.getUser(userId);
    return model.toEntity(); // ✅ Model → Entity
  }

  @override
  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user); // ✅ Entity → Model
    await remoteDataSource.updateUser(model);
  }
}
```

---

## 🔍 의존성 주입 (Provider 예시)

```dart
// lib/features/user/presentation/providers/user_providers.dart

// DataSource
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRemoteDataSourceImpl(dio: dio);
});

// Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});

// UseCase
final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserUseCase(repository: repository);
});
```

---

## 📋 Data Layer 체크리스트

### Model 클래스 작성 시

- [ ] `@JsonSerializable()` 어노테이션
- [ ] `fromJson` factory 메서드
- [ ] `toJson` 메서드
- [ ] `toEntity()` 변환 메서드
- [ ] `fromEntity()` factory 메서드
- [ ] 중첩 객체도 Model로 정의

### DataSource 작성 시

- [ ] Interface 먼저 정의
- [ ] DioException 등 에러 처리
- [ ] Model 클래스 반환 (Entity 아님)

### Repository Implementation 작성 시

- [ ] Domain의 Repository Interface 구현
- [ ] DataSource 주입받아 사용
- [ ] Model → Entity 변환 후 반환
- [ ] Entity → Model 변환 후 저장

---

## 📝 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-01-28 | 초안 작성 |
