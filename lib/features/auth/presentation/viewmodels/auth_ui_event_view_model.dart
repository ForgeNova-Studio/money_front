import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';

final authUiEventViewModelProvider =
    NotifierProvider<AuthUiEventViewModel, List<AuthUiEvent>>(
  AuthUiEventViewModel.new,
);

class AuthUiEventViewModel extends Notifier<List<AuthUiEvent>> {
  static const int _maxQueueLength = 20;

  @override
  List<AuthUiEvent> build() {
    return const [];
  }

  void emit(AuthUiEvent event) {
    final next = [...state, event];
    if (next.length <= _maxQueueLength) {
      state = next;
      return;
    }
    state = next.sublist(next.length - _maxQueueLength);
  }

  void consume() {
    if (state.isEmpty) return;
    state = state.sublist(1);
  }
}
