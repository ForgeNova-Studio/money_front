import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/sms_import/presentation/viewmodels/pending_expenses_view_model.dart';
import 'package:moamoa/features/sms_import/presentation/widgets/pending_expense_list_item.dart';
import 'package:moamoa/router/route_names.dart';

/// 대기 중인 지출 검토 화면
class PendingExpensesReviewScreen extends ConsumerWidget {
  const PendingExpensesReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingExpensesViewModelProvider);
    final viewModel = ref.read(pendingExpensesViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final numberFormat = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '대기 중인 지출',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (state.hasPendingExpenses)
            TextButton(
              onPressed: () => _showClearAllDialog(context, viewModel),
              child: Text(
                '전체 삭제',
                style: TextStyle(
                  color: context.appColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: state.pendingExpenses.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                // 요약 헤더
                _buildSummaryHeader(
                    context, state.count, state.totalAmount, numberFormat),

                // 대기 목록
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: state.pendingExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = state.pendingExpenses[index];
                      return PendingExpenseListItem(
                        expense: expense,
                        onCategoryChanged: (category) {
                          viewModel.updatePendingExpense(
                            id: expense.id,
                            category: category,
                          );
                        },
                        onMemoChanged: (memo) {
                          viewModel.updatePendingExpense(
                            id: expense.id,
                            memo: memo,
                          );
                        },
                        onMerchantChanged: (merchant) {
                          viewModel.updatePendingExpense(
                            id: expense.id,
                            merchant: merchant,
                          );
                        },
                        onDelete: () {
                          viewModel.removePendingExpense(expense.id);
                        },
                      );
                    },
                  ),
                ),

                // 하단 저장 버튼
                _buildBottomButton(context, ref, state.isSaving, state.count),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.appColors.primaryPale,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: context.appColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '대기 중인 지출이 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SMS로 받은 지출 내역이 여기에 표시됩니다',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              '돌아가기',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.appColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(
    BuildContext context,
    int count,
    int totalAmount,
    NumberFormat numberFormat,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: context.appColors.softGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '총 $count건',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appColors.textPrimary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${numberFormat.format(totalAmount)}원',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: context.appColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '저장 대기 중',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    WidgetRef ref,
    bool isSaving,
    int count,
  ) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isSaving
                ? null
                : () async {
                    final viewModel =
                        ref.read(pendingExpensesViewModelProvider.notifier);
                    await viewModel.saveAllPendingExpenses();

                    if (context.mounted) {
                      // 저장 후 홈 데이터 갱신
                      ref.read(homeViewModelProvider.notifier).fetchMonthlyData(
                            DateTime.now(),
                            forceRefresh: true,
                          );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$count건의 지출이 저장되었습니다'),
                          backgroundColor: context.appColors.success,
                        ),
                      );
                      context.go(RouteNames.home);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.primary,
              foregroundColor: context.appColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: isSaving
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.appColors.textPrimary,
                      ),
                    ),
                  )
                : Text(
                    '모두 저장하기 ($count건)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(
      BuildContext context, PendingExpensesViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 삭제'),
        content: const Text('대기 중인 모든 지출을 삭제할까요?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              viewModel.clearAll();
              Navigator.pop(context);
            },
            child: Text(
              '삭제',
              style: TextStyle(color: context.appColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
