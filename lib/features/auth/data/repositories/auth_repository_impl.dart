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
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

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
    required Gender gender,
  }) async {
    // 1. Remote API 호출 (토큰만 받음)
    final response = await remoteDataSource.register(
      email: email,
      password: password,
      nickname: nickname,
      gender: gender,
    );

    // 2. Local Storage에 저장
    final tokenModel = AuthTokenModel(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn,
    );

    // 회원가입 시 입력한 정보로 UserModel 생성
    final userModel = UserModel(
      userId: response.userId,
      email: email,
      nickname: nickname,
      profileImageUrl: null, // 회원가입 시 프로필 이미지 없음
      gender: gender,
    );

    await localDataSource.saveToken(tokenModel);
    await localDataSource.saveUser(userModel);

    // 3. Entity 변환 및 반환 (email, nickname, gender 전달)
    return response.toEntity(
      email: email,
      nickname: nickname,
      gender: gender,
    );
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
  Future<void> sendSignupCode(String email) async {
    await remoteDataSource.sendSignupCode(email);
  }

  @override
  Future<bool> verifySignupCode(String email, String code) async {
    return await remoteDataSource.verifySignupCode(email, code);
  }

  @override
  Future<AuthResult> loginWithGoogle({
    required String idToken,
    String? nickname,
  }) async {
    return await _socialLogin(
      provider: 'GOOGLE',
      idToken: idToken,
      nickname: nickname ?? 'Google 사용자',
    );
  }

  @override
  Future<AuthResult> loginWithApple({
    required String authorizationCode,
    String? nickname,
  }) async {
    return await _socialLogin(
      provider: 'APPLE',
      idToken: authorizationCode, // Apple은 authorizationCode를 idToken으로 사용
      nickname: nickname ?? 'Apple 사용자',
    );
  }

  /// 소셜 로그인 공통 처리 (내부 헬퍼 메서드)
  Future<AuthResult> _socialLogin({
    required String provider,
    required String idToken,
    required String nickname,
  }) async {
    // 1. Remote API 호출 (통합 엔드포인트)
    final response = await remoteDataSource.socialLogin(
      provider: provider,
      idToken: idToken,
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
}
