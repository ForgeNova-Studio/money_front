import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_list_item.dart';

/// 자산 카테고리별 목록
class AssetCategoryList extends StatelessWidget {
  final List<Asset> assets;
  final ValueChanged<Asset>? onAssetTap;
  final ValueChanged<String>? onAssetDelete;

  const AssetCategoryList({
    super.key,
    required this.assets,
    this.onAssetTap,
    this.onAssetDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return _buildEmptyState(context);
    }

    // 카테고리별로 그룹핑
    final Map<AssetCategory, List<Asset>> groupedAssets = {};
    for (final asset in assets) {
      groupedAssets[asset.category] = [
        ...?groupedAssets[asset.category],
        asset,
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.list_alt,
                color: context.appColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '내 자산 목록',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${assets.length}개',
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // 자산 목록
        ...assets.map((asset) => AssetListItem(
          asset: asset,
          onTap: () => onAssetTap?.call(asset),
          onDelete: () => onAssetDelete?.call(asset.id),
        )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: context.appColors.primaryPale,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 32,
              color: context.appColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '등록된 자산이 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '자산을 추가하여 관리해보세요',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
