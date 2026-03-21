import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'login_view_model.g.dart';

/// 로그인 화면 전용 액션 레이어로
/// AuthViewModel의 메서드를 호출하여 로그인 관련 액션을 처리
/// - LoginViewModel은 email.trim() 과 같은 입력 정리와 같은 화면 전용
///   오케스트레이션만 담당 하기에 자체 상태를 갖지 않기 때문에 Notifier로 말들 필요 없음
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
}

@riverpod
LoginViewModel loginViewModel(Ref ref) {
  return LoginViewModel(ref);
}
