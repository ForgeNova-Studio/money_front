import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/viewmodels/shortcuts_guide_view_model.dart';

/// Step 2: 카드사 선택 화면
class StepSelectCards extends ConsumerWidget {
  const StepSelectCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shortcutsGuideViewModelProvider);
    final viewModel = ref.read(shortcutsGuideViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            '사용하는 카드를 선택하세요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '선택한 카드사의 결제 문자를 자동으로 인식합니다',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // 카드사 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: supportedCardCompanies.length,
            itemBuilder: (context, index) {
              final card = supportedCardCompanies[index];
              final isSelected = state.selectedCardCompanyId == card.id;
              return _CardCompanyItem(
                card: card,
                isSelected: isSelected,
                onTap: () => viewModel.selectCardCompany(card.id),
              );
            },
          ),

          const SizedBox(height: 24),

          // 선택된 카드 표시
          if (state.selectedCardCompany != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: context.appColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${state.selectedCardCompany!.name} 선택됨',
                    style: TextStyle(
                      color: context.appColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (state.selectedCardCompanyId == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.appColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '사용하는 카드를 선택해주세요',
                    style: TextStyle(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CardCompanyItem extends StatelessWidget {
  final CardCompany card;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardCompanyItem({
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.primary.withValues(alpha: 0.1)
              : context.appColors.gray50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? context.appColors.primary
                : context.appColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // 카드사 아이콘과 이름
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 아이콘 플레이스홀더 (실제 아이콘이 없으므로 이니셜 표시)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.appColors.primary
                          : context.appColors.gray200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        card.name.substring(0, 1),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? context.appColors.primary
                          : context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // 체크 표시
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.appColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
