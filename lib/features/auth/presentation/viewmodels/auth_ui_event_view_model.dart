import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';

final authUiEventViewModelProvider =
    NotifierProvider<AuthUiEventViewModel, AuthUiEvent?>(
  AuthUiEventViewModel.new,
);

class AuthUiEventViewModel extends Notifier<AuthUiEvent?> {
  @override
  AuthUiEvent? build() {
    return null;
  }

  void emit(AuthUiEvent event) {
    state = event;
  }

  void consume() {
    state = null;
  }
}
