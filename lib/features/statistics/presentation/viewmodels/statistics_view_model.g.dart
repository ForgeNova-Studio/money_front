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
    r'197bc43655442be8a521a3cbff02b91209ca00e7';

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
