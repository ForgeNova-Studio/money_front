import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/router/route_names.dart';

import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('로그아웃'),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        try {
          await ref.read(authViewModelProvider.notifier).logout();
          // GoRouter의 redirect 로직이 자동으로 로그인 화면으로 이동시킴
          context.go(RouteNames.login);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그아웃 실패: $e')),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '더보기',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.appColors.backgroundLight,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: context.appColors.textSecondary),
            onPressed: () => handleLogout(context, ref),
            tooltip: '로그아웃',
          ),
          IconButton(
            icon: Icon(Icons.settings, color: context.appColors.textPrimary),
            onPressed: () {
              // TODO: 세팅 화면으로 이동 구현 예정
              debugPrint('세팅 화면으로 이동 구현 예정');
            },
          ),
        ],
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
