// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationViewModel)
const notificationViewModelProvider = NotificationViewModelProvider._();

final class NotificationViewModelProvider
    extends $NotifierProvider<NotificationViewModel, NotificationState> {
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
    r'd8edb5323b05137b7ff12d97627aaf9b3746f14e';

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
