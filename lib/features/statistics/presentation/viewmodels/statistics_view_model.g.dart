// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatisticsViewModel)
const statisticsViewModelProvider = StatisticsViewModelProvider._();

final class StatisticsViewModelProvider
    extends $NotifierProvider<StatisticsViewModel, StatisticsState> {
  const StatisticsViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'statisticsViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$statisticsViewModelHash();

  @$internal
  @override
  StatisticsViewModel create() => StatisticsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsState>(value),
    );
  }
}

String _$statisticsViewModelHash() =>
    r'124d73f56b0e77f7de5a4f1d3d2651e84220431c';

abstract class _$StatisticsViewModel extends $Notifier<StatisticsState> {
  StatisticsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StatisticsState, StatisticsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<StatisticsState, StatisticsState>,
        StatisticsState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
