// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 관리자 알림 ViewModel
///
/// 관리자 페이지에서 알림을 생성하고 발송하는 기능을 담당합니다.
///
/// ## 주요 기능
/// - 알림 제목, 내용, 대상 이메일 유효성 검사
/// - 알림 유형 선택 및 UI 상태 관리
/// - 전체 발송 및 개별 발송 처리

@ProviderFor(AdminNotificationViewModel)
const adminNotificationViewModelProvider =
    AdminNotificationViewModelProvider._();

/// 관리자 알림 ViewModel
///
/// 관리자 페이지에서 알림을 생성하고 발송하는 기능을 담당합니다.
///
/// ## 주요 기능
/// - 알림 제목, 내용, 대상 이메일 유효성 검사
/// - 알림 유형 선택 및 UI 상태 관리
/// - 전체 발송 및 개별 발송 처리
final class AdminNotificationViewModelProvider extends $NotifierProvider<
    AdminNotificationViewModel, AdminNotificationUiState> {
  /// 관리자 알림 ViewModel
  ///
  /// 관리자 페이지에서 알림을 생성하고 발송하는 기능을 담당합니다.
  ///
  /// ## 주요 기능
  /// - 알림 제목, 내용, 대상 이메일 유효성 검사
  /// - 알림 유형 선택 및 UI 상태 관리
  /// - 전체 발송 및 개별 발송 처리
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

/// 관리자 알림 ViewModel
///
/// 관리자 페이지에서 알림을 생성하고 발송하는 기능을 담당합니다.
///
/// ## 주요 기능
/// - 알림 제목, 내용, 대상 이메일 유효성 검사
/// - 알림 유형 선택 및 UI 상태 관리
/// - 전체 발송 및 개별 발송 처리

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
