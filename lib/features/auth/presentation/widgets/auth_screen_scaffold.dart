import 'package:flutter/material.dart';

class AuthScreenScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool scrollable;
  final EdgeInsetsGeometry horizontalPadding;
  final bool dismissKeyboardOnTap;

  const AuthScreenScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.scrollable = true,
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 24),
    this.dismissKeyboardOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = scrollable
        ? SingleChildScrollView(
            padding: horizontalPadding,
            child: child,
          )
        : Padding(
            padding: horizontalPadding,
            child: child,
          );

    final body = SafeArea(child: content);

    final scaffold = Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: appBar,
      body: body,
    );

    if (!dismissKeyboardOnTap) return scaffold;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: scaffold,
    );
  }
}
