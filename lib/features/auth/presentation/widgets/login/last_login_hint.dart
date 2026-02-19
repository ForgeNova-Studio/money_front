import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';

/// 마지막 로그인 방법 힌트 위젯
///
/// 사용자가 이전에 로그인했던 방법(Google, Naver, Kakao 등)을
/// 로컬 저장소에서 확인하여 힌트로 표시합니다.
///
/// **주요 기능 (Key Features):**
/// - 마지막 로그인 제공업체 정보 조회 (`lastLoginProviderProvider`)
/// - 제공업체별 한글 디스플레이 이름 매핑 (`_getProviderDisplayName`)
/// - 로그인 이력이 있을 경우 하단에 힌트 텍스트 표시
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// const LastLoginHint();
/// ```
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
