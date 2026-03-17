// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_policy_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 약관 및 정책 ViewModel

@ProviderFor(TermsPolicyViewModel)
const termsPolicyViewModelProvider = TermsPolicyViewModelProvider._();

/// 약관 및 정책 ViewModel
final class TermsPolicyViewModelProvider
    extends $NotifierProvider<TermsPolicyViewModel, TermsPolicyState> {
  /// 약관 및 정책 ViewModel
  const TermsPolicyViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'termsPolicyViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$termsPolicyViewModelHash();

  @$internal
  @override
  TermsPolicyViewModel create() => TermsPolicyViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TermsPolicyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TermsPolicyState>(value),
    );
  }
}

String _$termsPolicyViewModelHash() =>
    r'c6e7331eb983d474b17ac7e851807dfa0cbb6df8';

/// 약관 및 정책 ViewModel

abstract class _$TermsPolicyViewModel extends $Notifier<TermsPolicyState> {
  TermsPolicyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TermsPolicyState, TermsPolicyState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TermsPolicyState, TermsPolicyState>,
        TermsPolicyState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
