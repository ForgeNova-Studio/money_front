import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_list_item.dart';
import 'package:moamoa/features/search/presentation/viewmodels/search_view_model.dart';
import 'package:moamoa/router/route_names.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController()..addListener(_onScroll);

    // 화면 진입 시 키보드 자동 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      ref.read(searchViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: _buildSearchAppBar(context, state, colorScheme),
      body: _buildBody(context, state),
    );
  }

  AppBar _buildSearchAppBar(
    BuildContext context,
    SearchState state,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) =>
            ref.read(searchViewModelProvider.notifier).onKeywordChanged(value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: '가맹점, 메모로 검색',
          hintStyle: TextStyle(
            color: context.appColors.textTertiary,
            fontSize: 16,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        if (state.keyword.isNotEmpty)
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: context.appColors.textSecondary,
            ),
            onPressed: () {
              _controller.clear();
              ref.read(searchViewModelProvider.notifier).clear();
            },
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state.keyword.isEmpty) {
      return _buildInitialState(context);
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _buildErrorState(context, state.errorMessage!);
    }

    if (state.isEmpty) {
      return _buildEmptyState(context, state.keyword);
    }

    return _buildResults(context, state);
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: context.appColors.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '가맹점명이나 메모로\n거래 내역을 검색하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String keyword) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: context.appColors.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '"$keyword"에 대한\n검색 결과가 없습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(color: context.appColors.error),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref
                .read(searchViewModelProvider.notifier)
                .onKeywordChanged(_controller.text),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchState state) {
    final grouped = _groupByDate(state.results);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: grouped.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == grouped.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final group = grouped[index];
        return _DateGroup(
          dateLabel: group.label,
          transactions: group.transactions,
          onTap: (transaction) => _navigateToEdit(context, transaction),
        );
      },
    );
  }

  void _navigateToEdit(BuildContext context, TransactionEntity transaction) {
    if (transaction.type == TransactionType.expense) {
      context.push(RouteNames.editExpense(transaction.id));
    } else {
      context.push(RouteNames.editIncome(transaction.id));
    }
  }

  List<_DateGroupData> _groupByDate(List<TransactionEntity> transactions) {
    final Map<String, List<TransactionEntity>> map = {};
    for (final tx in transactions) {
      final key = DateFormat('yyyy-MM-dd').format(tx.date);
      map.putIfAbsent(key, () => []).add(tx);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return map.entries
        .toList()
        .map((entry) {
          final date = DateTime.parse(entry.key);
          final dateOnly = DateTime(date.year, date.month, date.day);
          return _DateGroupData(
            dateKey: entry.key,
            label: _formatDateLabel(dateOnly, today, yesterday),
            transactions: entry.value,
          );
        })
        .toList()
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
  }

  String _formatDateLabel(DateTime date, DateTime today, DateTime yesterday) {
    if (date == today) return '오늘';
    if (date == yesterday) return '어제';

    final now = DateTime.now();
    if (date.year == now.year) {
      return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
    }
    return DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(date);
  }
}

class _DateGroupData {
  final String dateKey;
  final String label;
  final List<TransactionEntity> transactions;

  _DateGroupData({
    required this.dateKey,
    required this.label,
    required this.transactions,
  });
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({
    required this.dateLabel,
    required this.transactions,
    required this.onTap,
  });

  final String dateLabel;
  final List<TransactionEntity> transactions;
  final void Function(TransactionEntity) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            dateLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.appColors.textSecondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: transactions.map((tx) {
              return TransactionListItem(
                transaction: tx,
                onTap: () => onTap(tx),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
