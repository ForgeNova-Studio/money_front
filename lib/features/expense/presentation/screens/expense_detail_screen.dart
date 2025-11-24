import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/color_constants.dart';
import '../../domain/entities/expense_model.dart';
import '../providers/expense_provider.dart';
import 'edit_expense_screen.dart';

/// 지출 상세 화면
///
/// 기능:
/// - 지출 상세 정보 표시
/// - 수정 버튼 (EditExpenseScreen으로 이동)
/// - 삭제 버튼 (확인 다이얼로그 표시)
class ExpenseDetailScreen extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseDetailScreen({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('지출 상세'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          // 수정 버튼
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
            tooltip: '수정',
          ),
          // 삭제 버튼
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: '삭제',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 금액 헤더
            _buildAmountHeader(),

            const SizedBox(height: 8),

            // 상세 정보 카드
            _buildDetailCard(context),
          ],
        ),
      ),
    );
  }

  /// 금액 헤더 위젯
  /// 큰 금액과 날짜를 표시
  Widget _buildAmountHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 금액
          Text(
            '${NumberFormat('#,###').format(expense.amount)}원',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // 날짜
          Text(
            DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(expense.date),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// 상세 정보 카드
  Widget _buildDetailCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리
            _buildDetailRow(
              icon: _getCategoryIcon(expense.category),
              iconColor: AppColors.primary,
              label: '카테고리',
              value: _getCategoryName(expense.category),
            ),
            const Divider(height: 32),

            // 가맹점
            if (expense.merchant != null && expense.merchant!.isNotEmpty)
              _buildDetailRow(
                icon: Icons.store,
                iconColor: AppColors.secondary,
                label: '가맹점',
                value: expense.merchant!,
              ),
            if (expense.merchant != null && expense.merchant!.isNotEmpty)
              const Divider(height: 32),

            // 결제 수단
            if (expense.paymentMethod != null)
              _buildDetailRow(
                icon: Icons.payment,
                iconColor: AppColors.info,
                label: '결제 수단',
                value: _getPaymentMethodName(expense.paymentMethod!),
              ),
            if (expense.paymentMethod != null) const Divider(height: 32),

            // 메모
            if (expense.memo != null && expense.memo!.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '메모',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          expense.memo!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
            ],

            // 자동 분류 여부
            if (expense.isAutoCategorized)
              _buildDetailRow(
                icon: Icons.auto_awesome,
                iconColor: AppColors.success,
                label: '분류 방식',
                value: 'AI 자동 분류',
              ),
            if (expense.isAutoCategorized) const Divider(height: 32),

            // 등록일시
            _buildDetailRow(
              icon: Icons.access_time,
              iconColor: AppColors.textSecondary,
              label: '등록일시',
              value: DateFormat('yyyy.MM.dd HH:mm').format(expense.createdAt!),
            ),

            // 수정일시 (등록일시와 다른 경우만 표시)
            if (expense.updatedAt != null &&
                expense.createdAt != expense.updatedAt) ...[
              const Divider(height: 32),
              _buildDetailRow(
                icon: Icons.update,
                iconColor: AppColors.textSecondary,
                label: '수정일시',
                value:
                    DateFormat('yyyy.MM.dd HH:mm').format(expense.updatedAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 상세 정보 행 위젯
  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 수정 화면으로 이동
  Future<void> _navigateToEdit(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditExpenseScreen(expense: expense),
      ),
    );

    // 수정이 완료되면 이전 화면으로 돌아감
    if (result == true && context.mounted) {
      Navigator.of(context).pop(true); // 목록 화면에 새로고침 신호
    }
  }

  /// 삭제 확인 다이얼로그 표시
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지출 삭제'),
        content: const Text('이 지출 내역을 삭제하시겠습니까?\n삭제된 내역은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    // 삭제 확인 시
    if (confirmed == true && context.mounted) {
      await _deleteExpense(context);
    }
  }

  /// 지출 삭제 처리
  Future<void> _deleteExpense(BuildContext context) async {
    final expenseProvider = context.read<ExpenseProvider>();

    try {
      // 삭제 요청
      await expenseProvider.deleteExpense(expense.expenseId!);

      if (context.mounted) {
        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('지출이 삭제되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );

        // 이전 화면으로 돌아감 (목록 새로고침 신호 전달)
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        // 오류 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(expenseProvider.errorMessage ?? '삭제에 실패했습니다'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// 카테고리 코드를 아이콘으로 변환
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'FOOD':
        return Icons.restaurant;
      case 'TRANSPORT':
        return Icons.directions_car;
      case 'SHOPPING':
        return Icons.shopping_bag;
      case 'CULTURE':
        return Icons.movie;
      case 'HOUSING':
        return Icons.home;
      case 'MEDICAL':
        return Icons.local_hospital;
      case 'EDUCATION':
        return Icons.school;
      case 'EVENT':
        return Icons.card_giftcard;
      default:
        return Icons.more_horiz;
    }
  }

  /// 카테고리 코드를 이름으로 변환
  String _getCategoryName(String category) {
    switch (category) {
      case 'FOOD':
        return '식비';
      case 'TRANSPORT':
        return '교통';
      case 'SHOPPING':
        return '쇼핑';
      case 'CULTURE':
        return '문화생활';
      case 'HOUSING':
        return '주거/통신';
      case 'MEDICAL':
        return '의료/건강';
      case 'EDUCATION':
        return '교육';
      case 'EVENT':
        return '경조사';
      default:
        return '기타';
    }
  }

  /// 결제 수단 코드를 이름으로 변환
  String _getPaymentMethodName(String paymentMethod) {
    switch (paymentMethod) {
      case 'CARD':
        return '카드';
      case 'CASH':
        return '현금';
      case 'TRANSFER':
        return '계좌이체';
      default:
        return paymentMethod;
    }
  }
}
