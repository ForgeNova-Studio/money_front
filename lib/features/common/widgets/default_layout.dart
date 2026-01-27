import 'package:flutter/material.dart';

/// 앱의 기본 레이아웃을 정의하는 래퍼 위젯
/// - 모든 화면에서 공통적으로 사용하는 Scaffold 설정을 관리합니다.
/// - 배경색, AppBar 스타일 등을 통일성 있게 적용할 수 있습니다.
/// - PopScope 지원으로 뒤로가기 동작을 제어할 수 있습니다.
class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? titleWidget; // 커스텀 타이틀 위젯 (title보다 우선순위 높음)
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool? centerTitle;
  final double? titleSpacing;
  final bool automaticallyImplyLeading;

  // PopScope 관련 파라미터
  final bool canPop;
  final void Function(bool didPop, dynamic result)? onPopInvokedWithResult;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.centerTitle,
    this.titleSpacing,
    this.automaticallyImplyLeading = true,
    this.canPop = true,
    this.onPopInvokedWithResult,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: renderAppBar(context),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );

    // PopScope가 필요한 경우에만 감싸기
    if (!canPop || onPopInvokedWithResult != null) {
      return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: scaffold,
      );
    }

    return scaffold;
  }

  AppBar? renderAppBar(BuildContext context) {
    if (title == null &&
        titleWidget == null &&
        actions == null &&
        leading == null) {
      return null;
    }

    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: centerTitle, // Theme의 기본값 사용 또는 오버라이드
      titleSpacing: titleSpacing, // Theme의 기본값 사용 또는 오버라이드
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              : null),
      actions: actions,
      leading: leading,
    );
  }
}
