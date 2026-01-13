import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:moneyflow/features/common/providers/core_providers.dart';

part 'selected_account_book_view_model.g.dart';

@riverpod
class SelectedAccountBookViewModel extends _$SelectedAccountBookViewModel {
  static const String _storageKey = 'selected_account_book_id';

  @override
  AsyncValue<String?> build() {
    Future.microtask(_loadFromStorage);
    return const AsyncValue.loading();
  }

  Future<void> _loadFromStorage() async {
    final preferences = ref.read(sharedPreferencesProvider);
    final storedId = preferences.getString(_storageKey);

    if (!ref.mounted) return;
    state = AsyncValue.data(storedId);
  }

  Future<void> setSelectedAccountBookId(String? accountBookId) async {
    state = AsyncValue.data(accountBookId);

    final preferences = ref.read(sharedPreferencesProvider);
    if (accountBookId == null) {
      await preferences.remove(_storageKey);
    } else {
      await preferences.setString(_storageKey, accountBookId);
    }
  }

  Future<void> ensureSelectedAccountBookId(List<String> availableIds) async {
    if (availableIds.isEmpty) {
      return;
    }

    final currentId = state.asData?.value;
    if (currentId != null && availableIds.contains(currentId)) {
      return;
    }

    await setSelectedAccountBookId(availableIds.first);
  }
}
