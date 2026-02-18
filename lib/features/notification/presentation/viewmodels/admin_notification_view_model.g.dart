// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminNotificationViewModel)
const adminNotificationViewModelProvider =
    AdminNotificationViewModelProvider._();

final class AdminNotificationViewModelProvider extends $NotifierProvider<
    AdminNotificationViewModel, AdminNotificationUiState> {
  const AdminNotificationViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adminNotificationViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminNotificationViewModelHash();

  @$internal
  @override
  AdminNotificationViewModel create() => AdminNotificationViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminNotificationUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminNotificationUiState>(value),
    );
  }
}

String _$adminNotificationViewModelHash() =>
    r'f51f8af5c1915f5ad721d33abdc118c8e2c18fd6';

abstract class _$AdminNotificationViewModel
    extends $Notifier<AdminNotificationUiState> {
  AdminNotificationUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AdminNotificationUiState, AdminNotificationUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AdminNotificationUiState, AdminNotificationUiState>,
        AdminNotificationUiState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
