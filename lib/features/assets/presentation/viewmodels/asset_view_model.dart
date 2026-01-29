import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/core/exceptions/exception_handler.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/assets/presentation/providers/asset_providers.dart';
import 'package:moamoa/features/assets/presentation/states/asset_state.dart';

part 'asset_view_model.g.dart';

/// 자산 관리 ViewModel
@riverpod
class AssetViewModel extends _$AssetViewModel {
  @override
  AssetState build() {
    Future.microtask(loadAssets);
    return const AssetState(isLoading: true);
  }

  /// 자산 요약 + 목록 로드
  Future<void> loadAssets() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final repository = ref.read(assetRepositoryProvider);
      final overview = await repository.getAssetOverview();

      state = AssetState(
        summary: overview.summary,
        assets: overview.assets,
        isLoading: false,
      );
    } catch (e) {
      final message = e is Exception
          ? ExceptionHandler.getErrorMessage(e)
          : '알 수 없는 오류가 발생했습니다';
      state = AssetState(
        isLoading: false,
        error: '자산 정보를 불러오는데 실패했습니다.\n$message',
      );
    }
  }

  /// 자산 추가
  Future<void> addAsset(Asset asset) async {
    final previousState = state;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(assetRepositoryProvider);
      final selectedAccountBookId =
          ref.read(selectedAccountBookViewModelProvider).asData?.value;

      await repository.createAsset(
        asset: asset,
        accountBookId: selectedAccountBookId,
      );

      final overview = await repository.getAssetOverview();
      state = state.copyWith(
        summary: overview.summary,
        assets: overview.assets,
        isLoading: false,
      );

      if (kDebugMode) {
        debugPrint('[AssetViewModel] Added: ${asset.name}');
      }
    } catch (e) {
      state = previousState.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// 자산 수정
  Future<void> updateAsset(Asset asset) async {
    final previousState = state;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(assetRepositoryProvider);
      final selectedAccountBookId =
          ref.read(selectedAccountBookViewModelProvider).asData?.value;

      await repository.updateAsset(
        asset: asset,
        accountBookId: selectedAccountBookId,
      );

      final overview = await repository.getAssetOverview();
      state = state.copyWith(
        summary: overview.summary,
        assets: overview.assets,
        isLoading: false,
      );

      if (kDebugMode) {
        debugPrint('[AssetViewModel] Updated: ${asset.name}');
      }
    } catch (e) {
      state = previousState.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// 자산 삭제
  Future<void> deleteAsset(String assetId) async {
    final previousState = state;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(assetRepositoryProvider);
      await repository.deleteAsset(assetId);

      final overview = await repository.getAssetOverview();
      state = state.copyWith(
        summary: overview.summary,
        assets: overview.assets,
        isLoading: false,
      );

      if (kDebugMode) {
        debugPrint('[AssetViewModel] Deleted: $assetId');
      }
    } catch (e) {
      state = previousState.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadAssets();
  }
}
