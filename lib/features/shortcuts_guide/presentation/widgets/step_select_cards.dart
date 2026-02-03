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

          // 전체 선택/해제 버튼
          Row(
            children: [
              _SelectAllButton(
                label: '전체 선택',
                onTap: () => viewModel.selectAllCardCompanies(),
              ),
              const SizedBox(width: 12),
              _SelectAllButton(
                label: '전체 해제',
                onTap: () => viewModel.deselectAllCardCompanies(),
                isOutlined: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

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
              final isSelected =
                  state.selectedCardCompanyIds.contains(card.id);
              return _CardCompanyItem(
                card: card,
                isSelected: isSelected,
                onTap: () => viewModel.toggleCardCompany(card.id),
              );
            },
          ),

          const SizedBox(height: 24),

          // 선택된 카드 수 표시
          if (state.selectedCardCompanyIds.isNotEmpty)
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
                    '${state.selectedCardCompanyIds.length}개 카드사 선택됨',
                    style: TextStyle(
                      color: context.appColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (state.selectedCardCompanyIds.isEmpty)
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
                    '카드를 1개 이상 선택해주세요',
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

class _SelectAllButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;

  const _SelectAllButton({
    required this.label,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          side: BorderSide(color: context.appColors.gray300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: context.appColors.textSecondary,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.appColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13),
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
