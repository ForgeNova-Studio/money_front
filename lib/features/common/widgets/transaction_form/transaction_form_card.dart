import 'package:flutter/material.dart';

import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';

class TransactionFormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;

  const TransactionFormCard({
    super.key,
    required this.child,
    required this.padding,
    this.backgroundColor,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: transactionFormCardDecoration(
        context,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
