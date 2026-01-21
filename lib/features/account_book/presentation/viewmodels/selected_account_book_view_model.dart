import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/common/providers/core_providers.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'selected_account_book_view_model.g.dart';

@riverpod
class SelectedAccountBookViewModel extends _$SelectedAccountBookViewModel {
  static const String _storageKeyPrefix = 'selected_account_book_id';
  bool _hasLoadedFromStorage = false;
  List<String>? _pendingAvailableIds;

  @override
  AsyncValue<String?> build() {
    _hasLoadedFromStorage = false;
    _pendingAvailableIds = null;
    final userId = ref.watch(authViewModelProvider).user?.userId;
    Future.microtask(() => _loadFromStorage(userId));
    ref.listen<AsyncValue<List<AccountBook>>>(
      accountBooksProvider,
      (previous, next) {
        next.whenData(_handleAccountBooks);
      },
    );
    return const AsyncValue.loading();
  }

  String _storageKeyForUser(String? userId) {
    return '${_storageKeyPrefix}_$userId';
  }

  Future<void> _loadFromStorage(String? userId) async {
    if (userId == null) {
      if (!ref.mounted) return;
      state = const AsyncValue.data(null);
      _hasLoadedFromStorage = true;
      _pendingAvailableIds = null;
      return;
    }

    final preferences = ref.read(sharedPreferencesProvider);
    final storageKey = _storageKeyForUser(userId);
    final storedId = preferences.getString(storageKey);

    if (!ref.mounted) return;
    state = AsyncValue.data(storedId);
    _hasLoadedFromStorage = true;
    _applyPendingAccountBooks();
  }

  void _handleAccountBooks(List<AccountBook> books) {
    final availableIds = books
        .where((book) => book.isActive != false)
        .map((book) => book.accountBookId)
        .whereType<String>()
        .toList();

    if (!_hasLoadedFromStorage) {
      _pendingAvailableIds = availableIds;
      return;
    }

    unawaited(ensureSelectedAccountBookId(availableIds));
  }

  void _applyPendingAccountBooks() {
    final pendingIds = _pendingAvailableIds;
    _pendingAvailableIds = null;
    if (pendingIds != null) {
      unawaited(ensureSelectedAccountBookId(pendingIds));
      return;
    }

    ref.read(accountBooksProvider).whenData(_handleAccountBooks);
  }

  Future<void> setSelectedAccountBookId(String? accountBookId) async {
    state = AsyncValue.data(accountBookId);

    final preferences = ref.read(sharedPreferencesProvider);
    final userId = ref.read(authViewModelProvider).user?.userId;
    if (userId == null) {
      return;
    }
    final storageKey = _storageKeyForUser(userId);
    if (accountBookId == null) {
      await preferences.remove(storageKey);
    } else {
      await preferences.setString(storageKey, accountBookId);
    }
  }

  Future<void> ensureSelectedAccountBookId(List<String> availableIds) async {
    if (availableIds.isEmpty) {
      await setSelectedAccountBookId(null);
      return;
    }

    final currentId = state.asData?.value;
    if (currentId != null && availableIds.contains(currentId)) {
      return;
    }

    await setSelectedAccountBookId(availableIds.first);
  }
}
