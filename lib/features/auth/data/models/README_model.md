# Data 레이어의 모델 역할
외부 데이터 (API/Storage) -> Data Model -> Domain Entity
Data 모델은 API 응답을 파싱하고 Domain Entity로 변환하는 역할을 한다.

## 예시
 1. API 응답 처리
// API 응답 JSON
{
"userId": "123",
"email": "user@example.com",
"nickname": "홍길동",
"profileImage": "https://..."
}

// ↓ UserModel.fromJson() 파싱

UserModel(
userId: "123",
email: "user@example.com",
nickname: "홍길동",
profileImageUrl: "https://..."
)

2. Domain Entity로 변환

// UserModel
UserModel(
userId: "123",           // API 필드명
profileImageUrl: "..."   // API 필드명
)

// ↓ .toEntity() 변환

// User (Domain Entity)
User(
userId: "123",          // 도메인 필드명
lastLoginAt: null       // 도메인 필드명
)

# 왜 이렇게 분리하나?
1. API 변경에 강함
- API 필드가 변경되어도 Domain Entity는 변경하지 않고 Data Model만 변경하면 됨

    // API 필드명이 변경되어도
    // Before: "userId"
    // After: "user_id"

    // ✅ UserModel만 수정
    factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['user_id'],  // 여기만 수정
        ...
        );
    }

2. 비즈니스 로직 순수성
- Domain Entity는 비즈니스 로직을 포함하지 않음
- Data Model은 API 응답을 파싱하고 Domain Entity로 변환하는 역할만 수행
- .FromJson, toDomain과 같은 처리

# 실제 사용 흐름 예시

  Repository Implementation에서:

  class AuthRepositoryImpl implements AuthRepository {
    final Dio dio;

    @override
    Future<AuthResult> login({
      required String email,
      required String password,
    }) async {
      try {
        // 1. API 호출
        final response = await dio.post('/auth/login', data: {
          'email': email,
          'password': password,
        });

        // 2. ✅ Data Model로 파싱
        final authResponse = AuthResponseModel.fromJson(response.data);

        // 3. ✅ Domain Entity로 변환 후 반환
        return authResponse.toEntity();  // AuthResult 반환

      } on DioException catch (e) {
        throw ExceptionHandler.handleDioException(e);
      }
    }
  }