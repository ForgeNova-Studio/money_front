import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text('더보기'),
        backgroundColor: context.appColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '준비 중입니다.',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
      ),
    );
  }
}
