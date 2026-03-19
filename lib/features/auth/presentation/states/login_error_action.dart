enum LoginProviderType {
  email,
  naver,
  google,
  kakao,
  unknown,
}

enum LoginErrorActionType {
  showToast,
  showLoginMethodDialog,
}

class LoginErrorAction {
  final LoginErrorActionType type;
  final String message;
  final LoginProviderType provider;

  const LoginErrorAction._({
    required this.type,
    required this.message,
    this.provider = LoginProviderType.unknown,
  });

  const LoginErrorAction.showToast(String message)
      : this._(
          type: LoginErrorActionType.showToast,
          message: message,
        );

  const LoginErrorAction.showLoginMethodDialog({
    required String message,
    required LoginProviderType provider,
  }) : this._(
          type: LoginErrorActionType.showLoginMethodDialog,
          message: message,
          provider: provider,
        );

  bool get shouldShowDialog =>
      type == LoginErrorActionType.showLoginMethodDialog;
}
