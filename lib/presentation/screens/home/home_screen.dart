import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/presentation/widgets/home/custom_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
      ),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomCalendar()),
    );
  }
}
