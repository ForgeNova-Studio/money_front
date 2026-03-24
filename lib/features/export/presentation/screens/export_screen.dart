import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/export/presentation/viewmodels/export_view_model.dart';
import 'package:moamoa/features/export/presentation/widgets/month_range_picker.dart';

/// 데이터 내보내기 화면
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;
    final exportState = ref.watch(exportViewModelProvider);
    final accountBooksAsync = ref.watch(accountBooksProvider);
    final selectedIdAsync = ref.watch(selectedAccountBookViewModelProvider);

    // 선택된 가계부 정보 찾기
    final selectedId = selectedIdAsync.asData?.value;
    final accountBooks = accountBooksAsync.asData?.value ?? [];
    final selectedBook = accountBooks.isEmpty
        ? null
        : accountBooks.firstWhere(
            (b) => b.accountBookId == selectedId,
            orElse: () => accountBooks.first,
          );

    return DefaultLayout(
      title: '데이터 내보내기',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // 1. 가계부 선택
            _SectionHeader(icon: Icons.book_outlined, label: '가계부'),
            const SizedBox(height: 10),
            _AccountBookSelector(
              accountBooks: accountBooks,
              selectedBook: selectedBook,
              onChanged: (book) {
                ref
                    .read(selectedAccountBookViewModelProvider.notifier)
                    .setSelectedAccountBookId(book.accountBookId);
              },
            ),
            const SizedBox(height: 28),

            // 2. 내보내기 기간
            _SectionHeader(icon: Icons.calendar_month_outlined, label: '내보내기 기간'),
            const SizedBox(height: 10),
            MonthRangePicker(
              startDate: exportState.startDate,
              endDate: exportState.endDate,
              onStartChanged: (date) {
                ref
                    .read(exportViewModelProvider.notifier)
                    .setStartDate(date.year, date.month);
              },
              onEndChanged: (date) {
                ref
                    .read(exportViewModelProvider.notifier)
                    .setEndDate(date.year, date.month);
              },
            ),
            const SizedBox(height: 8),
            if (exportState.monthCount > 12)
              Text(
                '최대 12개월까지 선택 가능합니다.',
                style: TextStyle(fontSize: 13, color: appColors.error),
              )
            else
              Text(
                '${exportState.monthCount}개월 데이터를 내보냅니다.',
                style: TextStyle(fontSize: 13, color: appColors.textTertiary),
              ),
            const SizedBox(height: 28),

            // 3. 파일 형식 안내
            _SectionHeader(icon: Icons.description_outlined, label: '파일 형식'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColors.gray50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: appColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.table_chart_outlined,
                      color: appColors.primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CSV (엑셀 호환)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '엑셀, Numbers, 구글 시트에서 열 수 있습니다.',
                          style: TextStyle(
                            fontSize: 13,
                            color: appColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // 4. 내보내기 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: exportState.isExporting ||
                        exportState.monthCount > 12 ||
                        selectedBook == null
                    ? null
                    : () => _handleExport(selectedBook),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor: colorScheme.primaryContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: exportState.isExporting
                    ? _ExportingIndicator(state: exportState)
                    : const Text(
                        '내보내기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            // 5. 에러 메시지
            if (exportState.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                exportState.errorMessage!,
                style: TextStyle(fontSize: 13, color: appColors.error),
                textAlign: TextAlign.center,
              ),
            ],

            // 6. 내보내기 완료 카드
            if (exportState.filePath != null) ...[
              const SizedBox(height: 24),
              _ExportCompleteCard(
                transactionCount: exportState.transactionCount,
                onShare: () {
                  ref.read(exportViewModelProvider.notifier).share();
                },
              ),
            ],

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport(AccountBook selectedBook) async {
    final bookId = selectedBook.accountBookId;
    if (bookId == null) return;

    await ref.read(exportViewModelProvider.notifier).export(
          accountBookId: bookId,
          accountBookName: selectedBook.name,
        );

    if (!mounted) return;

    final state = ref.read(exportViewModelProvider);
    if (state.filePath != null) {
      context.showToast(
        '${state.transactionCount}건의 거래 내역을 내보냈습니다.',
      );
    } else if (state.errorMessage != null) {
      context.showErrorToast(state.errorMessage!);
    }
  }
}

/// 섹션 제목
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      children: [
        Icon(icon, size: 18, color: appColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// 가계부 선택 드롭다운
class _AccountBookSelector extends StatelessWidget {
  final List<AccountBook> accountBooks;
  final AccountBook? selectedBook;
  final ValueChanged<AccountBook> onChanged;

  const _AccountBookSelector({
    required this.accountBooks,
    required this.selectedBook,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    if (accountBooks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.gray50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '가계부가 없습니다.',
          style: TextStyle(color: appColors.textTertiary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: appColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.gray100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBook?.accountBookId,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: appColors.gray400),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: appColors.textPrimary,
          ),
          items: accountBooks.map((book) {
            return DropdownMenuItem<String>(
              value: book.accountBookId,
              child: Text(book.name),
            );
          }).toList(),
          onChanged: (id) {
            if (id == null) return;
            final book = accountBooks.firstWhere(
              (b) => b.accountBookId == id,
            );
            onChanged(book);
          },
        ),
      ),
    );
  }
}

/// 내보내기 진행 중 인디케이터
class _ExportingIndicator extends StatelessWidget {
  final ExportState state;

  const _ExportingIndicator({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${state.completedMonths}/${state.totalMonths}개월 조회 중...',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 내보내기 완료 카드
class _ExportCompleteCard extends StatelessWidget {
  final int transactionCount;
  final VoidCallback onShare;

  const _ExportCompleteCard({
    required this.transactionCount,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.success.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_rounded,
              color: appColors.success, size: 48),
          const SizedBox(height: 12),
          Text(
            '내보내기 완료!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${formatter.format(transactionCount)}건의 거래 내역이 포함되었습니다.',
            style: TextStyle(
              fontSize: 14,
              color: appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.share_rounded, size: 20),
              label: const Text(
                '공유하기',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: appColors.success,
                side: BorderSide(color: appColors.success),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
