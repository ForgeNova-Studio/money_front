import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/presentation/widgets/home/custom_calendar.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';
import 'package:moneyflow/features/auth/presentation/providers/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // 로그아웃 확인 다이얼로그
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

    if (shouldLogout == true && context.mounted) {
      try {
        // 로그아웃 실행
        await ref.read(authViewModelProvider.notifier).logout();

        if (context.mounted) {
          // 로그인 화면으로 이동 (스택 초기화)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그아웃 실패: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MoneyFlow',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: () => _handleLogout(context, ref),
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomCalendar()),
    );
  }
}
