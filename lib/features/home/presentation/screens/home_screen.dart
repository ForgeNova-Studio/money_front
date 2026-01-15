// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

// core
import 'package:moneyflow/router/route_names.dart';

// features
import 'package:moneyflow/features/home/presentation/widgets/custom_calendar.dart';
import 'package:moneyflow/features/home/presentation/widgets/home_account_book_dropdown.dart';
import 'package:moneyflow/features/home/presentation/widgets/home_budget_info_card.dart';
import 'package:moneyflow/features/home/presentation/widgets/home_fab_menu.dart';
import 'package:moneyflow/features/home/presentation/widgets/home_transaction_sheet.dart';
import 'package:moneyflow/features/home/presentation/providers/home_providers.dart';
import 'package:moneyflow/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/account_book/domain/entities/account_book.dart';
import 'package:moneyflow/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moneyflow/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isFabExpanded = false;
  bool _isAccountBookMenuOpen = false;
  ProviderSubscription<AsyncValue<List<AccountBook>>>? _accountBooksSub;
  ProviderSubscription<String?>? _refreshErrorSub;

  @override
  void initState() {
    super.initState();
    _accountBooksSub = ref.listenManual<AsyncValue<List<AccountBook>>>(
      accountBooksProvider,
      (previous, next) {
        next.whenData((books) {
          final availableIds = books
              .where((book) => book.isActive != false)
              .map((book) => book.accountBookId)
              .whereType<String>()
              .toList();
          ref
              .read(selectedAccountBookViewModelProvider.notifier)
              .ensureSelectedAccountBookId(availableIds);
        });
      },
    );
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
    _accountBooksSub?.close();
    _refreshErrorSub?.close();
    super.dispose();
  }

  // 수입/지출 삭제
  Future<void> _handleDeleteTransaction(TransactionEntity transaction) async {
    if (transaction.id.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제할 수 없는 항목입니다.')),
        );
      }
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제'),
        content: const Text('이 내역을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    try {
      await ref
          .read(homeViewModelProvider.notifier)
          .deleteTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final homeState = ref.watch(homeViewModelProvider);
    final calendarFormat = homeState.calendarFormat;
    final accountBooksState = ref.watch(accountBooksProvider);
    final selectedAccountBookState =
        ref.watch(selectedAccountBookViewModelProvider);
    final isRefreshing = ref.watch(homeRefreshIndicatorProvider);
    final selectedAccountBookName = _resolveSelectedAccountBookName(
      accountBooksState,
      selectedAccountBookState,
    );

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _toggleAccountBookMenu,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      selectedAccountBookName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isAccountBookMenuOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colorScheme.onSurface,
                  ),
                ],
              ),
            ),
            flexibleSpace: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _collapseOverlaysIfNeeded(),
              child: const SizedBox.expand(),
            ),
            backgroundColor: colorScheme.surface,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            titleSpacing: 30,
            actions: [
              if (isRefreshing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              IconButton(
                tooltip: '로그아웃',
                icon: Icon(Icons.logout, color: colorScheme.onSurface),
                onPressed: () async {
                  await ref.read(authViewModelProvider.notifier).logout();
                },
              ),
            ],
          ),
          body: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _collapseOverlaysIfNeeded(),
            child: Column(
              children: [
                // 1. Budget Info Area
                const HomeBudgetInfoCard(),

                // 2. Custom Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: CustomCalendar(
                    format: calendarFormat,
                    focusedDay: homeState.focusedMonth,
                    selectedDay: homeState.selectedDate,
                    monthlyData: homeState.monthlyData,
                    onFormatChanged: _handleFormatChanged,
                    onDateSelected: _handleDateSelected,
                    onPageChanged: _handlePageChanged,
                  ),
                ),

                // 3. Transactions Sheet (Fills remaining space)
                Expanded(
                  child: HomeTransactionSheet(
                    homeState: homeState,
                    onDelete: _handleDeleteTransaction,
                    onCameraTap: () {
                      // TODO: Navigate to OCR screen
                    },
                    onResetToMonthView: () {
                      ref
                          .read(homeViewModelProvider.notifier)
                          .resetToMonthView();
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: HomeFabMenu(
            isExpanded: _isFabExpanded,
            onToggle: () {
              setState(() => _isFabExpanded = !_isFabExpanded);
            },
            onAddIncome: () {
              setState(() => _isFabExpanded = false);
              context.push(RouteNames.addIncome, extra: homeState.selectedDate);
            },
            onAddExpense: () {
              setState(() => _isFabExpanded = false);
              context.push(RouteNames.addExpense, extra: homeState.selectedDate);
            },
            onScanReceipt: () {
              setState(() => _isFabExpanded = false);
              context.push(RouteNames.ocrTest);
            },
          ),
        ),
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
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: HomeAccountBookDropdown(
                  accountBooksState: accountBooksState,
                  selectedAccountBookState: selectedAccountBookState,
                  onCreateAccountBook: () {
                    setState(() => _isAccountBookMenuOpen = false);
                    context.push(RouteNames.accountBookCreate);
                  },
                  onSelectAccountBook: (bookId) async {
                    await ref
                        .read(selectedAccountBookViewModelProvider.notifier)
                        .setSelectedAccountBookId(bookId);
                    if (!mounted) return;
                    setState(() => _isAccountBookMenuOpen = false);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Calendar Format 변경(월간/주간)
  void _handleFormatChanged(CalendarFormat format) {
    _collapseOverlaysIfNeeded();
    ref.read(homeViewModelProvider.notifier).setCalendarFormat(format);
  }

  // Calendar 날짜 선택
  void _handleDateSelected(DateTime selected, DateTime focused) {
    _collapseOverlaysIfNeeded();
    ref.read(homeViewModelProvider.notifier).selectDate(selected);
  }

  // Calendar 페이지 변경(월/주 변경)
  void _handlePageChanged(DateTime focused) {
    _collapseOverlaysIfNeeded();
    ref.read(homeViewModelProvider.notifier).changeMonth(focused);
  }

  void _collapseOverlaysIfNeeded() {
    if (_isFabExpanded || _isAccountBookMenuOpen) {
      setState(() {
        _isFabExpanded = false;
        _isAccountBookMenuOpen = false;
      });
    }
  }

  void _toggleAccountBookMenu() {
    setState(() {
      _isFabExpanded = false;
      _isAccountBookMenuOpen = !_isAccountBookMenuOpen;
    });
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

}
