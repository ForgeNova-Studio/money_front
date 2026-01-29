import 'package:moamoa/features/assets/data/models/asset_models.dart';

/// Asset Remote Data Source 인터페이스
abstract class AssetRemoteDataSource {
  /// 자산 요약 + 목록 조회 API 호출
  Future<AssetSummaryResponseModel> getAssetSummary();

  /// 자산 생성 API 호출
  Future<AssetResponseModel> createAsset({
    required String name,
    required String category,
    required int amount,
    String? memo,
    String? accountBookId,
  });

  /// 자산 수정 API 호출
  Future<AssetResponseModel> updateAsset({
    required String assetId,
    required String name,
    required String category,
    required int amount,
    String? memo,
    String? accountBookId,
  });

  /// 자산 삭제 API 호출
  Future<void> deleteAsset(String assetId);
}

