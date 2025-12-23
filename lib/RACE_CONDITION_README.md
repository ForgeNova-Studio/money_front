# Race Condition Test Guide (Auth Interceptor)

이 문서는 `_AuthInterceptor`에서 발생할 수 있는 Race Condition(경쟁 상태)을 재현하고 검증하기 위한 가이드를 제공합니다.

## 1. Race Condition이란?
여러 개의 API 요청이 동시에 전송되었을 때, 모든 요청이 401 Unauthorized를 받으면서 각각 독립적으로 리프레시 토큰 요청을 시도하는 현상입니다. 
- **문제점:** 서버 부하 증가, 리프레시 토큰 중복 사용으로 인한 에러 발생 가능성.
- **해결책:** `Lock`을 사용하여 한 번에 하나의 리프레시만 허용하고, 대기하던 요청들은 이미 갱신된 토큰을 재사용하도록 처리.

## 2. 재현 테스트 코드
앱 내의 특정 버튼(`onPressed`)이나 `main.dart`의 초기화 로직에 아래 코드를 추가하여 테스트할 수 있습니다.

```dart
Future<void> testAuthRaceCondition(WidgetRef ref) async {
  final dio = ref.read(dioProvider);
  
  print('🚀 [Test] Race Condition 테스트 시작');
  
  // 동시에 5개 이상의 요청을 병렬로 전송
  try {
    await Future.wait([
      dio.get('/api/users/me'),
      dio.get('/api/incomes?startDate=2025-12-01&endDate=2025-12-31'),
      dio.get('/api/expenses?startDate=2025-12-01&endDate=2025-12-31'),
      dio.get('/api/statistics/monthly?year=2025&month=12'),
      dio.get('/api/budget/2025/12'),
    ]);
    print('✅ [Test] 모든 요청 재시도 성공');
  } catch (e) {
    print('❌ [Test] 테스트 중 에러 발생: $e');
  }
}
```

## 3. 기대 결과 (콘솔 로그)
정상적으로 Race Condition이 해결되었다면 로그가 다음과 같은 순서로 찍혀야 합니다.

1. `[AuthInterceptor] 새로운 Refresh Token 요청 실행` (딱 **1번**)
2. `[AuthInterceptor] 토큰 갱신 성공` (딱 **1번**)
3. `[AuthInterceptor] 토큰이 이미 갱신되었습니다. (Storage Check)` (나머지 대기하던 요청들이 출력)
4. `[AuthInterceptor] 원래 요청 재시도 성공` (모든 요청에 대해 각각 출력)

## 4. 주의사항
- 테스트 전에 실제 토큰이 만료되었거나, 서버에서 강제로 401을 내뱉도록 설정해야 인터셉터 로직이 실행됩니다.
- 로그에 "새로운 Refresh Token 요청 실행"이 여러 번 찍힌다면 로직 수정이 필요합니다.
