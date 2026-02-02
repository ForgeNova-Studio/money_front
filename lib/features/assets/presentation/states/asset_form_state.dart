import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';

part 'asset_form_state.freezed.dart';

/// 자산 추가/수정 폼 상태
@freezed
sealed class AssetFormState with _$AssetFormState {
  const AssetFormState._();

  const factory AssetFormState({
    @Default('') String name,
    @Default(AssetCategory.cash) AssetCategory category,
    @Default('') String amount,
    @Default('') String memo,
    @Default(false) bool isSaving,
    Asset? editingAsset,
  }) = _AssetFormState;

  factory AssetFormState.initial() => const AssetFormState();

  factory AssetFormState.fromAsset(Asset asset) => AssetFormState(
        name: asset.name,
        category: asset.category,
        amount: asset.amount.toString(),
        memo: asset.memo ?? '',
        editingAsset: asset,
      );

  bool get isEditMode => editingAsset != null;

  int get parsedAmount =>
      int.tryParse(amount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  bool get isValid =>
      name.trim().isNotEmpty &&
      parsedAmount > 0 &&
      parsedAmount < 10000000000000;
}
