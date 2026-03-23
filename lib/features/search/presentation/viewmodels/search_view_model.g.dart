// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 거래 내역 검색 ViewModel
///
/// - 300ms debounce 후 API 호출
/// - 페이지네이션 (무한 스크롤)

@ProviderFor(SearchViewModel)
const searchViewModelProvider = SearchViewModelProvider._();

/// 거래 내역 검색 ViewModel
///
/// - 300ms debounce 후 API 호출
/// - 페이지네이션 (무한 스크롤)
final class SearchViewModelProvider
    extends $NotifierProvider<SearchViewModel, SearchState> {
  /// 거래 내역 검색 ViewModel
  ///
  /// - 300ms debounce 후 API 호출
  /// - 페이지네이션 (무한 스크롤)
  const SearchViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchViewModelHash();

  @$internal
  @override
  SearchViewModel create() => SearchViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchViewModelHash() => r'6cb885aabe48a3a1de108a4999fecfe836034e06';

/// 거래 내역 검색 ViewModel
///
/// - 300ms debounce 후 API 호출
/// - 페이지네이션 (무한 스크롤)

abstract class _$SearchViewModel extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchState, SearchState>, SearchState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
