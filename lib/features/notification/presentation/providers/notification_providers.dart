import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/common/providers/dio_provider.dart';
import 'package:moamoa/features/notification/data/datasources/remote/notification_remote_datasource.dart';
import 'package:moamoa/features/notification/data/repositories/notification_repository_impl.dart';

/// Notification DataSource Provider
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSourceImpl(dio: ref.read(dioProvider));
});

/// Notification Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource);
});
