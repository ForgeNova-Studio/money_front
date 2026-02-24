import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'login_view_model.g.dart';

class LoginViewModel {
  final Ref _ref;

  LoginViewModel(this._ref);

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _ref.read(authViewModelProvider.notifier).login(
          email: email.trim(),
          password: password,
        );
  }

  Future<void> loginWithGoogle() async {
    await _ref.read(authViewModelProvider.notifier).loginWithGoogle();
  }

  Future<void> loginWithNaver() async {
    await _ref.read(authViewModelProvider.notifier).loginWithNaver();
  }

  Future<void> loginWithKakao() async {
    await _ref.read(authViewModelProvider.notifier).loginWithKakao();
  }

  Future<void> loginWithProvider(LoginProviderType provider) async {
    await _ref.read(authViewModelProvider.notifier).loginWithProvider(provider);
  }

  LoginErrorAction resolveLoginErrorAction(String message) {
    return _ref
        .read(authViewModelProvider.notifier)
        .resolveLoginErrorAction(message);
  }

  void clearAuthError() {
    _ref.read(authViewModelProvider.notifier).clearError();
  }
}

@riverpod
LoginViewModel loginViewModel(Ref ref) {
  return LoginViewModel(ref);
}
