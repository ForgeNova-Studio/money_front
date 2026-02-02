import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';
import 'package:moamoa/features/assets/presentation/utils/asset_extensions.dart';
import 'package:moamoa/features/assets/presentation/viewmodels/asset_form_view_model.dart';
import 'package:moamoa/features/assets/presentation/viewmodels/asset_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/common/widgets/transaction_form/amount_input_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/form_submit_button.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_text_field.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  final Asset? asset;

  const AddAssetScreen({
    super.key,
    this.asset,
  });

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _amountFocusNode = FocusNode();

  bool get isEditing => widget.asset != null;

  @override
  void initState() {
    super.initState();

    // 수정 모드: 기존 값 세팅
    if (widget.asset != null) {
      _nameController.text = widget.asset!.name;
      _amountController.text = widget.asset!.formattedAmount;
      _memoController.text = widget.asset!.memo ?? '';
    }

    // 빌드 완료 후 ViewModel 초기화
    Future(() {
      final vm = ref.read(assetFormViewModelProvider.notifier);
      if (widget.asset != null) {
        vm.initForEdit(widget.asset!);
      } else {
        vm.reset();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('금액을 입력하세요'),
            backgroundColor: context.appColors.error,
          ),
        );
      return '';
    }
    final amount = int.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return '올바른 금액을 입력하세요';
    }
    if (amount >= 10000000000000) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('금액은 1조 미만이어야 합니다'),
            backgroundColor: context.appColors.error,
          ),
        );
      return '';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('자산명을 입력해주세요'),
            backgroundColor: context.appColors.error,
          ),
        );
      return;
    }

    final formState = ref.read(assetFormViewModelProvider);
    final amount = int.parse(_amountController.text.replaceAll(',', ''));

    final asset = Asset(
      id: widget.asset?.id ?? '',
      name: _nameController.text.trim(),
      category: formState.category,
      amount: amount,
      memo: _memoController.text.trim().isEmpty
          ? null
          : _memoController.text.trim(),
      createdAt: widget.asset?.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      if (isEditing) {
        await ref.read(assetViewModelProvider.notifier).updateAsset(asset);
      } else {
        await ref.read(assetViewModelProvider.notifier).addAsset(asset);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? '${asset.name} 자산이 수정되었습니다'
                  : '${asset.name} 자산이 추가되었습니다',
            ),
            backgroundColor: context.appColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('오류가 발생했습니다'),
            backgroundColor: context.appColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formState = ref.watch(assetFormViewModelProvider);

    return DefaultLayout(
      title: isEditing ? '자산 수정' : '자산 추가',
      centerTitle: true,
      canPop: false,
      leading: IconButton(
        icon: Icon(Icons.close, color: colorScheme.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (notification) {
                if (notification.dragDetails != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                return false;
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // 1. 금액 입력
                      AmountInputCard(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        validator: _validateAmount,
                        amountColor: context.appColors.black,
                        unitColor: context.appColors.textPrimary,
                        maxDigits: 12,
                      ),
                      const SizedBox(height: 24),

                      // 2. 자산명, 메모
                      TransactionFormCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Column(
                          children: [
                            TransactionTextField(
                              controller: _nameController,
                              hint: '자산명 (예: 비상금 통장)',
                              icon: Icons.account_balance_outlined,
                            ),
                            const SizedBox(height: 4),
                            TransactionTextField(
                              controller: _memoController,
                              hint: '메모를 남겨주세요',
                              icon: Icons.edit_outlined,
                              multiline: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 3. 카테고리 선택
                      Text(
                        '카테고리',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth =
                              (constraints.maxWidth - 24) / 3;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                AssetCategory.values.map((category) {
                              final isSelected =
                                  formState.category == category;
                              final color = category.color;
                              return SizedBox(
                                width: itemWidth,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    onTap: () {
                                      ref
                                          .read(
                                              assetFormViewModelProvider
                                                  .notifier)
                                          .updateCategory(category);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 200),
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? color.withValues(
                                                alpha: 0.12)
                                            : colorScheme.surface,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? color
                                              : context
                                                  .appColors.divider,
                                          width:
                                              isSelected ? 1.5 : 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? color
                                                  : color.withValues(
                                                      alpha: 0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              category.icon,
                                              color: isSelected
                                                  ? Colors.white
                                                  : color,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            category.label,
                                            textAlign:
                                                TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isSelected
                                                  ? color
                                                  : context.appColors
                                                      .textSecondary,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 하단 버튼
          FormSubmitButton(
            isVisible: MediaQuery.of(context).viewInsets.bottom == 0,
            label: isEditing ? '수정하기' : '추가하기',
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
