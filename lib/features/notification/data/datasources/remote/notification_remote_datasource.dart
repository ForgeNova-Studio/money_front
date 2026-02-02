import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/notification/data/models/notification_model.dart';

/// 알림 Remote DataSource
abstract class NotificationRemoteDataSource {
  /// 알림 목록 조회
  Future<List<NotificationModel>> getNotifications({
    int page = 0,
    int size = 20,
  });

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId);

  /// 읽지 않은 알림 개수 조회
  Future<int> getUnreadCount();

  /// 알림 발송 (관리자용)
  Future<NotificationModel> createNotification(
      NotificationRequestModel request);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.notifications,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      // Spring Page 응답에서 content 추출
      final content = response.data['content'] as List<dynamic>? ?? [];
      return content
          .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[NotificationRemoteDataSource] getNotifications error: $e');
        debugPrint('[NotificationRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await dio.patch(
        ApiConstants.notificationMarkAsRead(notificationId),
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[NotificationRemoteDataSource] markAsRead error: $e');
        debugPrint('[NotificationRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get(
        ApiConstants.notificationsUnreadCount,
      );
      return response.data['count'] as int? ?? 0;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[NotificationRemoteDataSource] getUnreadCount error: $e');
        debugPrint('[NotificationRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<NotificationModel> createNotification(
      NotificationRequestModel request) async {
    try {
      final response = await dio.post(
        ApiConstants.notifications,
        data: request.toJson(),
      );
      return NotificationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
            '[NotificationRemoteDataSource] createNotification error: $e');
        debugPrint('[NotificationRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
}
