import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';
import 'package:moamoa/features/monthly_report/presentation/providers/monthly_report_providers.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/report_budget_card.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/report_category_card.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/report_intro_card.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/report_outro_card.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/report_summary_card.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/report_top_expenses_card.dart';
import 'package:moamoa/features/common/widgets/error_state_widget.dart';

/// 월간 리포트 화면
class MonthlyReportScreen extends ConsumerStatefulWidget {
  final int year;
  final int month;

  const MonthlyReportScreen({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  ConsumerState<MonthlyReportScreen> createState() =>
      _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends ConsumerState<MonthlyReportScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedAccountBookState =
        ref.watch(selectedAccountBookViewModelProvider);
    final accountBookId = selectedAccountBookState.asData?.value;

    if (accountBookId == null) {
      return const Scaffold(
        body: Center(child: Text('가계부를 선택해주세요')),
      );
    }

    final reportAsync = ref.watch(
      monthlyReportProvider(
        accountBookId: accountBookId,
        year: widget.year,
        month: widget.month,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundAccentTint,
      body: SafeArea(
        child: reportAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => ErrorStateWidget(
            error: error,
            onRetry: () => ref.invalidate(
              monthlyReportProvider(
                accountBookId: accountBookId,
                year: widget.year,
                month: widget.month,
              ),
            ),
          ),
          data: (report) => _buildReportContent(report),
        ),
      ),
    );
  }

  Widget _buildReportContent(MonthlyReportEntity report) {
    final cards = _buildCards(report);

    return Column(
      children: [
        // 상단 바 (닫기 버튼 + 인디케이터)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: AppColors.textPrimary),
              ),
              Expanded(
                child: _buildPageIndicator(cards.length),
              ),
              const SizedBox(width: 48), // 좌우 균형
            ],
          ),
        ),

        // 카드 PageView
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: cards.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20),
              child: cards[index],
            ),
          ),
        ),

        // 하단 네비게이션
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                TextButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Text('이전'),
                )
              else
                const SizedBox(width: 80),
              if (_currentPage < cards.length - 1)
                ElevatedButton(
                  onPressed: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Text('다음'),
                )
              else
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('완료'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCards(MonthlyReportEntity report) {
    return [
      ReportIntroCard(year: widget.year, month: widget.month),
      ReportSummaryCard(report: report),
      ReportCategoryCard(categories: report.categoryBreakdown),
      ReportTopExpensesCard(expenses: report.topExpenses),
      if (report.budget != null) ReportBudgetCard(budget: report.budget!),
      ReportOutroCard(report: report),
    ];
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
