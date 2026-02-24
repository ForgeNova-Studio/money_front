// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지출 변경 이벤트 발행 Notifier

@ProviderFor(ExpenseSync)
const expenseSyncProvider = ExpenseSyncProvider._();

/// 지출 변경 이벤트 발행 Notifier
final class ExpenseSyncProvider
    extends $NotifierProvider<ExpenseSync, ExpenseSyncSignal?> {
  /// 지출 변경 이벤트 발행 Notifier
  const ExpenseSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseSyncHash();

  @$internal
  @override
  ExpenseSync create() => ExpenseSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseSyncSignal? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseSyncSignal?>(value),
    );
  }
}

String _$expenseSyncHash() => r'd3f699e8f71169687b34748a47b46c1f755a19db';

/// 지출 변경 이벤트 발행 Notifier

abstract class _$ExpenseSync extends $Notifier<ExpenseSyncSignal?> {
  ExpenseSyncSignal? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExpenseSyncSignal?, ExpenseSyncSignal?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ExpenseSyncSignal?, ExpenseSyncSignal?>,
        ExpenseSyncSignal?,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// 트랜잭션 변경 이벤트 발행 Notifier

@ProviderFor(TransactionSync)
const transactionSyncProvider = TransactionSyncProvider._();

/// 트랜잭션 변경 이벤트 발행 Notifier
final class TransactionSyncProvider
    extends $NotifierProvider<TransactionSync, TransactionSyncSignal?> {
  /// 트랜잭션 변경 이벤트 발행 Notifier
  const TransactionSyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transactionSyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionSyncHash();

  @$internal
  @override
  TransactionSync create() => TransactionSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionSyncSignal? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionSyncSignal?>(value),
    );
  }
}

String _$transactionSyncHash() => r'ac32b1dc7c79e60cd351e996dfc28426d840ee99';

/// 트랜잭션 변경 이벤트 발행 Notifier

abstract class _$TransactionSync extends $Notifier<TransactionSyncSignal?> {
  TransactionSyncSignal? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<TransactionSyncSignal?, TransactionSyncSignal?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TransactionSyncSignal?, TransactionSyncSignal?>,
        TransactionSyncSignal?,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
