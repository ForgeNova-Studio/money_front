// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_ui_event_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthUiEventViewModel)
const authUiEventViewModelProvider = AuthUiEventViewModelProvider._();

final class AuthUiEventViewModelProvider
    extends $NotifierProvider<AuthUiEventViewModel, List<AuthUiEvent>> {
  const AuthUiEventViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authUiEventViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authUiEventViewModelHash();

  @$internal
  @override
  AuthUiEventViewModel create() => AuthUiEventViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AuthUiEvent> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AuthUiEvent>>(value),
    );
  }
}

String _$authUiEventViewModelHash() =>
    r'c884695b2ed73729c009a81fccfeded26f55a497';

abstract class _$AuthUiEventViewModel extends $Notifier<List<AuthUiEvent>> {
  List<AuthUiEvent> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<AuthUiEvent>, List<AuthUiEvent>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<AuthUiEvent>, List<AuthUiEvent>>,
        List<AuthUiEvent>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
