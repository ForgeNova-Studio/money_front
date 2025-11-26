# Data Models - Freezed 가이드

## 개요

Data Layer의 Model 클래스들은 **Freezed**를 사용하여 작성합니다.
- API 응답 파싱
- Domain Entity 변환
- 불변성(Immutability) 보장
- 보일러플레이트 코드 자동 생성

---

## Freezed란?

**Freezed**: Dart 코드 생성 패키지로 불변 클래스를 쉽게 만들어주는 도구

### 자동 생성되는 기능
- ✅ `copyWith()` - 객체 복사 및 수정
- ✅ `toJson()` - JSON 직렬화
- ✅ `operator ==` - 동등성 비교
- ✅ `hashCode` - 해시 코드
- ✅ `toString()` - 문자열 표현

---

## 생성 파일 설명

### 1. `.freezed.dart` 파일
**역할**: Freezed 관련 코드 생성
- copyWith() 메서드
- == 연산자, hashCode
- toString() 메서드
- union type 관련 코드 (여러 변형이 있는 경우)

**예시**: `user_model.freezed.dart`
```dart
// 자동 생성된 copyWith
UserModel copyWith({
  String? userId,
  String? email,
  String? nickname,
  String? profileImageUrl,
}) { ... }

// 자동 생성된 == 연산자
@override
bool operator ==(Object other) { ... }
```

### 2. `.g.dart` 파일
**역할**: JSON 직렬화/역직렬화 코드 생성
- `fromJson()` - JSON → Model
- `toJson()` - Model → JSON
- @JsonKey 애노테이션 처리

**예시**: `user_model.g.dart`
```dart
// 자동 생성된 fromJson
UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel(
    userId: json['user_id'] as String,  // @JsonKey 처리
    email: json['email'] as String,
    nickname: json['nickname'] as String,
    profileImageUrl: json['profileImageUrl'] as String?,
  );
}

// 자동 생성된 toJson
Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  return {
    'user_id': instance.userId,  // @JsonKey 처리
    'email': instance.email,
    'nickname': instance.nickname,
    'profileImageUrl': instance.profileImageUrl,
  };
}
```

### 생성 파일 관리
```bash
# Git에 포함해야 함 (팀원들과 공유)
user_model.freezed.dart  ✅ Git 추가
user_model.g.dart        ✅ Git 추가

# .gitignore에 추가하지 말 것!
```

---

## Factory 생성자 vs 일반 메서드 ⭐

### 핵심 규칙
```
나(Model) ──to...──→ 다른곳     (일반 메서드)
나(Model) ←─from...── 다른곳   (factory 생성자)
```

**간단 정리:**
- **나에게서 나가면** → 일반 메서드 (`to...`)
- **다른곳에서 들어오면** → factory 생성자 (`from...`)

---

### 🏭 Factory 생성자 (from...) - "생성"

**역할:** 외부 데이터로부터 **이 클래스의 인스턴스를 만들어서 반환**

```dart
// ✅ factory - AuthTokenModel을 만듦
factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
  return AuthTokenModel(...);  // ← AuthTokenModel 생성
}

factory AuthTokenModel.fromStorage(Map<String, dynamic> json) {
  return AuthTokenModel(...);  // ← AuthTokenModel 생성
}

factory AuthTokenModel.fromEntity(AuthToken token) {
  return AuthTokenModel(...);  // ← AuthTokenModel 생성
}
```

**사용 예시:**
```dart
// 다른 데이터 → AuthTokenModel 생성
final model1 = AuthTokenModel.fromJson(jsonData);      // JSON에서 들어옴
final model2 = AuthTokenModel.fromStorage(storage);    // Storage에서 들어옴
final model3 = AuthTokenModel.fromEntity(entity);      // Entity에서 들어옴
```

---

### 🔄 일반 메서드 (to...) - "변환"

**역할:** 이미 존재하는 인스턴스를 **다른 타입으로 변환해서 나감**

```dart
// ✅ 일반 메서드 - 다른 타입을 반환
AuthToken toEntity() {
  return AuthToken(...);  // ← AuthToken(다른 클래스)로 나감
}

Map<String, dynamic> toJson() {
  return { ... };  // ← Map으로 나감
}
```

**사용 예시:**
```dart
// AuthTokenModel → 다른 데이터로 변환
final model = AuthTokenModel(...);  // 이미 존재

final entity = model.toEntity();    // Entity로 나감
final json = model.toJson();        // JSON으로 나감
```

---

### 비교 표

| 구분 | Factory 생성자 (from...) | 일반 메서드 (to...) |
|------|----------------------|------------------|
| **방향** | 들어옴 ← | 나감 → |
| **반환 타입** | 자기 자신 (AuthTokenModel) | 다른 타입 (AuthToken, Map 등) |
| **목적** | 객체 **생성** | 객체 **변환** |
| **시작점** | 외부 데이터 | 이미 존재하는 인스턴스 |
| **호출 방식** | `AuthTokenModel.from...()` | `instance.to...()` |
| **예시** | `fromJson`, `fromStorage`, `fromEntity` | `toEntity`, `toJson` |

---

### 전체 흐름 예시

```dart
// 1. Storage 데이터가 있음
final storageData = {'accessToken': 'abc', 'expiresAt': '2024-01-01'};

// 2. Storage → Model (들어옴 ← factory)
final model = AuthTokenModel.fromStorage(storageData);
//            ↑ from... = 생성 (factory)

// 3. Model → Entity (나감 → 메서드)
final entity = model.toEntity();
//             ↑ to... = 변환 (메서드)

// 4. Entity → Model (들어옴 ← factory)
final newModel = AuthTokenModel.fromEntity(entity);
//               ↑ from... = 생성 (factory)

// 5. Model → JSON (나감 → 메서드)
final json = newModel.toJson();
//           ↑ to... = 변환 (메서드)
```

---

### 왜 이렇게 구분하나?

#### 1. 의미의 명확성
```dart
// "이것으로 Model 만들어줘" (들어옴)
AuthTokenModel.fromJson(json)
AuthTokenModel.fromStorage(data)
AuthTokenModel.fromEntity(entity)

// "이 Model을 저것으로 바꿔줘" (나감)
model.toEntity()
model.toJson()
```

#### 2. Dart 문법 규칙
```dart
// ❌ 일반 메서드는 자신을 반환할 수 없음
AuthTokenModel fromStorage(Map json) {
  return AuthTokenModel(...);  // 에러!
}

// ✅ factory는 자신을 반환 가능
factory AuthTokenModel.fromStorage(Map json) {
  return AuthTokenModel(...);  // OK!
}
```

---

## Freezed Model 작성 방법

### 기본 구조

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';  // Freezed 생성 파일
part 'user_model.g.dart';        // JSON 생성 파일

@freezed
class UserModel with _$UserModel {
  const UserModel._();  // 커스텀 메서드용 private 생성자

  const factory UserModel({
    required String userId,
    required String email,
    required String nickname,
    String? profileImageUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json)
      => _$UserModelFromJson(json);  // 자동 생성 함수 호출

  // ✅ 커스텀 메서드 (수동 작성)
  User toEntity() {
    return User(
      userId: userId,
      email: email,
      nickname: nickname,
    );
  }
}
```

### 필수 요소 체크리스트

- [ ] `part 'xxx.freezed.dart';` 추가
- [ ] `part 'xxx.g.dart';` 추가
- [ ] `@freezed` 애노테이션
- [ ] `with _$ClassName` 믹스인
- [ ] `const ClassName._();` (커스텀 메서드가 있는 경우)
- [ ] `factory fromJson` → `_$ClassNameFromJson(json)` 호출

---

## API 필드명 매핑 (@JsonKey)

### 언제 사용하나?

**API 필드명과 Dart 필드명이 다를 때 사용**

```dart
// API 응답 (snake_case)
{
  "user_id": "123",
  "profile_image": "https://..."
}

// Dart Model (camelCase + @JsonKey)
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'profile_image') String? profileImageUrl,
  }) = _UserModel;
}
```

### @JsonKey 사용법

#### 1. 기본 필드명 매핑
```dart
@JsonKey(name: 'user_id') required String userId,
```

#### 2. 기본값 지정
```dart
@JsonKey(name: 'is_active', defaultValue: false) required bool isActive,
```

#### 3. null 값 제외
```dart
@JsonKey(includeIfNull: false) String? optionalField,
```

#### 4. 커스텀 변환
```dart
@JsonKey(
  name: 'created_at',
  fromJson: _dateTimeFromJson,
  toJson: _dateTimeToJson,
)
DateTime? createdAt,

static DateTime? _dateTimeFromJson(String? value) {
  return value != null ? DateTime.parse(value) : null;
}

static String? _dateTimeToJson(DateTime? dateTime) {
  return dateTime?.toIso8601String();
}
```

### 주의사항: @JsonKey 에러

**에러**: `The annotation 'JsonKey.new' can only be used on fields or getters`

**해결**: @JsonKey를 한 줄로 작성
```dart
// ❌ 2줄로 작성하면 에러
@JsonKey(name: 'user_id')
required String userId,

// ✅ 1줄로 작성
@JsonKey(name: 'user_id') required String userId,
```

---

## 코드 생성 명령어

### Watch 모드 (개발 중 권장)
```bash
# 파일 변경 시 자동으로 재생성
dart run build_runner watch -d
```

### 일회성 생성
```bash
# 한 번만 생성
dart run build_runner build

# 충돌 파일 삭제하고 재생성
dart run build_runner build --delete-conflicting-outputs
```

### 생성된 파일 확인
```bash
ls lib/features/auth/data/models/
# user_model.dart
# user_model.freezed.dart  ← 자동 생성
# user_model.g.dart        ← 자동 생성
```

---

## 자주 발생하는 에러

### 1. `part 'xxx.freezed.dart' not found`
**원인**: 코드 생성 안 됨
**해결**: `dart run build_runner build`

### 2. `The name '_$ClassName' isn't defined`
**원인**: 코드 생성이 안 되었거나 part 파일 누락
**해결**:
1. part 파일 확인
2. build_runner 실행

### 3. `Missing concrete implementation`
**원인**: factory 생성자 작성 실수
**해결**: `= _ClassName` 확인

```dart
// ✅ 올바름
const factory UserModel({...}) = _UserModel;

// ❌ 잘못됨
const factory UserModel({...});  // = _UserModel 누락
```

### 4. `@JsonKey` 에러
**원인**: 2줄로 작성
**해결**: 한 줄로 작성

---

## 실무 작업 흐름

### 1️⃣ API 응답 확인
```json
{
  "user_id": "123",
  "email": "user@example.com",
  "nickname": "홍길동",
  "profile_image": "https://..."
}
```

### 2️⃣ Freezed Model 작성
```dart
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    required String nickname,
    @JsonKey(name: 'profile_image') String? profileImageUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json)
      => _$UserModelFromJson(json);

  User toEntity() { ... }
}
```

### 3️⃣ 코드 생성
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4️⃣ 검증
```bash
flutter analyze lib/features/auth/data/models/
```

---

## Data Model vs Domain Entity

### Data Model (여기)
- API 구조에 맞춤
- JSON 직렬화/역직렬화
- `fromJson()`, `toJson()` 포함
- @JsonKey로 필드명 매핑

### Domain Entity (domain/entities)
- 비즈니스 로직 중심
- 순수 Dart 클래스
- JSON 의존성 없음
- 외부 데이터 구조와 독립적

### 변환 흐름
```
API JSON → Data Model → Domain Entity
         ↑ fromJson  ↑ toEntity
```

---

## 체크리스트

### Model 작성 시
- [ ] API 응답 구조 확인
- [ ] @freezed 애노테이션 추가
- [ ] part 파일 2개 추가
- [ ] factory 생성자 작성 (= _ClassName)
- [ ] fromJson factory 작성
- [ ] @JsonKey로 필드명 매핑 (필요 시)
- [ ] toEntity() 커스텀 메서드 작성
- [ ] build_runner 실행
- [ ] 생성 파일 확인 (.freezed.dart, .g.dart)

### 의존성 확인
```yaml
# pubspec.yaml
dependencies:
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  build_runner: ^2.4.13
```

---

## 참고 자료

- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [json_serializable](https://pub.dev/packages/json_serializable)
- [Freezed + Riverpod 예제](https://codewithandrea.com/articles/flutter-state-management-riverpod/)
