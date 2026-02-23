// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_card_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 최근 사용한 카드사 관리 서비스
/// SharedPreferences에 최근 사용 카드사 ID를 저장하고 정렬된 목록을 제공

@ProviderFor(RecentCardService)
const recentCardServiceProvider = RecentCardServiceProvider._();

/// 최근 사용한 카드사 관리 서비스
/// SharedPreferences에 최근 사용 카드사 ID를 저장하고 정렬된 목록을 제공
final class RecentCardServiceProvider
    extends $NotifierProvider<RecentCardService, List<String>> {
  /// 최근 사용한 카드사 관리 서비스
  /// SharedPreferences에 최근 사용 카드사 ID를 저장하고 정렬된 목록을 제공
  const RecentCardServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recentCardServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recentCardServiceHash();

  @$internal
  @override
  RecentCardService create() => RecentCardService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentCardServiceHash() => r'727edc99728ab65e5f7ed07df6784239069950ea';

/// 최근 사용한 카드사 관리 서비스
/// SharedPreferences에 최근 사용 카드사 ID를 저장하고 정렬된 목록을 제공

abstract class _$RecentCardService extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<String>, List<String>>,
        List<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
