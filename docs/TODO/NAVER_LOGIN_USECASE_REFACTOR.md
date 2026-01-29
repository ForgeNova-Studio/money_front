# NaverLoginUseCase 클린 아키텍처 리팩토링

## 개요
`NaverLoginUseCase`가 `flutter_naver_login` SDK를 직접 호출하고 있어 클린 아키텍처 원칙 위반.

## 현재 문제
- **파일**: `lib/features/auth/domain/usecases/naver_login_usecase.dart`
- **위반 내용**: Domain Layer(UseCase)에서 외부 플러그인(`flutter_naver_login`) 직접 import
- **영향**: Domain이 Flutter SDK에 강하게 결합되어 테스트 어려움, 유지보수성 저하

## 해결 방안

### 1. 추상 인터페이스 생성 (Domain Layer)
```dart
// lib/features/auth/domain/datasources/social_login_data_source.dart
abstract class SocialLoginDataSource {
  Future<SocialLoginResult> loginWithNaver();
  Future<SocialLoginResult> loginWithKakao();
  // ... 기타 소셜 로그인
}

class SocialLoginResult {
  final String accessToken;
  final String? email;
  final String? nickname;
  // ...
}
```

### 2. Data Layer에서 구현
```dart
// lib/features/auth/data/datasources/social_login_data_source_impl.dart
class SocialLoginDataSourceImpl implements SocialLoginDataSource {
  @override
  Future<SocialLoginResult> loginWithNaver() async {
    // flutter_naver_login SDK 호출 로직 여기로 이동
  }
}
```

### 3. UseCase 수정
```dart
class NaverLoginUseCase {
  final AuthRepository _repository;
  final SocialLoginDataSource _socialLoginDataSource;

  Future<AuthResult> call() async {
    final result = await _socialLoginDataSource.loginWithNaver();
    return await _repository.loginWithNaver(
      accessToken: result.accessToken,
      email: result.email,
      nickname: result.nickname,
    );
  }
}
```

## 우선순위
- **중요도**: 중간
- **작업량**: 중간 (약 2-3시간)
- **의존성**: 없음

## 기타 참고
- 같은 패턴으로 `KakaoLoginUseCase`, `GoogleLoginUseCase` 등도 점검 필요
