import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/widgets/animated_amount_text.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_empty_state.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_list_item.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_modal_header.dart';
import 'package:moamoa/router/route_names.dart';

/// 선택된 날짜의 거래 내역을 리스트로 표시하는 섹션 위젯
///
/// 월간 데이터에서 선택된 날짜의 거래 내역을 추출하여 표시하며,
/// 모달/일반 모드에 따라 다른 헤더를 렌더링합니다.
///
/// 주요 기능:
/// - 선택 날짜의 수입/지출 내역 리스트 표시
/// - 모달/일반 모드에 따른 헤더 분기
/// - 로딩/에러/빈 상태 처리
/// - 스와이프 삭제 지원
///
/// 파라미터:
/// - [monthlyData]: 월간 거래 데이터 (AsyncValue)
/// - [selectedDate]: 현재 선택된 날짜
/// - [isModal]: 모달 표시 여부 (기본값: false)
/// - [onDelete]: 삭제 콜백 (true 반환 시 삭제, false 시 스와이프 원복)
/// - [onRevealActiveChanged]: 스와이프 상태 변경 콜백
///
/// 사용 예시:
/// ```dart
/// TransactionListSection(
///   monthlyData: monthlyDataAsync,
///   selectedDate: DateTime.now(),
///   isModal: false,
///   onDelete: (tx) async => await handleDelete(tx),
/// )
/// ```
class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required this.monthlyData,
    required this.selectedDate,
    this.isModal = false,
    this.onCameraTap,
    this.onDelete,
    this.onRevealActiveChanged,
  });

  final AsyncValue<Map<String, DailyTransactionSummary>> monthlyData;
  final DateTime selectedDate;
  final bool isModal;
  final VoidCallback? onCameraTap;
  final Future<bool> Function(TransactionEntity transaction)? onDelete;
  final ValueChanged<bool>? onRevealActiveChanged;

  @override
  Widget build(BuildContext context) {
    return monthlyData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: _CenteredLoadingIndicator(),
      ),
      error: (error, stack) => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('데이터를 불러오는데 실패했습니다.')),
      ),
      data: (data) {
        final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
        final summary = data[dateKey];
        final transactions = summary?.transactions ?? [];
        final totalAmount =
            (summary?.totalIncome ?? 0) - (summary?.totalExpense ?? 0);
        final hasData = transactions.isNotEmpty;

        return Column(
          children: [
            if (isModal)
              TransactionModalHeader(
                selectedDate: selectedDate,
                totalAmount: totalAmount,
                totalIncome: summary?.totalIncome ?? 0,
                totalExpense: summary?.totalExpense ?? 0,
                onCameraTap: onCameraTap,
              )
            else
              _buildHeader(context, selectedDate, totalAmount),
            if (!hasData)
              TransactionEmptyState(selectedDate: selectedDate)
            else
              _buildListView(transactions, dateKey),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DateTime date,
    int totalAmount,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${date.month}월 ${date.day}일',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.appColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '전체 ',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedAmountText(
                  amount: totalAmount,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<TransactionEntity> transactions, String dateKey) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return TransactionListItem(
          key: ValueKey(tx.id.isNotEmpty ? tx.id : 'tx_${dateKey}_$index'),
          transaction: tx,
          onTap: tx.id.isEmpty
              ? null
              : () {
                  if (tx.type == TransactionType.expense) {
                    context.push(RouteNames.editExpense(tx.id));
                  } else {
                    context.push(RouteNames.editIncome(tx.id));
                  }
                },
          onDelete: tx.id.isEmpty || onDelete == null
              ? null
              : () async => await onDelete!(tx),
          onRevealActiveChanged: onRevealActiveChanged,
        );
      },
    );
  }
}

/// 중앙 정렬된 로딩 인디케이터 위젯
///
/// 화면 높이의 30%를 차지하는 영역에 원형 프로그레스 인디케이터를 표시합니다.
class _CenteredLoadingIndicator extends StatelessWidget {
  const _CenteredLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.3;
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
