import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/models/card_company.dart';
import 'package:moamoa/core/services/recent_card_service.dart';

/// 카드사 선택 바텀시트
/// 최근 사용 카드사를 상단에 노출하고, 전체 카드사 그리드 표시
class CardCompanySelectorBottomSheet extends ConsumerWidget {
  const CardCompanySelectorBottomSheet({super.key});

  /// 바텀시트를 표시하고 선택된 카드사를 반환
  static Future<CardCompany?> show(BuildContext context) {
    return showModalBottomSheet<CardCompany>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CardCompanySelectorBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentCardIds = ref.watch(recentCardServiceProvider);
    final recentCards = recentCardIds
        .where((id) => supportedCardCompanies.any((c) => c.id == id))
        .map((id) => supportedCardCompanies.firstWhere((c) => c.id == id))
        .toList();

    // 최근 사용 카드사를 제외한 나머지
    final otherCards = supportedCardCompanies
        .where((c) => !recentCardIds.contains(c.id))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들 바
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.appColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // 타이틀
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: context.appColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '카드사 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '스캔할 영수증의 카드사를 선택해주세요',
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ),
            ),

            // 최근 사용 카드사 섹션
            if (recentCards.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '최근 사용',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: recentCards.map((card) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: card != recentCards.last ? 10 : 0,
                        ),
                        child: _RecentCardItem(
                          card: card,
                          onTap: () => Navigator.pop(context, card),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  color: context.appColors.gray200,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 전체 카드사 섹션 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  recentCards.isNotEmpty ? '전체 카드사' : '카드사 선택',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ),
            ),

            // 전체 카드사 그리드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: recentCards.isEmpty
                    ? supportedCardCompanies.length
                    : otherCards.length,
                itemBuilder: (context, index) {
                  final card = recentCards.isEmpty
                      ? supportedCardCompanies[index]
                      : otherCards[index];
                  return _CardCompanyGridItem(
                    card: card,
                    onTap: () => Navigator.pop(context, card),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 최근 사용 카드사 아이템 (가로 확장형)
class _RecentCardItem extends StatelessWidget {
  final CardCompany card;
  final VoidCallback onTap;

  const _RecentCardItem({
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.appColors.primary.withValues(alpha: 0.08),
              context.appColors.primary.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.appColors.primary.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.appColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  card.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              card.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.appColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// 전체 카드사 그리드 아이템
class _CardCompanyGridItem extends StatelessWidget {
  final CardCompany card;
  final VoidCallback onTap;

  const _CardCompanyGridItem({
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.gray50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.appColors.gray200,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.appColors.gray200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    card.name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.black54,
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
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
