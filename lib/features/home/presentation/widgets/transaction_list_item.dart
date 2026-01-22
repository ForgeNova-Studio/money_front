import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/income/presentation/utils/income_category_utils.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  final TransactionEntity transaction;
  final VoidCallback? onTap;
  final Future<void> Function()? onDelete;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragExtent = 0;

  // 삭제 버튼이 완전히 나타나는 거리 (버튼 크기 48 + 여백)
  static const double _deleteThreshold = 72;
  // 삭제 트리거 거리 (같은 거리에서 트리거)
  static const double _triggerThreshold = 72;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = _controller.drive(Tween<double>(begin: 0, end: 0));
    _controller.addListener(() {
      setState(() => _dragExtent = _animation.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _controller.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // 왼쪽으로만 드래그 가능 (음수 방향)
    final delta = details.primaryDelta ?? 0;
    setState(() {
      _dragExtent = (_dragExtent + delta).clamp(-_triggerThreshold * 1.2, 0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    // 빠른 스와이프 시 삭제 버튼 보이는 상태로
    if (velocity < -500) {
      _animateTo(-_deleteThreshold);
      return;
    }

    // 삭제 버튼 보이는 상태로 유지할지 결정
    if (_dragExtent.abs() > _deleteThreshold / 2) {
      _animateTo(-_deleteThreshold);
    } else {
      _animateTo(0);
    }
  }

  void _animateTo(double target, {VoidCallback? onComplete}) {
    _animation = Tween<double>(
      begin: _dragExtent,
      end: target,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.duration = const Duration(milliseconds: 250);
    _controller.forward(from: 0).then((_) => onComplete?.call());
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.transaction.type == TransactionType.expense;
    final color =
        isExpense ? context.appColors.error : context.appColors.success;
    final prefix = isExpense ? '-' : '+';
    final amountStr = NumberFormat('#,###').format(widget.transaction.amount);
    final timeStr = DateFormat('HH:mm').format(widget.transaction.date);
    final categoryLabel = _resolveCategoryLabel(widget.transaction, isExpense);
    final categoryIcon = _resolveCategoryIcon(widget.transaction, isExpense);

    // 삭제 버튼 표시 비율 (0~1)
    final revealProgress =
        (_dragExtent.abs() / _deleteThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragStart: widget.onDelete != null ? _handleDragStart : null,
      onHorizontalDragUpdate:
          widget.onDelete != null ? _handleDragUpdate : null,
      onHorizontalDragEnd: widget.onDelete != null ? _handleDragEnd : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 삭제 버튼 배경
          Positioned.fill(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    context.appColors.error.withOpacity(0.1 * revealProgress),
                  ],
                ),
              ),
              child: Transform.scale(
                scale: 0.5 + (0.5 * revealProgress),
                child: Opacity(
                  opacity: revealProgress,
                  child: GestureDetector(
                    onTap: () => widget.onDelete?.call(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.appColors.error,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.appColors.error.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 메인 카드
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: context.appColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: isExpense
                              ? context.appColors.textSecondary
                              : context.appColors.success,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$timeStr · $categoryLabel',
                              style: TextStyle(
                                color: context.appColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$prefix$amountStr원',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _resolveCategoryLabel(TransactionEntity transaction, bool isExpense) {
    if (isExpense) {
      return resolveExpenseCategoryLabel(transaction.category);
    }
    return resolveIncomeCategoryLabel(transaction.category);
  }

  IconData _resolveCategoryIcon(TransactionEntity transaction, bool isExpense) {
    if (isExpense) {
      return resolveExpenseCategoryIcon(transaction.category);
    }
    return resolveIncomeCategoryIcon(transaction.category);
  }
}
