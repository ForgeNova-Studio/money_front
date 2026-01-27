import 'package:flutter/material.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultLayout(
      title: '분석',
      automaticallyImplyLeading: false,
      child: Center(
        child: Text(
          '분석 스크린',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      ),
    );
  }
}
