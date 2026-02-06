import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';
import 'package:moamoa/features/assets/presentation/utils/asset_extensions.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';

/// 자산 구성 막대 그래프
class AssetBarChart extends StatelessWidget {
  final List<CategoryBreakdown> breakdowns;

  const AssetBarChart({
    super.key,
    required this.breakdowns,
  });

  @override
  Widget build(BuildContext context) {
    if (breakdowns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: transactionFormCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Icon(
                Icons.pie_chart_outline,
                color: context.appColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '자산 구성',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 막대 그래프들
          ...breakdowns.map((breakdown) => _BarItem(breakdown: breakdown)),
        ],
      ),
    );
  }
}

class _BarItem extends StatefulWidget {
  final CategoryBreakdown breakdown;

  const _BarItem({required this.breakdown});

  @override
  State<_BarItem> createState() => _BarItemState();
}

class _BarItemState extends State<_BarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.breakdown.percent / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.breakdown.category;
    final numberFormat = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // 라벨 행
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category.icon,
                  size: 16,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.appColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '₩${numberFormat.format(widget.breakdown.amount)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.breakdown.percent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: category.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 프로그레스 바
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.appColors.backgroundGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * _animation.value,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            category.color.withValues(alpha: 0.7),
                            category.color,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
