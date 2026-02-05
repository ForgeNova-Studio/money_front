// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_banner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 월간 리포트 배너 숨김 여부 Provider

@ProviderFor(ReportBannerDismissed)
const reportBannerDismissedProvider = ReportBannerDismissedProvider._();

/// 월간 리포트 배너 숨김 여부 Provider
final class ReportBannerDismissedProvider
    extends $NotifierProvider<ReportBannerDismissed, bool> {
  /// 월간 리포트 배너 숨김 여부 Provider
  const ReportBannerDismissedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reportBannerDismissedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reportBannerDismissedHash();

  @$internal
  @override
  ReportBannerDismissed create() => ReportBannerDismissed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reportBannerDismissedHash() =>
    r'aaa01e7dce58d3bc2eae283d04aced764324628d';

/// 월간 리포트 배너 숨김 여부 Provider

abstract class _$ReportBannerDismissed extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
