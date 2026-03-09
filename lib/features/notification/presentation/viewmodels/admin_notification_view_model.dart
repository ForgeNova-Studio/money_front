import 'package:moamoa/features/notification/presentation/models/admin_notification_type.dart';
import 'package:moamoa/features/notification/presentation/providers/notification_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_notification_view_model.g.dart';

/// 관리자 알림 화면 UI 상태
///
/// 알림 발송 화면의 UI 상태를 관리합니다.
///
/// ## 주요 상태
/// - [selectedType]: 선택된 알림 유형 (공지, 업데이트, 이벤트 등)
/// - [isSubmitting]: 발송 중 여부 (로딩 표시용)
/// - [isFabExpanded]: FAB 확장 여부 (메뉴 표시용)
class AdminNotificationUiState {
  final AdminNotificationType selectedType;
  final bool isSubmitting;
  final bool isFabExpanded;

  const AdminNotificationUiState({
    this.selectedType = AdminNotificationType.notice,
    this.isSubmitting = false,
    this.isFabExpanded = false,
  });

  AdminNotificationUiState copyWith({
    AdminNotificationType? selectedType,
    bool? isSubmitting,
    bool? isFabExpanded,
  }) {
    return AdminNotificationUiState(
      selectedType: selectedType ?? this.selectedType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFabExpanded: isFabExpanded ?? this.isFabExpanded,
    );
  }
}

/// 알림 발송 결과
///
/// 알림 발송 작업의 성공 여부와 메시지를 담습니다.
class AdminNotificationSubmitResult {
  final bool isSuccess;
  final String message;

  const AdminNotificationSubmitResult({
    required this.isSuccess,
    required this.message,
  });
}

/// 관리자 알림 ViewModel
///
/// 관리자 페이지에서 알림을 생성하고 발송하는 기능을 담당합니다.
///
/// ## 주요 기능
/// - 알림 제목, 내용, 대상 이메일 유효성 검사
/// - 알림 유형 선택 및 UI 상태 관리
/// - 전체 발송 및 개별 발송 처리
@riverpod
class AdminNotificationViewModel extends _$AdminNotificationViewModel {
  static const int titleMaxLength = 100;
  static const int messageMaxLength = 1000;
  static final RegExp _emailPattern =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  @override
  AdminNotificationUiState build() {
    return const AdminNotificationUiState();
  }

  String? validateTitle(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '제목을 입력해주세요';
    if (text.length > titleMaxLength) {
      return '제목은 $titleMaxLength자 이하로 입력해주세요';
    }
    return null;
  }

  String? validateMessage(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '내용을 입력해주세요';
    if (text.length > messageMaxLength) {
      return '내용은 $messageMaxLength자 이하로 입력해주세요';
    }
    return null;
  }

  String? validateTargetEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return '이메일을 입력해주세요';
    if (!_emailPattern.hasMatch(email)) return '올바른 이메일 형식을 입력해주세요';
    return null;
  }

  void selectType(AdminNotificationType type) {
    state = state.copyWith(selectedType: type);
  }

  void toggleFab() {
    if (state.isSubmitting) return;
    state = state.copyWith(isFabExpanded: !state.isFabExpanded);
  }

  void collapseFab() {
    if (!state.isFabExpanded) return;
    state = state.copyWith(isFabExpanded: false);
  }

  Future<AdminNotificationSubmitResult> submit({
    required String title,
    required String message,
    String? targetEmail,
  }) async {
    final titleError = validateTitle(title);
    if (titleError != null) {
      return AdminNotificationSubmitResult(
        isSuccess: false,
        message: titleError,
      );
    }

    final messageError = validateMessage(message);
    if (messageError != null) {
      return AdminNotificationSubmitResult(
        isSuccess: false,
        message: messageError,
      );
    }

    final email = targetEmail?.trim();
    if (email != null) {
      final emailError = validateTargetEmail(email);
      if (emailError != null) {
        return AdminNotificationSubmitResult(
          isSuccess: false,
          message: emailError,
        );
      }
    }

    state = state.copyWith(
      isSubmitting: true,
      isFabExpanded: false,
    );

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final trimmedTitle = title.trim();
      final trimmedMessage = message.trim();
      final type = state.selectedType.apiValue;

      if (email == null) {
        await repository.sendNotificationToAll(
          title: trimmedTitle,
          message: trimmedMessage,
          type: type,
        );
      } else {
        await repository.createNotification(
          targetEmail: email,
          title: trimmedTitle,
          message: trimmedMessage,
          type: type,
        );
      }

      final successMessage =
          email == null ? '전체 사용자에게 공지가 전송되었습니다' : '$email 님에게 알림이 전송되었습니다';
      return AdminNotificationSubmitResult(
        isSuccess: true,
        message: successMessage,
      );
    } catch (error) {
      return AdminNotificationSubmitResult(
        isSuccess: false,
        message: _mapSubmitErrorMessage(error),
      );
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  String _mapSubmitErrorMessage(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('401') || message.contains('403')) {
      return '전송 권한이 없습니다';
    }
    if (message.contains('400')) {
      return '입력값을 확인해주세요';
    }
    if (message.contains('timeout') || message.contains('socket')) {
      return '네트워크 상태를 확인한 후 다시 시도해주세요';
    }
    return '전송에 실패했습니다. 잠시 후 다시 시도해주세요';
  }
}
