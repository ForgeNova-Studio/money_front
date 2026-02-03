// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_expenses_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 대기 중인 지출 관리 ViewModel
/// SMS에서 파싱된 지출을 임시 저장하고 일괄 처리

@ProviderFor(PendingExpensesViewModel)
const pendingExpensesViewModelProvider = PendingExpensesViewModelProvider._();

/// 대기 중인 지출 관리 ViewModel
/// SMS에서 파싱된 지출을 임시 저장하고 일괄 처리
final class PendingExpensesViewModelProvider
    extends $NotifierProvider<PendingExpensesViewModel, PendingExpensesState> {
  /// 대기 중인 지출 관리 ViewModel
  /// SMS에서 파싱된 지출을 임시 저장하고 일괄 처리
  const PendingExpensesViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pendingExpensesViewModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pendingExpensesViewModelHash();

  @$internal
  @override
  PendingExpensesViewModel create() => PendingExpensesViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PendingExpensesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PendingExpensesState>(value),
    );
  }
}

String _$pendingExpensesViewModelHash() =>
    r'bd22f83263a8876ea105235e51ffababc1d8a64a';

/// 대기 중인 지출 관리 ViewModel
/// SMS에서 파싱된 지출을 임시 저장하고 일괄 처리

abstract class _$PendingExpensesViewModel
    extends $Notifier<PendingExpensesState> {
  PendingExpensesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PendingExpensesState, PendingExpensesState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PendingExpensesState, PendingExpensesState>,
        PendingExpensesState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
