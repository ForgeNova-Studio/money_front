import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class AssetScreen extends StatelessWidget {
  const AssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '자산',
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
          '자산 스크린',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
      ),
    );
  }
}
