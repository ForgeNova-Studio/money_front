// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_scan_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// OCR 스캔 ViewModel
/// 영수증 이미지를 처리하고 대기 목록 관리

@ProviderFor(OcrScanViewModel)
const ocrScanViewModelProvider = OcrScanViewModelProvider._();

/// OCR 스캔 ViewModel
/// 영수증 이미지를 처리하고 대기 목록 관리
final class OcrScanViewModelProvider
    extends $NotifierProvider<OcrScanViewModel, OcrScanState> {
  /// OCR 스캔 ViewModel
  /// 영수증 이미지를 처리하고 대기 목록 관리
  const OcrScanViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ocrScanViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ocrScanViewModelHash();

  @$internal
  @override
  OcrScanViewModel create() => OcrScanViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrScanState>(value),
    );
  }
}

String _$ocrScanViewModelHash() => r'e19e3b9b365d5608487926472720f4e4895a1199';

/// OCR 스캔 ViewModel
/// 영수증 이미지를 처리하고 대기 목록 관리

abstract class _$OcrScanViewModel extends $Notifier<OcrScanState> {
  OcrScanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OcrScanState, OcrScanState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<OcrScanState, OcrScanState>,
        OcrScanState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
