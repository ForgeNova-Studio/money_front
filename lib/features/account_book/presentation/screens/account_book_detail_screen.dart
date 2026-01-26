// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// entities
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';

// providers
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

class AccountBookDetailScreen extends ConsumerWidget {
  final String accountBookId;

  const AccountBookDetailScreen({
    super.key,
    required this.accountBookId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final accountBookAsync =
        ref.watch(accountBookDetailProvider(accountBookId));
    final selectedAccountBookId =
        ref.watch(selectedAccountBookViewModelProvider).asData?.value;
    final isCurrent = accountBookId == selectedAccountBookId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '가계부 상세',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        actions: [
          // TODO: Owner인 경우 수정/삭제 버튼 표시
          IconButton(
            icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('수정 기능 준비 중입니다.')),
              );
            },
          ),
        ],
      ),
      body: accountBookAsync.when(
        data: (accountBook) => _buildBody(context, ref, accountBook, isCurrent),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('가계부 정보를 불러오는데 실패했습니다: $error'),
        ),
      ),
      bottomNavigationBar: accountBookAsync.asData?.value != null
          ? _buildBottomButton(
              context, ref, accountBookAsync.asData!.value, isCurrent)
          : null,
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref,
      AccountBook accountBook, bool isCurrent) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('yyyy.MM.dd');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  accountBook.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (accountBook.description != null &&
                    accountBook.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    accountBook.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Info Cards
          _buildInfoSection(context, '기본 정보', [
            _buildInfoRow(context, '유형', accountBook.bookType.label),
            _buildInfoRow(
                context, '멤버', '${accountBook.memberCount}명'), // TODO: 실제 멤버 조회
            _buildInfoRow(
                context, '상태', accountBook.isActive != false ? '사용 중' : '비활성'),
          ]),
          const SizedBox(height: 16),
          _buildInfoSection(context, '기간', [
            _buildInfoRow(
              context,
              '시작일',
              accountBook.startDate != null
                  ? dateFormat.format(accountBook.startDate!)
                  : '-',
            ),
            _buildInfoRow(
              context,
              '종료일',
              accountBook.endDate != null
                  ? dateFormat.format(accountBook.endDate!)
                  : '-',
            ),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, String title, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, WidgetRef ref,
      AccountBook accountBook, bool isCurrent) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isCurrent
                ? null
                : () async {
                    await ref
                        .read(selectedAccountBookViewModelProvider.notifier)
                        .setSelectedAccountBookId(accountBook.accountBookId);

                    // 홈 데이터 갱신
                    await ref
                        .read(homeViewModelProvider.notifier)
                        .fetchMonthlyData(DateTime.now(), forceRefresh: true);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('가계부가 전환되었습니다.')),
                      );
                      context.pop(); // 목록으로 돌아가기 (또는 리스트에서 갱신됨)
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.surfaceContainerHighest,
              disabledForegroundColor: colorScheme.onSurface.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              isCurrent ? '현재 사용 중인 가계부입니다' : '이 가계부 사용하기',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
