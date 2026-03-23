import 'dart:async';

import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/search/presentation/providers/search_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_view_model.g.dart';

/// 검색 화면 상태
class SearchState {
  final String keyword;
  final List<TransactionEntity> results;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNext;
  final int currentPage;
  final String? errorMessage;

  const SearchState({
    this.keyword = '',
    this.results = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasNext = false,
    this.currentPage = 0,
    this.errorMessage,
  });

  bool get isEmpty => keyword.isNotEmpty && !isLoading && results.isEmpty;

  SearchState copyWith({
    String? keyword,
    List<TransactionEntity>? results,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNext,
    int? currentPage,
    String? errorMessage,
  }) {
    return SearchState(
      keyword: keyword ?? this.keyword,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNext: hasNext ?? this.hasNext,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }
}

/// 거래 내역 검색 ViewModel
///
/// - 300ms debounce 후 API 호출
/// - 페이지네이션 (무한 스크롤)
@riverpod
class SearchViewModel extends _$SearchViewModel {
  Timer? _debounceTimer;

  @override
  SearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const SearchState();
  }

  void onKeywordChanged(String keyword) {
    _debounceTimer?.cancel();

    if (keyword.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(
      keyword: keyword,
      isLoading: true,
      results: const [],
      errorMessage: null,
    );

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _search(keyword.trim(), page: 0);
    });
  }

  Future<void> _search(String keyword, {required int page}) async {
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '가계부를 선택해주세요.',
      );
      return;
    }

    try {
      final repository = ref.read(searchRepositoryProvider);
      final result = await repository.search(
        keyword: keyword,
        accountBookId: accountBookId,
        page: page,
      );

      if (page == 0) {
        state = state.copyWith(
          results: result.transactions,
          isLoading: false,
          hasNext: result.hasNext,
          currentPage: 0,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          results: [...state.results, ...result.transactions],
          isLoadingMore: false,
          hasNext: result.hasNext,
          currentPage: page,
          errorMessage: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: '검색에 실패했습니다.',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNext || state.keyword.isEmpty) return;
    state = state.copyWith(isLoadingMore: true);
    await _search(state.keyword, page: state.currentPage + 1);
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const SearchState();
  }
}
