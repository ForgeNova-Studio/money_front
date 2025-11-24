import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

class OnboardingBottomIndicator extends StatelessWidget {
  const OnboardingBottomIndicator(
      {super.key, required this.currentPage, required this.totalPage});

  final int currentPage;
  final int totalPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPage,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentPage == index
                ? AppColors.primaryPink
                : AppColors.gray200,
          ),
        ),
      ),
    );
  }
}
