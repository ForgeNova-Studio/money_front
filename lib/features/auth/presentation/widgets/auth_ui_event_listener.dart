import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';
import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_ui_event_view_model.dart';

typedef LoginMethodDialogHandler = void Function(
  BuildContext context,
  LoginProviderType provider,
  String message,
);

class AuthUiEventListener extends ConsumerWidget {
  final Widget child;
  final LoginMethodDialogHandler? onLoginMethodDialog;

  const AuthUiEventListener({
    super.key,
    required this.child,
    this.onLoginMethodDialog,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authUiEventViewModelProvider, (previous, next) {
      if (next == null) return;

      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      if (!isCurrent) return;

      switch (next.type) {
        case AuthUiEventType.showErrorToast:
          context.showErrorToast(next.message);
          break;
        case AuthUiEventType.showLoginMethodDialog:
          if (onLoginMethodDialog != null) {
            onLoginMethodDialog!(context, next.provider, next.message);
          } else {
            context.showErrorToast(next.message);
          }
          break;
      }

      ref.read(authUiEventViewModelProvider.notifier).consume();
    });

    return child;
  }
}
