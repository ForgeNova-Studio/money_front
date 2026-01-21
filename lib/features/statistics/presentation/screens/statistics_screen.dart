import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '분석',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.appColors.backgroundLight,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          '개발 중..',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
      ),
    );
  }
}
