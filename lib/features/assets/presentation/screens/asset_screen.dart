import 'package:flutter/material.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

class AssetScreen extends StatelessWidget {
  const AssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultLayout(
      title: '자산',
      automaticallyImplyLeading: false,
      child: Center(
        child: Text(
          '자산 스크린',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      ),
    );
  }
}
