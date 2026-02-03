// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_import_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SmsImportViewModel)
const smsImportViewModelProvider = SmsImportViewModelProvider._();

final class SmsImportViewModelProvider
    extends $NotifierProvider<SmsImportViewModel, SmsImportState> {
  const SmsImportViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'smsImportViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$smsImportViewModelHash();

  @$internal
  @override
  SmsImportViewModel create() => SmsImportViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmsImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SmsImportState>(value),
    );
  }
}

String _$smsImportViewModelHash() =>
    r'1f233382a855a09f640ad702c6aa335585ea20a7';

abstract class _$SmsImportViewModel extends $Notifier<SmsImportState> {
  SmsImportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SmsImportState, SmsImportState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SmsImportState, SmsImportState>,
        SmsImportState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
