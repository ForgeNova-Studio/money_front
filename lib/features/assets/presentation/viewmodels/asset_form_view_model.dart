import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';
import 'package:moamoa/features/assets/presentation/states/asset_form_state.dart';

part 'asset_form_view_model.g.dart';

/// 자산 폼 ViewModel (추가/수정)
@riverpod
class AssetFormViewModel extends _$AssetFormViewModel {
  @override
  AssetFormState build() {
    return AssetFormState.initial();
  }

  void initForEdit(Asset asset) {
    state = AssetFormState.fromAsset(asset);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateCategory(AssetCategory category) {
    state = state.copyWith(category: category);
  }

  void updateAmount(String amount) {
    state = state.copyWith(amount: amount);
  }

  void updateMemo(String memo) {
    state = state.copyWith(memo: memo);
  }

  /// 유효성 검사. 에러 메시지 반환, null이면 통과
  String? validate() {
    if (state.name.trim().isEmpty) return '자산명을 입력해주세요';
    if (state.parsedAmount <= 0) return '금액을 입력해주세요';
    if (state.parsedAmount >= 10000000000000) return '금액은 1조 미만이어야 합니다';
    return null;
  }

  /// 현재 폼 상태를 Asset 엔티티로 변환
  Asset toAsset() {
    return Asset(
      id: state.editingAsset?.id ?? '',
      name: state.name.trim(),
      category: state.category,
      amount: state.parsedAmount,
      memo: state.memo.trim().isEmpty ? null : state.memo.trim(),
      createdAt: state.editingAsset?.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void reset() {
    state = AssetFormState.initial();
  }
}
