import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';

part 'auth_ui_event_view_model.g.dart';

@riverpod
class AuthUiEventViewModel extends _$AuthUiEventViewModel {
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
