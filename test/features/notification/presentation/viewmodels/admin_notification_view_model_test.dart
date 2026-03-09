import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:moamoa/features/notification/domain/entities/notification_entity.dart';
import 'package:moamoa/features/notification/presentation/models/admin_notification_type.dart';
import 'package:moamoa/features/notification/presentation/providers/notification_providers.dart';
import 'package:moamoa/features/notification/presentation/viewmodels/admin_notification_view_model.dart';

void main() {
  group('AdminNotificationViewModel', () {
    test('제목/내용/이메일 유효성 검사를 수행한다', () {
      final fakeRepository = FakeNotificationRepository();
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);

      expect(notifier.validateTitle(''), '제목을 입력해주세요');
      expect(
        notifier.validateTitle('a' * 101),
        '제목은 100자 이하로 입력해주세요',
      );
      expect(notifier.validateTitle('정상 제목'), isNull);

      expect(notifier.validateMessage(''), '내용을 입력해주세요');
      expect(
        notifier.validateMessage('a' * 1001),
        '내용은 1000자 이하로 입력해주세요',
      );
      expect(notifier.validateMessage('정상 내용'), isNull);

      expect(notifier.validateTargetEmail(''), '이메일을 입력해주세요');
      expect(
        notifier.validateTargetEmail('invalid-email'),
        '올바른 이메일 형식을 입력해주세요',
      );
      expect(notifier.validateTargetEmail('test@example.com'), isNull);
    });

    test('알림 타입 선택과 FAB 상태를 업데이트한다', () {
      final fakeRepository = FakeNotificationRepository();
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);

      notifier.selectType(AdminNotificationType.event);
      expect(
        container.read(adminNotificationViewModelProvider).selectedType,
        AdminNotificationType.event,
      );

      notifier.toggleFab();
      expect(container.read(adminNotificationViewModelProvider).isFabExpanded,
          true);

      notifier.collapseFab();
      expect(container.read(adminNotificationViewModelProvider).isFabExpanded,
          false);
    });

    test('전체 발송 성공 시 repository.sendNotificationToAll을 호출한다', () async {
      final fakeRepository = FakeNotificationRepository();
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);
      notifier.selectType(AdminNotificationType.update);

      final result = await notifier.submit(
        title: '  업데이트 공지  ',
        message: '  기능이 개선되었습니다  ',
      );

      expect(result.isSuccess, true);
      expect(result.message, '전체 사용자에게 공지가 전송되었습니다');
      expect(fakeRepository.sendToAllCallCount, 1);
      expect(fakeRepository.lastSendToAllTitle, '업데이트 공지');
      expect(fakeRepository.lastSendToAllMessage, '기능이 개선되었습니다');
      expect(fakeRepository.lastSendToAllType, 'UPDATE');
    });

    test('특정 사용자 발송 성공 시 repository.createNotification을 호출한다', () async {
      final fakeRepository = FakeNotificationRepository();
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);
      notifier.selectType(AdminNotificationType.personal);

      final result = await notifier.submit(
        title: '  개인 알림  ',
        message: '  확인 부탁드립니다  ',
        targetEmail: '  target@example.com  ',
      );

      expect(result.isSuccess, true);
      expect(result.message, 'target@example.com 님에게 알림이 전송되었습니다');
      expect(fakeRepository.createCallCount, 1);
      expect(fakeRepository.lastCreateEmail, 'target@example.com');
      expect(fakeRepository.lastCreateTitle, '개인 알림');
      expect(fakeRepository.lastCreateMessage, '확인 부탁드립니다');
      expect(fakeRepository.lastCreateType, 'PERSONAL');
    });

    test('제목이 비어 있으면 실패하고 repository를 호출하지 않는다', () async {
      final fakeRepository = FakeNotificationRepository();
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);
      final result = await notifier.submit(title: '   ', message: '내용');

      expect(result.isSuccess, false);
      expect(result.message, '제목을 입력해주세요');
      expect(fakeRepository.sendToAllCallCount, 0);
      expect(fakeRepository.createCallCount, 0);
    });

    test('403 에러 발생 시 권한 오류 메시지를 반환한다', () async {
      final fakeRepository = FakeNotificationRepository()
        ..sendToAllError = Exception('403 forbidden');
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);
      final result = await notifier.submit(title: '제목', message: '내용');

      expect(result.isSuccess, false);
      expect(result.message, '전송 권한이 없습니다');
      expect(container.read(adminNotificationViewModelProvider).isSubmitting,
          false);
    });

    test('발송 중에는 toggleFab이 무시되고 완료 후 isSubmitting이 false가 된다', () async {
      final completer = Completer<void>();
      final fakeRepository = FakeNotificationRepository()
        ..sendToAllCompleter = completer;
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(adminNotificationViewModelProvider.notifier);

      final submittingFuture = notifier.submit(title: '제목', message: '내용');
      expect(container.read(adminNotificationViewModelProvider).isSubmitting,
          true);

      notifier.toggleFab();
      expect(container.read(adminNotificationViewModelProvider).isFabExpanded,
          false);

      completer.complete();
      await submittingFuture;

      expect(container.read(adminNotificationViewModelProvider).isSubmitting,
          false);
    });
  });
}

ProviderContainer _createContainer(FakeNotificationRepository repository) {
  final container = ProviderContainer(
    overrides: [
      notificationRepositoryProvider.overrideWithValue(repository),
    ],
  );

  // autoDispose provider가 테스트 중 해제되지 않도록 구독 유지
  final subscription = container.listen(
    adminNotificationViewModelProvider,
    (_, __) {},
  );
  addTearDown(subscription.close);

  return container;
}

class FakeNotificationRepository implements NotificationRepository {
  int sendToAllCallCount = 0;
  int createCallCount = 0;

  String? lastSendToAllTitle;
  String? lastSendToAllMessage;
  String? lastSendToAllType;

  String? lastCreateEmail;
  String? lastCreateTitle;
  String? lastCreateMessage;
  String? lastCreateType;

  Object? sendToAllError;
  Object? createError;
  Completer<void>? sendToAllCompleter;

  @override
  Future<NotificationEntity> createNotification({
    required String targetEmail,
    required String title,
    required String message,
    String type = 'PERSONAL',
  }) async {
    createCallCount += 1;
    lastCreateEmail = targetEmail;
    lastCreateTitle = title;
    lastCreateMessage = message;
    lastCreateType = type;

    if (createError != null) {
      throw createError!;
    }

    return NotificationEntity(
      id: 'created-id',
      title: title,
      message: message,
      type: type,
      isRead: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 0,
    int size = 20,
    int? days,
  }) async {
    return const [];
  }

  @override
  Future<int> getUnreadCount() async {
    return 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {}

  @override
  Future<void> sendNotificationToAll({
    required String title,
    required String message,
    String type = 'NOTICE',
  }) async {
    sendToAllCallCount += 1;
    lastSendToAllTitle = title;
    lastSendToAllMessage = message;
    lastSendToAllType = type;

    if (sendToAllError != null) {
      throw sendToAllError!;
    }

    if (sendToAllCompleter != null) {
      await sendToAllCompleter!.future;
    }
  }
}
