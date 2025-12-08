// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 회원가입 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리

@ProviderFor(RegisterViewModel)
const registerViewModelProvider = RegisterViewModelProvider._();

/// 회원가입 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리
final class RegisterViewModelProvider
    extends $NotifierProvider<RegisterViewModel, RegisterFormState> {
  /// 회원가입 폼 ViewModel
  ///
  /// 폼 상태 관리 및 이메일 인증 로직 처리
  const RegisterViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerViewModelHash();

  @$internal
  @override
  RegisterViewModel create() => RegisterViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterFormState>(value),
    );
  }
}

String _$registerViewModelHash() => r'8370b14f7719b80926d05c0007540d8d7368e729';

/// 회원가입 폼 ViewModel
///
/// 폼 상태 관리 및 이메일 인증 로직 처리

abstract class _$RegisterViewModel extends $Notifier<RegisterFormState> {
  RegisterFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RegisterFormState, RegisterFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RegisterFormState, RegisterFormState>,
        RegisterFormState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
