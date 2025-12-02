// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Remote DataSource Provider

@ProviderFor(authRemoteDataSource)
const authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Remote DataSource Provider

final class AuthRemoteDataSourceProvider extends $FunctionalProvider<
    AuthRemoteDataSource,
    AuthRemoteDataSource,
    AuthRemoteDataSource> with $Provider<AuthRemoteDataSource> {
  /// Remote DataSource Provider
  const AuthRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'633d1e5b64040a0ff20ada1e5407890c30191a24';

/// Local DataSource Provider

@ProviderFor(authLocalDataSource)
const authLocalDataSourceProvider = AuthLocalDataSourceProvider._();

/// Local DataSource Provider

final class AuthLocalDataSourceProvider extends $FunctionalProvider<
    AuthLocalDataSource,
    AuthLocalDataSource,
    AuthLocalDataSource> with $Provider<AuthLocalDataSource> {
  /// Local DataSource Provider
  const AuthLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authLocalDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthLocalDataSource create(Ref ref) {
    return authLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocalDataSource>(value),
    );
  }
}

String _$authLocalDataSourceHash() =>
    r'f3688c0da137ea64d583d81bf6a2516ee735fb50';

/// Auth Repository Provider

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

/// Auth Repository Provider

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Auth Repository Provider
  const AuthRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'2bde6ac0125502ab64bbb3805980c2bcb0ddeb32';

/// Login UseCase Provider

@ProviderFor(loginUseCase)
const loginUseCaseProvider = LoginUseCaseProvider._();

/// Login UseCase Provider

final class LoginUseCaseProvider
    extends $FunctionalProvider<LoginUseCase, LoginUseCase, LoginUseCase>
    with $Provider<LoginUseCase> {
  /// Login UseCase Provider
  const LoginUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoginUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginUseCase create(Ref ref) {
    return loginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUseCase>(value),
    );
  }
}

String _$loginUseCaseHash() => r'94e563f1b0c6e6708b9305439524ede191d5689d';

/// Register UseCase Provider

@ProviderFor(registerUseCase)
const registerUseCaseProvider = RegisterUseCaseProvider._();

/// Register UseCase Provider

final class RegisterUseCaseProvider extends $FunctionalProvider<RegisterUseCase,
    RegisterUseCase, RegisterUseCase> with $Provider<RegisterUseCase> {
  /// Register UseCase Provider
  const RegisterUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegisterUseCase create(Ref ref) {
    return registerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterUseCase>(value),
    );
  }
}

String _$registerUseCaseHash() => r'0a28f234e74ddd0b97d12dc075fc3b18e16729c2';

/// Logout UseCase Provider

@ProviderFor(logoutUseCase)
const logoutUseCaseProvider = LogoutUseCaseProvider._();

/// Logout UseCase Provider

final class LogoutUseCaseProvider
    extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase>
    with $Provider<LogoutUseCase> {
  /// Logout UseCase Provider
  const LogoutUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logoutUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'bee26a2d877b87bf256e3c7673c413b59c66c100';

/// Get Current User UseCase Provider

@ProviderFor(getCurrentUserUseCase)
const getCurrentUserUseCaseProvider = GetCurrentUserUseCaseProvider._();

/// Get Current User UseCase Provider

final class GetCurrentUserUseCaseProvider extends $FunctionalProvider<
    GetCurrentUserUseCase,
    GetCurrentUserUseCase,
    GetCurrentUserUseCase> with $Provider<GetCurrentUserUseCase> {
  /// Get Current User UseCase Provider
  const GetCurrentUserUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getCurrentUserUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getCurrentUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentUserUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCurrentUserUseCase create(Ref ref) {
    return getCurrentUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentUserUseCase>(value),
    );
  }
}

String _$getCurrentUserUseCaseHash() =>
    r'667fda7b5ed39acf7727e08c35274ea553056d76';

/// Google Login UseCase Provider

@ProviderFor(googleLoginUseCase)
const googleLoginUseCaseProvider = GoogleLoginUseCaseProvider._();

/// Google Login UseCase Provider

final class GoogleLoginUseCaseProvider extends $FunctionalProvider<
    GoogleLoginUseCase,
    GoogleLoginUseCase,
    GoogleLoginUseCase> with $Provider<GoogleLoginUseCase> {
  /// Google Login UseCase Provider
  const GoogleLoginUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleLoginUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$googleLoginUseCaseHash();

  @$internal
  @override
  $ProviderElement<GoogleLoginUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleLoginUseCase create(Ref ref) {
    return googleLoginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleLoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleLoginUseCase>(value),
    );
  }
}

String _$googleLoginUseCaseHash() =>
    r'bde24a8375b92dcc544a44057bc376f21c5af48f';

/// Apple Login UseCase Provider

@ProviderFor(appleLoginUseCase)
const appleLoginUseCaseProvider = AppleLoginUseCaseProvider._();

/// Apple Login UseCase Provider

final class AppleLoginUseCaseProvider extends $FunctionalProvider<
    AppleLoginUseCase,
    AppleLoginUseCase,
    AppleLoginUseCase> with $Provider<AppleLoginUseCase> {
  /// Apple Login UseCase Provider
  const AppleLoginUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appleLoginUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appleLoginUseCaseHash();

  @$internal
  @override
  $ProviderElement<AppleLoginUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppleLoginUseCase create(Ref ref) {
    return appleLoginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppleLoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppleLoginUseCase>(value),
    );
  }
}

String _$appleLoginUseCaseHash() => r'931c3d354d781303dc43732114d9907121f37706';

/// Send Signup Code UseCase Provider

@ProviderFor(sendSignupCodeUseCase)
const sendSignupCodeUseCaseProvider = SendSignupCodeUseCaseProvider._();

/// Send Signup Code UseCase Provider

final class SendSignupCodeUseCaseProvider extends $FunctionalProvider<
    SendSignupCodeUseCase,
    SendSignupCodeUseCase,
    SendSignupCodeUseCase> with $Provider<SendSignupCodeUseCase> {
  /// Send Signup Code UseCase Provider
  const SendSignupCodeUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sendSignupCodeUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sendSignupCodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<SendSignupCodeUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SendSignupCodeUseCase create(Ref ref) {
    return sendSignupCodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendSignupCodeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendSignupCodeUseCase>(value),
    );
  }
}

String _$sendSignupCodeUseCaseHash() =>
    r'dcb320652d2e9524b8d2d1cef3640292a2a5ad97';

/// Verify Signup Code UseCase Provider

@ProviderFor(verifySignupCodeUseCase)
const verifySignupCodeUseCaseProvider = VerifySignupCodeUseCaseProvider._();

/// Verify Signup Code UseCase Provider

final class VerifySignupCodeUseCaseProvider extends $FunctionalProvider<
    VerifySignupCodeUseCase,
    VerifySignupCodeUseCase,
    VerifySignupCodeUseCase> with $Provider<VerifySignupCodeUseCase> {
  /// Verify Signup Code UseCase Provider
  const VerifySignupCodeUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'verifySignupCodeUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$verifySignupCodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<VerifySignupCodeUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerifySignupCodeUseCase create(Ref ref) {
    return verifySignupCodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerifySignupCodeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerifySignupCodeUseCase>(value),
    );
  }
}

String _$verifySignupCodeUseCaseHash() =>
    r'8cb915e5c1ff8584b1dd31744c0051ebc2eab1ee';
