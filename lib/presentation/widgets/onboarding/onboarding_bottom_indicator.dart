// packages
import 'package:flutter/material.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';

class OnboardingBottomIndicator extends StatelessWidget {
  const OnboardingBottomIndicator({
    super.key,
    required this.currentPage,
    required this.totalPage,
  });

  final int currentPage;
  final int totalPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPage,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentPage == index
                ? context.appColors.primaryPink
                : context.appColors.gray200,
          ),
        ),
      ),
    );
  }
}
