import 'package:flutter/material.dart';

import 'package:moneyflow/core/constants/app_constants.dart';

BoxDecoration transactionFormCardDecoration(
  BuildContext context, {
  Color? backgroundColor,
  double borderRadius = 20,
}) {
  return BoxDecoration(
    color: backgroundColor ?? Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: context.appColors.shadow.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
