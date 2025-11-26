// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// dataSources
import 'package:moneyflow/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:moneyflow/features/auth/data/datasources/remote/auth_remote_datasource.dart';

// models
import 'package:moneyflow/features/auth/data/models/auth_token_model.dart';
import 'package:moneyflow/features/auth/data/models/user_model.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';
import 'package:moneyflow/features/auth/domain/entities/auth_token.dart';
import 'package:moneyflow/features/auth/domain/entities/user.dart';

// repositories
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// Auth Repository 구현체
///
/// Data Layer의 DataSource들을 조합하여 Domain Layer의 요청을 처리
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // 1. Remote API 호출
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );

    // 2. Local Storage에 저장
    // AuthResponseModel에서 TokenModel과 UserModel 추출
    final tokenModel = AuthTokenModel(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn,
    );

    // profile Map을 UserModel로 변환
    final profileData = Map<String, dynamic>.from(response.profile);
    if (!profileData.containsKey('userId')) {
      profileData['userId'] = response.userId;
    }
    final userModel = UserModel.fromJson(profileData);

    await localDataSource.saveToken(tokenModel);
    await localDataSource.saveUser(userModel);

    // 3. Entity 변환 및 반환
    return response.toEntity();
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    // 1. Remote API 호출
    final response = await remoteDataSource.register(
      email: email,
      password: password,
      nickname: nickname,
    );

    // 2. Local Storage에 저장
    final tokenModel = AuthTokenModel(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn,
    );

    final profileData = Map<String, dynamic>.from(response.profile);
    if (!profileData.containsKey('userId')) {
      profileData['userId'] = response.userId;
    }
    final userModel = UserModel.fromJson(profileData);

    await localDataSource.saveToken(tokenModel);
    await localDataSource.saveUser(userModel);

    // 3. Entity 변환 및 반환
    return response.toEntity();
  }

  @override
  Future<void> logout() async {
    // Local Storage 데이터 삭제
    await localDataSource.clearAll();
    // 필요 시 Remote Logout 호출 (현재 API 없음)
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    // 1. Remote API 호출
    final tokenModel = await remoteDataSource.refreshToken(refreshToken);

    // 2. Local Storage 업데이트
    await localDataSource.saveToken(tokenModel);

    // 3. Entity 변환 및 반환
    return tokenModel.toEntity();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // 1. Remote에서 최신 정보 가져오기
      final userModel = await remoteDataSource.getCurrentUser();

      // 2. Local 캐시 업데이트
      await localDataSource.saveUser(userModel);

      return userModel.toEntity();
    } catch (e) {
      // 3. 실패 시 예외 처리
      if (e is NetworkException) {
        // 네트워크 오류 시 로컬 데이터 시도
        final localUser = await localDataSource.getUser();
        if (localUser != null) {
          return localUser.toEntity();
        }
      } else if (e is UnauthorizedException) {
        // 인증 실패 시 로컬 데이터 삭제
        await localDataSource.clearAll();
        return null;
      }

      // 그 외의 경우 (또는 로컬 데이터도 없는 경우)
      // 저장된 토큰이 없다면 null 반환 (로그인 안 된 상태)
      final hasToken = await localDataSource.hasToken();
      if (!hasToken) {
        return null;
      }

      // 토큰은 있는데 에러가 난 경우 (서버 오류 등)
      rethrow;
    }
  }

  @override
  Future<AuthToken?> getStoredToken() async {
    final tokenModel = await localDataSource.getToken();
    return tokenModel?.toEntity();
  }

  @override
  Future<void> saveToken(AuthToken token) async {
    final tokenModel = AuthTokenModel.fromEntity(token);
    await localDataSource.saveToken(tokenModel);
  }

  @override
  Future<bool> checkEmailDuplicate(String email) async {
    return await remoteDataSource.checkEmailDuplicate(email);
  }

  @override
  Future<AuthResult> loginWithGoogle({required String idToken}) async {
    // TODO: Remote API 호출로 변경
    // final response = await remoteDataSource.loginWithGoogle(idToken: idToken);

    // Mock: 임시 데이터 반환
    await Future.delayed(const Duration(seconds: 1)); // API 호출 시뮬레이션

    // Mock User 생성
    final mockUserModel = UserModel(
      userId: 'google_mock_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'google.user@example.com',
      nickname: 'Google User',
      profileImageUrl: null,
    );

    // Mock Token 생성
    final mockTokenModel = AuthTokenModel(
      accessToken: 'mock_google_access_token',
      refreshToken: 'mock_google_refresh_token',
      expiresIn: '3600', // String으로 변경
    );

    // Local Storage에 저장
    await localDataSource.saveToken(mockTokenModel);
    await localDataSource.saveUser(mockUserModel);

    // AuthResult 반환
    return AuthResult(
      user: mockUserModel.toEntity(),
      token: mockTokenModel.toEntity(),
    );
  }

  @override
  Future<AuthResult> loginWithApple({required String authorizationCode}) async {
    // TODO: Remote API 호출로 변경
    // final response = await remoteDataSource.loginWithApple(
    //   authorizationCode: authorizationCode,
    // );

    // Mock: 임시 데이터 반환
    await Future.delayed(const Duration(seconds: 1)); // API 호출 시뮬레이션

    // Mock User 생성
    final mockUserModel = UserModel(
      userId: 'apple_mock_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'apple.user@example.com',
      nickname: 'Apple User',
      profileImageUrl: null,
    );

    // Mock Token 생성
    final mockTokenModel = AuthTokenModel(
      accessToken: 'mock_apple_access_token',
      refreshToken: 'mock_apple_refresh_token',
    );

    // Local Storage에 저장
    await localDataSource.saveToken(mockTokenModel);
    await localDataSource.saveUser(mockUserModel);

    // AuthResult 반환
    return AuthResult(
      user: mockUserModel.toEntity(),
      token: mockTokenModel.toEntity(),
    );
  }
}
