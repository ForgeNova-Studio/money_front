import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';

/// 카테고리 TOP 5 카드 (화려한 멀티컬러!)
class ReportCategoryCard extends StatelessWidget {
  final List<CategoryBreakdownEntity> categories;

  const ReportCategoryCard({super.key, required this.categories});

  // 버터 톤 색상 팔레트
  static const List<Color> _vibrantColors = [
    Color(0xFFcfa52b), // 진한 버터 (primaryDark)
    Color(0xFFe8b84a), // 따뜻한 골드
    Color(0xFFf2d35e), // 메인 버터 (primary)
    Color(0xFFd4a24a), // 앰버 골드
    Color(0xFFe0c06e), // 소프트 골드
    Color(0xFFc99832), // 다크 앰버
    Color(0xFFf0ca57), // 밝은 버터
    Color(0xFFd9ad45), // 미드 골드
  ];

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowAccent,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '📊',
              style: TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '어디에 가장 많이 썼을까요?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 카테고리 리스트
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final category = categories[index];
                final color = _vibrantColors[index % _vibrantColors.length];
                final categoryName =
                    resolveExpenseCategoryLabel(category.category);
                final categoryIcon =
                    resolveExpenseCategoryIcon(category.category);

                return _buildCategoryItem(
                  rank: index + 1,
                  icon: categoryIcon,
                  name: categoryName,
                  amount: category.amount,
                  percentage: category.percentage,
                  color: color,
                  formatter: formatter,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required int rank,
    required IconData icon,
    required String name,
    required int amount,
    required int percentage,
    required Color color,
    required NumberFormat formatter,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: percentage / 100),
      duration: Duration(milliseconds: 800 + (rank * 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 순위 뱃지
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // 아이콘 + 이름
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),

                const Spacer(),

                // 금액
                Text(
                  '₩${formatter.format(amount)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),

                // 퍼센트
                Text(
                  '($percentage%)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 프로그레스 바
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        );
      },
    );
  }
}
