import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/income_model.dart';
import '../providers/income_provider.dart';
import 'edit_income_screen.dart';

/// 수입 상세 화면
///
/// 기능:
/// - 수입 상세 정보 표시
/// - 수정 버튼 (EditIncomeScreen으로 이동)
/// - 삭제 버튼 (확인 다이얼로그 표시)
class IncomeDetailScreen extends StatelessWidget {
  final IncomeModel income;

  const IncomeDetailScreen({
    super.key,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('수입 상세'),
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
        gradient: LinearGradient(
          colors: [AppColors.income, AppColors.income.withValues(alpha: 0.7)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 금액
          Text(
            '${NumberFormat('#,###').format(income.amount)}원',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // 날짜
          Text(
            DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(income.date),
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
            // 수입 출처
            _buildDetailRow(
              icon: _getSourceIcon(income.source),
              iconColor: AppColors.income,
              label: '수입 출처',
              value: income.source,
            ),
            const Divider(height: 32),

            // 설명
            if (income.description != null &&
                income.description!.isNotEmpty) ...[
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
                          '설명',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          income.description!,
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

            // 등록일시
            _buildDetailRow(
              icon: Icons.access_time,
              iconColor: AppColors.textSecondary,
              label: '등록일시',
              value: DateFormat('yyyy.MM.dd HH:mm').format(income.createdAt!),
            ),

            // 수정일시 (등록일시와 다른 경우만 표시)
            if (income.updatedAt != null &&
                income.createdAt != income.updatedAt) ...[
              const Divider(height: 32),
              _buildDetailRow(
                icon: Icons.update,
                iconColor: AppColors.textSecondary,
                label: '수정일시',
                value: DateFormat('yyyy.MM.dd HH:mm').format(income.updatedAt!),
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
        builder: (_) => EditIncomeScreen(income: income),
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
        title: const Text('수입 삭제'),
        content: const Text('이 수입 내역을 삭제하시겠습니까?\n삭제된 내역은 복구할 수 없습니다.'),
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
      await _deleteIncome(context);
    }
  }

  /// 수입 삭제 처리
  Future<void> _deleteIncome(BuildContext context) async {
    final incomeProvider = context.read<IncomeProvider>();

    try {
      // 삭제 요청
      await incomeProvider.deleteIncome(income.incomeId!);

      if (context.mounted) {
        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('수입이 삭제되었습니다'),
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
            content: Text(incomeProvider.errorMessage ?? '삭제에 실패했습니다'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// 수입 출처를 아이콘으로 변환
  IconData _getSourceIcon(String source) {
    switch (source) {
      case '급여':
        return Icons.work;
      case '부수입':
        return Icons.attach_money;
      case '상여금':
        return Icons.card_giftcard;
      case '투자수익':
        return Icons.trending_up;
      default:
        return Icons.more_horiz;
    }
  }
}
