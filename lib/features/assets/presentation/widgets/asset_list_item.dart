import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/presentation/utils/asset_extensions.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';

/// 개별 자산 항목 위젯
class AssetListItem extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AssetListItem({
    super.key,
    required this.asset,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final category = asset.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration:
                transactionFormCardDecoration(context, borderRadius: 16),
            child: Row(
              children: [
                // 카테고리 아이콘
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // 자산 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: category.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              category.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: category.color,
                              ),
                            ),
                          ),
                          if (asset.memo != null && asset.memo!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                asset.memo!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.appColors.textTertiary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // 금액
                Text(
                  '₩${numberFormat.format(asset.amount)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
