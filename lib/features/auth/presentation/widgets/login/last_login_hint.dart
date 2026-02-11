import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';

// 마지막 로그인 방법 힌트 위젯
class LastLoginHint extends ConsumerWidget {
  const LastLoginHint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastLoginAsync = ref.watch(lastLoginProviderProvider);

    return lastLoginAsync.when(
      data: (provider) {
        if (provider == null) return const SizedBox.shrink();

        final providerName = _getProviderDisplayName(provider);
        if (providerName == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                '지난번에 $providerName로 로그인했어요',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  // 로그인 방법 표시 이름
  String? _getProviderDisplayName(String provider) {
    switch (provider.toUpperCase()) {
      case 'GOOGLE':
        return 'Google';
      case 'APPLE':
        return 'Apple';
      case 'NAVER':
        return '네이버';
      case 'KAKAO':
        return '카카오';
      case 'EMAIL':
        return '모아모아 Email';
      default:
        return null;
    }
  }
}
