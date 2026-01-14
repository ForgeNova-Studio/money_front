// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/router/route_names.dart';

// features

import 'package:moneyflow/features/home/presentation/widgets/custom_calendar.dart';
import 'package:moneyflow/features/home/presentation/widgets/transaction_list_section.dart';
import 'package:moneyflow/features/home/presentation/states/home_state.dart';
import 'package:moneyflow/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/account_book/domain/entities/account_book.dart';
import 'package:moneyflow/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moneyflow/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isFabExpanded = false;
  bool _isAccountBookMenuOpen = false;
  ProviderSubscription<AsyncValue<List<AccountBook>>>? _accountBooksSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).fetchMonthlyData(DateTime.now());
    });
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
  }

  @override
  void dispose() {
    _accountBooksSub?.close();
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
          ),
          body: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _collapseOverlaysIfNeeded(),
            child: Column(
              children: [
                // 1. Budget Info Area
                _buildBudgetInfo(),

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
                Expanded(child: _buildTransactionSheet(homeState)),
              ],
            ),
          ),
          floatingActionButton:
              _buildFloatingActionButton(homeState.selectedDate),
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
                child: _buildAccountBookDropdown(
                  accountBooksState: accountBooksState,
                  selectedAccountBookState: selectedAccountBookState,
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

  Widget _buildAccountBookDropdown({
    Key? key,
    required AsyncValue<List<AccountBook>> accountBooksState,
    required AsyncValue<String?> selectedAccountBookState,
  }) {
    return Align(
      key: key,
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: accountBooksState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('가계부를 불러오지 못했습니다: $error'),
            ),
            data: (books) {
              final selectedId = selectedAccountBookState.asData?.value;
              final activeBooks =
                  books.where((book) => book.isActive != false).toList();

              if (activeBooks.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text('등록된 가계부가 없습니다.'),
                      ),
                    ),
                    const Divider(height: 1),
                    _buildCreateAccountBookButton(),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '가계부 선택',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...activeBooks.map((book) => _buildAccountBookMenuItem(
                        book: book,
                        isSelected: book.accountBookId == selectedId,
                      )),
                  const Divider(height: 1),
                  _buildCreateAccountBookButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccountBookMenuItem({
    required AccountBook book,
    required bool isSelected,
  }) {
    final bookId = book.accountBookId;
    return InkWell(
      onTap: bookId == null
          ? null
          : () async {
              await ref
                  .read(selectedAccountBookViewModelProvider.notifier)
                  .setSelectedAccountBookId(bookId);
              if (!mounted) return;
              setState(() => _isAccountBookMenuOpen = false);
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                book.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  book.bookType.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountBookButton() {
    return InkWell(
      onTap: () {
        setState(() => _isAccountBookMenuOpen = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('새 가계부 만들기 기능은 준비 중입니다.')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '새로운 가계부 열기',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSheet(HomeState homeState) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: homeState.calendarFormat == CalendarFormat.week
          ? NotificationListener<DraggableScrollableNotification>(
              key: const ValueKey('modal'),
              onNotification: (notification) {
                if (notification.extent <= 0.05) {
                  ref.read(homeViewModelProvider.notifier).resetToMonthView();
                }
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 1.0,
                minChildSize: 0.0,
                maxChildSize: 1.0,
                snap: true,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(top: 16),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: TransactionListSection(
                        monthlyData: homeState.monthlyData,
                        selectedDate: homeState.selectedDate,
                        isModal: true,
                        onDelete: _handleDeleteTransaction,
                        onCameraTap: () {
                          // TODO: Navigate to OCR screen
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          : SizedBox.shrink(key: ValueKey('empty')),
    );
  }

  Widget _buildBudgetInfo() {
    // Dummy Data
    final totalBudget = 500000;
    final usedAmount = 200000;
    final remainingAmount = totalBudget - usedAmount;
    final progress = usedAmount / totalBudget;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateTime.now().month}월 예산',
                style: TextStyle(
                  fontSize: 16,
                  color: context.appColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 14, color: context.appColors.gray400),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(remainingAmount)}원 남음',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.appColors.gray100,
              valueColor:
                  AlwaysStoppedAnimation<Color>(context.appColors.primary),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '지출 ${NumberFormat('#,###').format(usedAmount)}원',
                style: TextStyle(
                    fontSize: 12, color: context.appColors.textTertiary),
              ),
              Text(
                '예산 ${NumberFormat('#,###').format(totalBudget)}원',
                style: TextStyle(
                    fontSize: 12, color: context.appColors.textTertiary),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(DateTime selectedDate) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 확장된 메뉴
        if (_isFabExpanded) ...[
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: colorScheme.inverseSurface,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFabMenuItem(
                      icon: Icons.arrow_downward,
                      label: '수입',
                      color: Colors.blue,
                      onTap: () {
                        setState(() => _isFabExpanded = false);
                        context.push(RouteNames.addIncome, extra: selectedDate);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildFabMenuItem(
                      icon: Icons.arrow_upward,
                      label: '지출',
                      color: Colors.orange,
                      onTap: () {
                        setState(() => _isFabExpanded = false);
                        context.push(RouteNames.addExpense,
                            extra: selectedDate);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildFabMenuItem(
                      icon: Icons.document_scanner,
                      label: '영수증 스캔',
                      color: Colors.green,
                      onTap: () {
                        setState(() => _isFabExpanded = false);
                        context.push(RouteNames.ocrTest);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // 메인 FAB 버튼 (+ 또는 X)
        SizedBox(
          width: 80,
          height: 35,
          child: FloatingActionButton(
            onPressed: () => setState(() => _isFabExpanded = !_isFabExpanded),
            backgroundColor: _isFabExpanded
                ? colorScheme.inverseSurface
                : colorScheme.primary,
            foregroundColor: _isFabExpanded
                ? colorScheme.onInverseSurface
                : colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isFabExpanded ? Icons.close : Icons.add,
                key: ValueKey(_isFabExpanded),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFabMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onInverseSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
