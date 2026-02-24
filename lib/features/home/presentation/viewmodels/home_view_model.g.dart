// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 홈 화면의 비즈니스 로직을 관리하는 ViewModel
///
/// 월간 거래 데이터, 예산/자산 정보, 캘린더 상태를 관리합니다.
/// Riverpod을 사용하여 상태를 관리하고, 로컬 캐시와 서버 데이터를 동기화합니다.
///
/// 주요 기능:
/// - 월간 거래 데이터 조회 및 캐싱 ([fetchMonthlyData])
/// - 예산/자산 정보 조회 및 캐싱 ([_loadBudgetAndAsset])
/// - 날짜 선택 및 캘린더 포맷 변경 ([selectDate], [setCalendarFormat])
/// - 거래 내역 삭제 (Optimistic Update) ([deleteTransaction])
/// - 거래 내역 추가/수정 (Optimistic Update) ([addTransactionOptimistically], [updateTransactionOptimistically])
/// - 인접 월 데이터 프리패치 ([_prefetchAdjacentMonths])
///
/// 캐싱 전략:
/// - 메모리 캐시: Budget/Asset 정보
/// - 로컬 캐시: SQLite를 통한 월간 데이터 캐싱
/// - TTL: 5분 (캐시 유효 시간)
///
/// 사용 예시:
/// ```dart
/// // Provider 구독
/// final homeState = ref.watch(homeViewModelProvider);
///
/// // 데이터 새로고침
/// ref.read(homeViewModelProvider.notifier).refresh();
///
/// // 날짜 선택
/// ref.read(homeViewModelProvider.notifier).selectDate(DateTime.now());
/// ```

@ProviderFor(HomeViewModel)
const homeViewModelProvider = HomeViewModelProvider._();

/// 홈 화면의 비즈니스 로직을 관리하는 ViewModel
///
/// 월간 거래 데이터, 예산/자산 정보, 캘린더 상태를 관리합니다.
/// Riverpod을 사용하여 상태를 관리하고, 로컬 캐시와 서버 데이터를 동기화합니다.
///
/// 주요 기능:
/// - 월간 거래 데이터 조회 및 캐싱 ([fetchMonthlyData])
/// - 예산/자산 정보 조회 및 캐싱 ([_loadBudgetAndAsset])
/// - 날짜 선택 및 캘린더 포맷 변경 ([selectDate], [setCalendarFormat])
/// - 거래 내역 삭제 (Optimistic Update) ([deleteTransaction])
/// - 거래 내역 추가/수정 (Optimistic Update) ([addTransactionOptimistically], [updateTransactionOptimistically])
/// - 인접 월 데이터 프리패치 ([_prefetchAdjacentMonths])
///
/// 캐싱 전략:
/// - 메모리 캐시: Budget/Asset 정보
/// - 로컬 캐시: SQLite를 통한 월간 데이터 캐싱
/// - TTL: 5분 (캐시 유효 시간)
///
/// 사용 예시:
/// ```dart
/// // Provider 구독
/// final homeState = ref.watch(homeViewModelProvider);
///
/// // 데이터 새로고침
/// ref.read(homeViewModelProvider.notifier).refresh();
///
/// // 날짜 선택
/// ref.read(homeViewModelProvider.notifier).selectDate(DateTime.now());
/// ```
final class HomeViewModelProvider
    extends $NotifierProvider<HomeViewModel, HomeState> {
  /// 홈 화면의 비즈니스 로직을 관리하는 ViewModel
  ///
  /// 월간 거래 데이터, 예산/자산 정보, 캘린더 상태를 관리합니다.
  /// Riverpod을 사용하여 상태를 관리하고, 로컬 캐시와 서버 데이터를 동기화합니다.
  ///
  /// 주요 기능:
  /// - 월간 거래 데이터 조회 및 캐싱 ([fetchMonthlyData])
  /// - 예산/자산 정보 조회 및 캐싱 ([_loadBudgetAndAsset])
  /// - 날짜 선택 및 캘린더 포맷 변경 ([selectDate], [setCalendarFormat])
  /// - 거래 내역 삭제 (Optimistic Update) ([deleteTransaction])
  /// - 거래 내역 추가/수정 (Optimistic Update) ([addTransactionOptimistically], [updateTransactionOptimistically])
  /// - 인접 월 데이터 프리패치 ([_prefetchAdjacentMonths])
  ///
  /// 캐싱 전략:
  /// - 메모리 캐시: Budget/Asset 정보
  /// - 로컬 캐시: SQLite를 통한 월간 데이터 캐싱
  /// - TTL: 5분 (캐시 유효 시간)
  ///
  /// 사용 예시:
  /// ```dart
  /// // Provider 구독
  /// final homeState = ref.watch(homeViewModelProvider);
  ///
  /// // 데이터 새로고침
  /// ref.read(homeViewModelProvider.notifier).refresh();
  ///
  /// // 날짜 선택
  /// ref.read(homeViewModelProvider.notifier).selectDate(DateTime.now());
  /// ```
  const HomeViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeState>(value),
    );
  }
}

String _$homeViewModelHash() => r'0ec3de1a09e888ca1c627d5b032212815cd07f0f';

/// 홈 화면의 비즈니스 로직을 관리하는 ViewModel
///
/// 월간 거래 데이터, 예산/자산 정보, 캘린더 상태를 관리합니다.
/// Riverpod을 사용하여 상태를 관리하고, 로컬 캐시와 서버 데이터를 동기화합니다.
///
/// 주요 기능:
/// - 월간 거래 데이터 조회 및 캐싱 ([fetchMonthlyData])
/// - 예산/자산 정보 조회 및 캐싱 ([_loadBudgetAndAsset])
/// - 날짜 선택 및 캘린더 포맷 변경 ([selectDate], [setCalendarFormat])
/// - 거래 내역 삭제 (Optimistic Update) ([deleteTransaction])
/// - 거래 내역 추가/수정 (Optimistic Update) ([addTransactionOptimistically], [updateTransactionOptimistically])
/// - 인접 월 데이터 프리패치 ([_prefetchAdjacentMonths])
///
/// 캐싱 전략:
/// - 메모리 캐시: Budget/Asset 정보
/// - 로컬 캐시: SQLite를 통한 월간 데이터 캐싱
/// - TTL: 5분 (캐시 유효 시간)
///
/// 사용 예시:
/// ```dart
/// // Provider 구독
/// final homeState = ref.watch(homeViewModelProvider);
///
/// // 데이터 새로고침
/// ref.read(homeViewModelProvider.notifier).refresh();
///
/// // 날짜 선택
/// ref.read(homeViewModelProvider.notifier).selectDate(DateTime.now());
/// ```

abstract class _$HomeViewModel extends $Notifier<HomeState> {
  HomeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeState, HomeState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<HomeState, HomeState>, HomeState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
