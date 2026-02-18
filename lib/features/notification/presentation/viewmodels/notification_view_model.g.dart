// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 알림 ViewModel
///
/// 사용자의 알림 목록을 조회하고 읽음 처리를 담당합니다.
///
/// ## 주요 기능
/// - 초기 알림 목록 및 읽지 않은 개수 로드
/// - 무한 스크롤을 위한 추가 데이터 로드
/// - 알림 읽음 처리 및 로컬 상태 업데이트
/// - 푸시 알림 수신 시 실시간 목록 업데이트

@ProviderFor(NotificationViewModel)
const notificationViewModelProvider = NotificationViewModelProvider._();

/// 알림 ViewModel
///
/// 사용자의 알림 목록을 조회하고 읽음 처리를 담당합니다.
///
/// ## 주요 기능
/// - 초기 알림 목록 및 읽지 않은 개수 로드
/// - 무한 스크롤을 위한 추가 데이터 로드
/// - 알림 읽음 처리 및 로컬 상태 업데이트
/// - 푸시 알림 수신 시 실시간 목록 업데이트
final class NotificationViewModelProvider
    extends $NotifierProvider<NotificationViewModel, NotificationState> {
  /// 알림 ViewModel
  ///
  /// 사용자의 알림 목록을 조회하고 읽음 처리를 담당합니다.
  ///
  /// ## 주요 기능
  /// - 초기 알림 목록 및 읽지 않은 개수 로드
  /// - 무한 스크롤을 위한 추가 데이터 로드
  /// - 알림 읽음 처리 및 로컬 상태 업데이트
  /// - 푸시 알림 수신 시 실시간 목록 업데이트
  const NotificationViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationViewModelHash();

  @$internal
  @override
  NotificationViewModel create() => NotificationViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationState>(value),
    );
  }
}

String _$notificationViewModelHash() =>
    r'd245ed295a2eb1a303902140cd5590afe9073f83';

/// 알림 ViewModel
///
/// 사용자의 알림 목록을 조회하고 읽음 처리를 담당합니다.
///
/// ## 주요 기능
/// - 초기 알림 목록 및 읽지 않은 개수 로드
/// - 무한 스크롤을 위한 추가 데이터 로드
/// - 알림 읽음 처리 및 로컬 상태 업데이트
/// - 푸시 알림 수신 시 실시간 목록 업데이트

abstract class _$NotificationViewModel extends $Notifier<NotificationState> {
  NotificationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NotificationState, NotificationState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NotificationState, NotificationState>,
        NotificationState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
