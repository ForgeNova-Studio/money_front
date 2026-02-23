import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/viewmodels/shortcuts_guide_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// Step 3: 단축어 설치 화면
class StepInstallShortcut extends ConsumerWidget {
  const StepInstallShortcut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shortcutsGuideViewModelProvider);
    final selectedCard = state.selectedCardCompany;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            '일반 단축어를 설치하세요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '아래 링크를 통해 단축어를 설치해주세요',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // 단축어 설명 안내
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.appColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '아래 단축어는 카드 결제 문자(SMS)를 자동으로 인식해\n결제 내역을 빠르게 등록하는 데 사용됩니다.',
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '메시지 내용은 기기 내에서만 처리되며, 외부로 저장되거나 전송되지 않습니다',
                        style: TextStyle(
                          color: context.appColors.textPrimary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.appColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '설치 버튼을 누른 후, \'다음\'을 눌러 계속 진행하세요',
                        style: TextStyle(
                          color: context.appColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 일반 단축어 섹션
          if (selectedCard != null)
            _ShortcutInstallCard(
              icon: Icons.build_outlined,
              title: '${selectedCard.name} 단축어',
              description: 'SMS 문자를 파싱하여 가계부에 전달하는 단축어',
              url: selectedCard.shortcutUrl,
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// 일반 단축어 설치 카드
// ──────────────────────────────────────────────────────

class _ShortcutInstallCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _ShortcutInstallCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });

  Future<void> _openShortcutUrl() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: context.appColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _openShortcutUrl,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('설치'),
          ),
        ],
      ),
    );
  }
}
