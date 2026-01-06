import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('더보기'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '준비 중입니다.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
