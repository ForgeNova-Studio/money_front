import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moamoa/features/common/providers/ui_overlay_providers.dart';
import 'package:moamoa/features/sms_import/data/services/deep_link_service.dart';
import 'package:moamoa/features/sms_import/presentation/viewmodels/sms_import_view_model.dart';
import 'package:moamoa/router/route_names.dart';

class AppShell extends HookConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isScrimActive = ref.watch(appScrimActiveProvider);

    // 딥링크 수신 시 SMS 파싱 후 대기 지출 검토 화면으로 이동
    ref.listen(deepLinkServiceProvider, (previous, next) {
      if (next != null) {
        final data = ref.read(deepLinkServiceProvider.notifier).consume();
        if (data != null) {
          if (kDebugMode) {
            debugPrint('[AppShell] 딥링크 수신: $data');
          }
          final smsVm = ref.read(smsImportViewModelProvider.notifier);
          smsVm.parseFromDeepLink(
            cardCompanyId: data.cardCompanyId,
            smsText: data.smsText,
          );
          smsVm.addToPending();

          // 이미 smsImport 화면이 열려있으면 중복 push 방지
          final currentPath =
              GoRouter.of(context).routeInformationProvider.value.uri.path;
          if (currentPath != RouteNames.smsImport) {
            context.push(RouteNames.smsImport);
          }
        }
      }
    });

    // 앱 쉘이 처음 로드될 때 대기 중인 딥링크가 있는지 확인
    // (로그인 전이나 앱 시작 시 받은 딥링크 처리용)
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 현재 라우트 확인
        final currentPath =
            GoRouter.of(context).routeInformationProvider.value.uri.path;

        // 이미 SMS Import 화면이면 무시 (중복 실행 방지)
        if (currentPath == RouteNames.smsImport) return;

        final pendingLink =
            ref.read(deepLinkServiceProvider.notifier).consume();
        if (pendingLink != null) {
          if (kDebugMode) {
            debugPrint('[AppShell] 초기 대기 딥링크 처리: $pendingLink');
          }
          final smsVm = ref.read(smsImportViewModelProvider.notifier);
          smsVm.parseFromDeepLink(
            cardCompanyId: pendingLink.cardCompanyId,
            smsText: pendingLink.smsText,
          );
          smsVm.addToPending();
          context.push(RouteNames.smsImport);
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            backgroundColor: colorScheme.surface,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline),
                label: '분석',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: '자산',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: '더보기',
              ),
            ],
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !isScrimActive,
              child: AnimatedOpacity(
                opacity: isScrimActive ? 1 : 0,
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                child: Container(
                  color: colorScheme.scrim.withOpacity(0.06),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
