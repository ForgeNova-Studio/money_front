// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExportViewModel)
const exportViewModelProvider = ExportViewModelProvider._();

final class ExportViewModelProvider
    extends $NotifierProvider<ExportViewModel, ExportState> {
  const ExportViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'exportViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exportViewModelHash();

  @$internal
  @override
  ExportViewModel create() => ExportViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportState>(value),
    );
  }
}

String _$exportViewModelHash() => r'4db668e2e08fac39f0b1375f599fdaedec5602a5';

abstract class _$ExportViewModel extends $Notifier<ExportState> {
  ExportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExportState, ExportState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ExportState, ExportState>, ExportState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
