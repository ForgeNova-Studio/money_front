// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:moamoa/core/providers/core_providers.dart';
// import 'package:moamoa/features/auth/data/datasources/local/auth_local_datasource.dart';
// import 'package:moamoa/features/auth/data/models/auth_token_model.dart';
// import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';
// import 'package:moamoa/core/constants/api_constants.dart';

// // Mock 클래스 생성을 위한 어노테이션
// @GenerateNiceMocks([
//   MockSpec<AuthLocalDataSource>(),
// ])
// import 'auth_interceptor_test.mocks.dart';

// void main() {
//   late ProviderContainer container;
//   late MockAuthLocalDataSource mockAuthLocalDataSource;
//   late Dio dio;

//   setUp(() {
//     mockAuthLocalDataSource = MockAuthLocalDataSource();
//     container = ProviderContainer(
//       overrides: [
//         authLocalDataSourceProvider.overrideWithValue(mockAuthLocalDataSource),
//       ],
//     );
//     dio = container.read(dioProvider);
    
//     // PrettyDioLogger는 테스트 출력을 지저분하게 할 수 있으므로 
//     // 실제 테스트 시에는 인터셉터 설정을 조정하거나 그대로 둡니다.
//   });

//   test('Race Condition Test: Multiple 401 errors should trigger only ONE refresh request', () async {
//     // 1. 초기 상태 설정: 만료된 토큰이 있는 것처럼 시뮬레이션
//     final expiredToken = AuthTokenModel(
//       accessToken: 'expired_access',
//       refreshToken: 'valid_refresh',
//     );
//     final newToken = AuthTokenModel(
//       accessToken: 'new_access',
//       refreshToken: 'new_refresh',
//     );

//     when(mockAuthLocalDataSource.getToken()).thenAnswer((_) async => expiredToken);

//     int refreshCallCount = 0;

//     // 2. Mock Adapter로 Dio 동작 정의
//     // 참고: 실제 HTTP 요청을 보내지 않도록 BaseOptions의 baseUrl을 무시하거나 
//     // 테스트용 HttpClientAdapter를 설정해야 하지만, 여기선 인터셉터 로직 검증에 집중합니다.
    
//     // ⚠️ 주의: 이 테스트를 실행하려면 실제 서버가 응답하거나 
//     // MockAdapter를 써서 401 응답과 Refresh 성공 응답을 흉내내야 합니다.
    
//     print('--- Race Condition 테스트 시작 ---');
//     print('동시에 5개의 요청을 보냅니다...');

//     // 이 부분은 개념 증명을 위한 가이드이며, 
//     // 실제 실행 가능한 테스트를 위해서는 http_mock_adapter 패키지 추가를 권장합니다.
//     // 현재는 로직 설계 구조상 '어떻게 재현할 것인가'에 대한 답변으로 갈음합니다.
//   });
// }
