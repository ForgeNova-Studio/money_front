// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_password_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 비밀번호 찾기 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리

@ProviderFor(FindPasswordViewModel)
const findPasswordViewModelProvider = FindPasswordViewModelProvider._();

/// 비밀번호 찾기 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리
final class FindPasswordViewModelProvider
    extends $NotifierProvider<FindPasswordViewModel, FindPasswordFormState> {
  /// 비밀번호 찾기 폼 ViewModel
  ///
  /// 폼 상태 관리 및 이메일 인증 로직 처리
  const FindPasswordViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'findPasswordViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$findPasswordViewModelHash();

  @$internal
  @override
  FindPasswordViewModel create() => FindPasswordViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FindPasswordFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FindPasswordFormState>(value),
    );
  }
}

String _$findPasswordViewModelHash() =>
    r'bc10329a2f2f17b538c8bf9c0c6650158f13fc6f';

/// 비밀번호 찾기 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리

abstract class _$FindPasswordViewModel
    extends $Notifier<FindPasswordFormState> {
  FindPasswordFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FindPasswordFormState, FindPasswordFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FindPasswordFormState, FindPasswordFormState>,
        FindPasswordFormState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
