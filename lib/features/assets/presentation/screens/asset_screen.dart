import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/exceptions/exception_handler.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';
import 'package:moamoa/features/assets/presentation/utils/asset_extensions.dart';
import 'package:moamoa/features/assets/presentation/viewmodels/asset_view_model.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_total_card.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_bar_chart.dart';
import 'package:moamoa/features/assets/presentation/widgets/asset_category_list.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

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
          onPressed: () => _showAddAssetSheet(context, ref),
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
              onAssetTap: (asset) {
                _showEditAssetSheet(context, ref, asset);
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

  void _showAddAssetSheet(BuildContext context, WidgetRef ref) {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AssetFormSheet(
        onSave: (asset) async {
          try {
            await ref.read(assetViewModelProvider.notifier).addAsset(asset);
            navigator.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text('${asset.name} 자산이 추가되었습니다'),
                backgroundColor: sheetContext.appColors.success,
              ),
            );
          } catch (e) {
            final message = e is Exception
                ? ExceptionHandler.getErrorMessage(e)
                : '오류가 발생했습니다';
            messenger.showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: sheetContext.appColors.error,
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditAssetSheet(BuildContext context, WidgetRef ref, Asset asset) {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AssetFormSheet(
        asset: asset,
        onSave: (updatedAsset) async {
          try {
            await ref
                .read(assetViewModelProvider.notifier)
                .updateAsset(updatedAsset);
            navigator.pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text('${updatedAsset.name} 자산이 수정되었습니다'),
                backgroundColor: sheetContext.appColors.success,
              ),
            );
          } catch (e) {
            final message = e is Exception
                ? ExceptionHandler.getErrorMessage(e)
                : '오류가 발생했습니다';
            messenger.showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: sheetContext.appColors.error,
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String assetId,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('자산 삭제'),
        content: const Text('이 자산을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(assetViewModelProvider.notifier)
                    .deleteAsset(assetId);
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('자산이 삭제되었습니다'),
                    backgroundColor: context.appColors.error,
                  ),
                );
              } catch (e) {
                final message = e is Exception
                    ? ExceptionHandler.getErrorMessage(e)
                    : '오류가 발생했습니다';
                navigator.pop();
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

/// 자산 추가/수정 바텀 시트
class _AssetFormSheet extends StatefulWidget {
  final Asset? asset; // null이면 추가 모드, 있으면 수정 모드
  final Future<void> Function(Asset asset) onSave;

  const _AssetFormSheet({
    this.asset,
    required this.onSave,
  });

  bool get isEditMode => asset != null;

  @override
  State<_AssetFormSheet> createState() => _AssetFormSheetState();
}

class _AssetFormSheetState extends State<_AssetFormSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  late AssetCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      _nameController.text = widget.asset!.name;
      _amountController.text = widget.asset!.amount.toString();
      _memoController.text = widget.asset!.memo ?? '';
      _selectedCategory = widget.asset!.category;
    } else {
      _selectedCategory = AssetCategory.cash;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핸들
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.appColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 제목
            Text(
              widget.isEditMode ? '자산 수정' : '자산 추가',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // 자산명
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '자산명',
                hintText: '예: 비상금 통장',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.appColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 카테고리 선택
            Text(
              '카테고리',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AssetCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category.icon,
                        size: 16,
                        color: isSelected ? Colors.white : category.color,
                      ),
                      const SizedBox(width: 6),
                      Text(category.label),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = category);
                  },
                  selectedColor: category.color,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : context.appColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 금액
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '금액',
                hintText: '0',
                prefixText: '₩ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.appColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 메모
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                labelText: '메모 (선택)',
                hintText: '메모를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.appColors.primary),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  _handleSave();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.primary,
                  foregroundColor: context.appColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? '수정하기' : '추가하기',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(amountText) ?? 0;
    final memo = _memoController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('자산명을 입력해주세요')),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('금액을 입력해주세요')),
      );
      return;
    }

    final asset = Asset(
      id: widget.asset?.id ?? '',
      name: name,
      category: _selectedCategory,
      amount: amount,
      memo: memo.isEmpty ? null : memo,
      createdAt: widget.asset?.createdAt,
      updatedAt: DateTime.now(),
    );

    await widget.onSave(asset);
  }
}
