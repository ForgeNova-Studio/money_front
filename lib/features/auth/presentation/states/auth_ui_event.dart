import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';

enum AuthUiEventType {
  showErrorToast,
  showLoginMethodDialog,
}

class AuthUiEvent {
  final AuthUiEventType type;
  final String message;
  final LoginProviderType provider;

  const AuthUiEvent._({
    required this.type,
    required this.message,
    this.provider = LoginProviderType.unknown,
  });

  const AuthUiEvent.showErrorToast(String message)
      : this._(
          type: AuthUiEventType.showErrorToast,
          message: message,
        );

  const AuthUiEvent.showLoginMethodDialog({
    required String message,
    required LoginProviderType provider,
  }) : this._(
          type: AuthUiEventType.showLoginMethodDialog,
          message: message,
          provider: provider,
        );
}
