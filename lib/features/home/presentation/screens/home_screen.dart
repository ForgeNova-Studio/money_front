// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

// core
import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/core/constants/app_constants.dart';

// features
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/common/providers/ui_overlay_providers.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/providers/home_providers.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/home/presentation/widgets/delete_confirm_dialog.dart';
import 'package:moamoa/features/home/presentation/widgets/home_account_book_dropdown.dart';
import 'package:moamoa/features/home/presentation/widgets/home_fab_menu.dart';
import 'package:moamoa/features/home/presentation/widgets/home_header_title.dart';
import 'package:moamoa/features/home/presentation/widgets/home_top_section.dart';
import 'package:moamoa/features/home/presentation/widgets/home_transaction_sheet.dart';
import 'package:moamoa/features/notification/presentation/viewmodels/notification_view_model.dart';

/// 앱의 메인 홈 화면 위젯
///
/// 예산/자산 정보, 캘린더, 거래 내역을 통합하여 표시하는 홈 화면입니다.
/// 월간/주간 캘린더 뷰 전환과 가계부 선택 기능을 제공합니다.
///
/// 주요 기능:
/// - 가계부 선택 드롭다운 (AppBar)
/// - 예산/자산 정보 카드 ([HomeBudgetInfoCard])
/// - 대기중인 지출 배너 ([HomePendingExpensesBanner])
/// - 월간/주간 캘린더 ([CustomCalendar])
/// - 거래 내역 리스트 (주간 뷰에서 모달로 표시)
/// - FAB 메뉴 (수입/지출 추가, 영수증 스캔)
///
/// 상태 관리:
/// - [homeViewModelProvider]: 홈 화면 상태
/// - [selectedAccountBookViewModelProvider]: 선택된 가계부
/// - [accountBooksProvider]: 가계부 목록
///
/// 사용 예시:
/// ```dart
/// // 라우터에서 사용
/// GoRoute(
///   path: '/home',
///   builder: (context, state) => const HomeScreen(),
/// )
/// ```
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  /// 홈스크린 State
  /// _isAccountBookMenuOpen : 가계부 메뉴 열림 여부
  /// _isFabDimmed : FAB 활성화 여부
  /// _refreshErrorSub : 데이터 새로고침 에러 구독
  bool _isAccountBookMenuOpen = false;
  bool _isFabDimmed = false;
  ProviderSubscription<String?>? _refreshErrorSub;

  // Lifecycle Methods
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshErrorSub = ref.listenManual<String?>(
      homeRefreshErrorProvider,
      (previous, next) {
        final message = next ?? '';
        if (message.isEmpty || !mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        ref.read(homeRefreshErrorProvider.notifier).clear();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshErrorSub?.close();
    super.dispose();
  }

  /// Background → Foreground 전환 시 데이터 새로고침
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 foreground로 돌아왔을 때 데이터 새로고침
      ref.read(homeViewModelProvider.notifier).refresh();
    }
  }

  // 수입/지출 삭제
  Future<bool> _handleDeleteTransaction(TransactionEntity transaction) async {
    // id가 비어있다면 삭제할 수 없다.
    if (transaction.id.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제할 수 없는 항목입니다.')),
        );
      }
      return false;
    }

    // 삭제 확인 다이얼로그
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.black54,
      builder: (context) => DeleteConfirmDialog(
        title: transaction.title,
      ),
    );

    if (shouldDelete != true || !mounted) {
      return false;
    }

    // 삭제 확인
    try {
      await ref
          .read(homeViewModelProvider.notifier)
          .deleteTransaction(transaction);
      _resetFabDimmed();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제되었습니다.')),
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: $e')),
        );
      }
      return false;
    }
  }

  // Calendar Format 변경(월간/주간)
  void _handleFormatChanged(CalendarFormat format) {
    _collapseOverlaysIfNeeded();
    _resetFabDimmed();
    ref.read(homeViewModelProvider.notifier).setCalendarFormat(format);
  }

  // Calendar 날짜 선택
  void _handleDateSelected(DateTime selected, DateTime focused) {
    _collapseOverlaysIfNeeded();
    _resetFabDimmed();
    ref.read(homeViewModelProvider.notifier).selectDate(selected);
  }

  // Calendar 페이지 변경(월/주 변경)
  void _handlePageChanged(DateTime focused) {
    _collapseOverlaysIfNeeded();
    _resetFabDimmed();
    ref.read(homeViewModelProvider.notifier).changeMonth(focused);
  }

  // 가계부 메뉴 토글
  void _toggleAccountBookMenu() {
    final nextState = !_isAccountBookMenuOpen;
    ref.read(isHomeFabExpandedProvider.notifier).set(false);
    setState(() {
      _isAccountBookMenuOpen = nextState;
    });
    ref.read(appScrimActiveProvider.notifier).setActive(nextState);
  }

  // 가계부 선택
  void _setAccountBookMenuOpen(bool isOpen) {
    ref.read(isHomeFabExpandedProvider.notifier).set(false);
    setState(() {
      _isAccountBookMenuOpen = isOpen;
    });
    ref.read(appScrimActiveProvider.notifier).setActive(isOpen);
  }

  // FAB 투명도 변경
  void _handleTransactionReveal(bool isActive) {
    if (_isFabDimmed == isActive) {
      return;
    }
    setState(() {
      _isFabDimmed = isActive;
    });
    if (isActive) {
      ref.read(isHomeFabExpandedProvider.notifier).set(false);
    }
  }

  // 화면에 열러 있는 오버레이들(FAB, 가계부 선택 메뉴)을 닫아주는 헬퍼 메서드
  void _collapseOverlaysIfNeeded() {
    final isFabExpanded = ref.read(isHomeFabExpandedProvider);
    if (isFabExpanded || _isAccountBookMenuOpen) {
      if (isFabExpanded) {
        ref.read(isHomeFabExpandedProvider.notifier).set(false);
      }
      setState(() {
        _isAccountBookMenuOpen = false;
      });
      ref.read(appScrimActiveProvider.notifier).setActive(false);
    }
  }

  // FAB 버튼 투명도 초기화
  void _resetFabDimmed() {
    if (_isFabDimmed) {
      setState(() => _isFabDimmed = false);
    }
  }

  String _resolveSelectedAccountBookName(
    AsyncValue<List<AccountBook>> accountBooksState,
    AsyncValue<String?> selectedAccountBookState,
  ) {
    final selectedId = selectedAccountBookState.asData?.value;
    return accountBooksState.when(
      data: (books) {
        if (books.isEmpty) {
          return '가계부 선택';
        }
        if (selectedId == null) {
          return books.first.name;
        }
        final selectedBook = books.firstWhere(
          (book) => book.accountBookId == selectedId,
          orElse: () => books.first,
        );
        return selectedBook.name;
      },
      error: (_, __) => '가계부 선택',
      loading: () => '가계부 불러오는 중',
    );
  }

  // UI Construction
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final homeState = ref.watch(homeViewModelProvider);
    final isFabExpanded = ref.watch(isHomeFabExpandedProvider);
    final calendarFormat = homeState.calendarFormat;
    final isWeekView = calendarFormat == CalendarFormat.week;
    final accountBooksState = ref.watch(accountBooksProvider);
    final selectedAccountBookState =
        ref.watch(selectedAccountBookViewModelProvider);
    final selectedAccountBookName = _resolveSelectedAccountBookName(
      accountBooksState,
      selectedAccountBookState,
    );
    final notificationState = ref.watch(notificationViewModelProvider);
    final unreadCount = notificationState.unreadCount;

    // 홈 상단 위젯(예산/자산 정보, 대기중인 지출 내역, Calendar)
    final topSection = HomeTopSection(
      calendarFormat: calendarFormat,
      focusedDay: homeState.focusedMonth,
      selectedDay: homeState.selectedDate,
      monthlyData: homeState.monthlyData,
      onFormatChanged: _handleFormatChanged,
      onDateSelected: _handleDateSelected,
      onPageChanged: _handlePageChanged,
    );

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.surface,
          resizeToAvoidBottomInset:
              false, // 이전 화면에서 키보드가 열려 있을 때, 홈에서 오버플로우 나는 현상 해결
          appBar: AppBar(
            title: HomeHeaderTitle(
              selectedAccountBookName: selectedAccountBookName,
              isMenuOpen: _isAccountBookMenuOpen,
              onTap: _toggleAccountBookMenu,
            ),

            /// AppBar 배경 공간의 위치하는 위젯
            /// - 역할 : Listener을 통해 터치 감지하여 오버레이를 닫는다.
            flexibleSpace: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _collapseOverlaysIfNeeded(),
              child: const SizedBox.expand(),
            ),
            backgroundColor: colorScheme.surface,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              // 알림 아이콘 버튼
              _NotificationIconButton(
                unreadCount: unreadCount,
                onTap: () => context.push(RouteNames.notifications),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _collapseOverlaysIfNeeded(),
            // 주간/월간 달력 뷰에 따라 화면 구성 다르게 설정
            child: isWeekView
                ? Column(
                    children: [
                      topSection,

                      // 4. 수입/지출 내역 리스트
                      Expanded(
                        child: HomeTransactionSheet(
                          homeState: homeState,
                          onDelete: _handleDeleteTransaction,
                          onResetToMonthView: () {
                            _resetFabDimmed();
                            ref
                                .read(homeViewModelProvider.notifier)
                                .resetToMonthView();
                          },
                          onRevealActiveChanged: _handleTransactionReveal,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: topSection,
                  ),
          ),
          floatingActionButton: AnimatedOpacity(
            opacity: _isFabDimmed ? 0 : 1,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            child: IgnorePointer(
              ignoring: _isFabDimmed,
              child: HomeFabMenu(
                isExpanded: isFabExpanded,
                onToggle: () {
                  ref.read(isHomeFabExpandedProvider.notifier).toggle();
                },
                onAddIncome: () {
                  ref.read(isHomeFabExpandedProvider.notifier).set(false);
                  context.push(RouteNames.addIncome,
                      extra: homeState.selectedDate);
                },
                onAddExpense: () {
                  ref.read(isHomeFabExpandedProvider.notifier).set(false);
                  context.push(RouteNames.addExpense,
                      extra: homeState.selectedDate);
                },
                onScanReceipt: () {
                  ref.read(isHomeFabExpandedProvider.notifier).set(false);
                  context.push(RouteNames.ocrTest);
                },
              ),
            ),
          ),
        ),

        /// 가계부 선택 메뉴 오버레이의 배경 처리 담당
        Positioned.fill(
          child: IgnorePointer(
            // 메뉴가 열렸을 때만 터치를 감지하도록 설정
            ignoring: !_isAccountBookMenuOpen,
            child: AnimatedOpacity(
              // 메뉴 열리면 배경을 어둡게, 닫히면 투명하게
              opacity: _isAccountBookMenuOpen ? 1 : 0,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              // 배경을 터치하면 가계부 메뉴 오버레이 닫음
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _collapseOverlaysIfNeeded,
                child: Container(
                  color: colorScheme.scrim.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
        ),
        // 가계부 메뉴 선택 오버레이
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: _isAccountBookMenuOpen ? 1 : 0,
                ),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return IgnorePointer(
                    ignoring: value == 0,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: value,
                        child: Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 8 * (1 - value)),
                            child: Transform.scale(
                              scale: 0.98 + (0.02 * value),
                              alignment: Alignment.topCenter,
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: HomeAccountBookDropdown(
                  accountBooksState: accountBooksState,
                  selectedAccountBookState: selectedAccountBookState,
                  onCreateAccountBook: () {
                    _setAccountBookMenuOpen(false);
                    context.push(RouteNames.accountBookCreate);
                  },
                  onSelectAccountBook: (bookId) async {
                    await ref
                        .read(selectedAccountBookViewModelProvider.notifier)
                        .setSelectedAccountBookId(bookId);
                    if (!mounted) return;
                    _setAccountBookMenuOpen(false);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 알림 아이콘 버튼 (읽지 않은 알림 뱃지 포함)
class _NotificationIconButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationIconButton({
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: colorScheme.onSurface,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
