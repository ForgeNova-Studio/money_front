import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';
import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_ui_event_view_model.dart';

/// 다이얼로그 표시를 화면별로 커스터마이즈할 수 있게 콜백 시그니처를 정의
typedef LoginMethodDialogHandler = void Function(
  BuildContext context,
  LoginProviderType provider,
  String message,
);

/// auth 화면 공통으로 나타내는 UI 이벤트를 처리하는 위젯
/// viewModel이 발생한 이벤트 큐를 소비(consume)하는 전용 레이어
class AuthUiEventListener extends ConsumerWidget {
  final Widget child;
  final LoginMethodDialogHandler? onLoginMethodDialog;

  const AuthUiEventListener({
    super.key,
    required this.child,
    this.onLoginMethodDialog,
  });

  /// 이벤트 타입에 따라 적절한 Toast를 표시
  /// showErrorToast
  /// - ScaffoldMessenger
  /// 
  /// onLoginMethodDialog
  /// - 다이얼로그 표시
  /// 
  /// - Auth 화면에서 성공은 대개 라우팅으로 대체되기 때문에 에러만 처리
  /// - 성공 토스트 예시
  ///   - 회원가입 성공 -> 로그인 화면으로 이동
  ///   case AuthUiEventType.showSuccessToast:
  ///     context.showSuccessToast(event.message);
  ///     break;
  ///   - 비밀번호 재설정 성공 -> 로그인 화면으로 이동
  ///   case AuthUiEventType.showSuccessToast:
  ///     context.showSuccessToast(event.message);
  ///     break;  
  void _handleEvent(BuildContext context, AuthUiEvent event) {
    switch (event.type) {
      case AuthUiEventType.showErrorToast:
        context.showErrorToast(event.message);
        break;
      case AuthUiEventType.showLoginMethodDialog:
        if (onLoginMethodDialog != null) {
          onLoginMethodDialog!(context, event.provider, event.message);
        } else {
          context.showErrorToast(event.message);
        }
        break;
    }
  }

  /// 
  void _consumeCurrentRouteEvent(BuildContext context, WidgetRef ref) {
    final queue = ref.read(authUiEventViewModelProvider);
    if (queue.isEmpty) return;

    final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
    if (!isCurrent) return;

    _handleEvent(context, queue.first);
    ref.read(authUiEventViewModelProvider.notifier).consume();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(authUiEventViewModelProvider);
    if (queue.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        _consumeCurrentRouteEvent(context, ref);
      });
    }

    return child;
  }
}
