// dataSources
import 'package:moneyflow/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:moneyflow/features/auth/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:moneyflow/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:moneyflow/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';

// repository
import 'package:moneyflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

// usecases
import 'package:moneyflow/features/auth/domain/usecases/apple_login_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/login_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/register_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/send_password_reset_code_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/send_signup_code_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/verifiy_find_password_code_usecase.dart';
import 'package:moneyflow/features/auth/domain/usecases/verify_signup_code_usecase.dart';

// providers/states
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moneyflow/core/providers/core_providers.dart';

part 'auth_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================

/// Remote DataSource Provider
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

/// Local DataSource Provider
@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl(prefs: ref.read(sharedPreferencesProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================

/// Auth Repository Provider
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
}

// ============================================================================
// UseCase Providers
// ============================================================================

/// Login UseCase Provider
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
}

/// Register UseCase Provider
@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
}

/// Logout UseCase Provider
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
}

/// Get Current User UseCase Provider
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
}

/// Google Login UseCase Provider
@riverpod
GoogleLoginUseCase googleLoginUseCase(Ref ref) {
  return GoogleLoginUseCase(ref.read(authRepositoryProvider));
}

/// Apple Login UseCase Provider
@riverpod
AppleLoginUseCase appleLoginUseCase(Ref ref) {
  return AppleLoginUseCase(ref.read(authRepositoryProvider));
}

/// Send Signup Code UseCase Provider
@riverpod
SendSignupCodeUseCase sendSignupCodeUseCase(Ref ref) {
  return SendSignupCodeUseCase(ref.read(authRepositoryProvider));
}

/// Verify Signup Code UseCase Provider
@riverpod
VerifySignupCodeUseCase verifySignupCodeUseCase(Ref ref) {
  return VerifySignupCodeUseCase(ref.read(authRepositoryProvider));
}

/// Send Password Reset Code UseCase Provider
@riverpod
SendPasswordResetCodeUseCase sendPasswordResetCodeUseCase(Ref ref) {
  return SendPasswordResetCodeUseCase(ref.read(authRepositoryProvider));
}

/// Verify Password Code UseCase Provider
@riverpod
VerifiyFindPasswordCodeUsecase verifyFindPasswordCodeUseCase(Ref ref) {
  return VerifiyFindPasswordCodeUsecase(ref.read(authRepositoryProvider));
}

/// Reset Password UseCase Provider
@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  return ResetPasswordUseCase(ref.read(authRepositoryProvider));
}
