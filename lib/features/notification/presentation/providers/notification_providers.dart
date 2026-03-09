import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/common/providers/dio_provider.dart';
import 'package:moamoa/features/notification/data/datasources/remote/notification_remote_datasource.dart';
import 'package:moamoa/features/notification/data/repositories/notification_repository_impl.dart';

/// Notification Remote DataSource Provider
///
/// [NotificationRemoteDataSource]의 인스턴스를 제공합니다.
/// Dio 클라이언트를 의존성으로 주입받습니다.
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSourceImpl(dio: ref.read(dioProvider));
});

/// Notification Repository Provider
///
/// [NotificationRepository]의 인스턴스를 제공합니다.
/// Remote DataSource를 의존성으로 주입받습니다.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource);
});
