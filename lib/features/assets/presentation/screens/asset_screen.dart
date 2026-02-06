import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/exceptions/exception_handler.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';
import 'package:moamoa/features/assets/presentation/viewmodels/asset_view_model.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_total_card.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_bar_chart.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_category_list.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/monthly_report_banner.dart';
import 'package:moamoa/router/route_names.dart';

/// 자산 화면
class AssetScreen extends ConsumerWidget {
  const AssetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(assetViewModelProvider);

    return DefaultLayout(
      title: '자산',
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            // TODO: Navigate to asset settings
          },
        ),
      ],
      floatingActionButton: SizedBox(
        width: 80,
        height: 35,
        child: FloatingActionButton(
          heroTag: 'asset_screen_fab',
          onPressed: () async {
            final result = await context.push(RouteNames.addAsset);
            if (result == true) {
              ref.read(assetViewModelProvider.notifier).refresh();
            }
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      child: state.isLoading
          ? _buildLoadingState(context)
          : state.error != null
              ? _buildErrorState(context, state.error!, ref)
              : state.assets.isEmpty
                  ? _buildEmptyState(context)
                  : _buildContent(context, state, ref),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.appColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '자산 정보를 불러오는 중...',
            style: TextStyle(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.appColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 32,
                color: context.appColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: TextStyle(
                fontSize: 15,
                color: context.appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(assetViewModelProvider.notifier).refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.primary,
                foregroundColor: context.appColors.textPrimary,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic state, // AssetState
    WidgetRef ref,
  ) {
    final summary = state.summary as AssetSummary?;

    return RefreshIndicator(
      onRefresh: () => ref.read(assetViewModelProvider.notifier).refresh(),
      color: context.appColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 월간 리포트 배너
            const MonthlyReportBanner(),
            
            // 총 자산 카드
            if (summary != null) AssetTotalCard(summary: summary),
            const SizedBox(height: 24),

            // 자산 구성 그래프
            if (summary != null && summary.categoryBreakdowns.isNotEmpty)
              AssetBarChart(breakdowns: summary.categoryBreakdowns),
            const SizedBox(height: 24),

            // 자산 목록
            AssetCategoryList(
              assets: state.assets,
              onAssetTap: (asset) async {
                final result = await context.push(
                  RouteNames.addAsset,
                  extra: asset,
                );
                if (result == true) {
                  ref.read(assetViewModelProvider.notifier).refresh();
                }
              },
              onAssetDelete: (assetId) {
                _showDeleteConfirmDialog(context, ref, assetId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String assetId,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('자산 삭제'),
        content: const Text('이 자산을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref
                    .read(assetViewModelProvider.notifier)
                    .deleteAsset(assetId);
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('자산이 삭제되었습니다'),
                    backgroundColor: context.appColors.success,
                  ),
                );
              } catch (e) {
                final message = e is Exception
                    ? ExceptionHandler.getErrorMessage(e)
                    : '오류가 발생했습니다';
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: context.appColors.error,
                  ),
                );
              }
            },
            child: Text(
              '삭제',
              style: TextStyle(color: context.appColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
