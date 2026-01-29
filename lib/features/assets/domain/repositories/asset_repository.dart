import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_overview.dart';

/// Asset Repository 인터페이스
abstract class AssetRepository {
  /// 자산 요약 + 목록 조회
  Future<AssetOverview> getAssetOverview();

  /// 자산 생성
  Future<Asset> createAsset({
    required Asset asset,
    String? accountBookId,
  });

  /// 자산 수정
  Future<Asset> updateAsset({
    required Asset asset,
    String? accountBookId,
  });

  /// 자산 삭제
  Future<void> deleteAsset(String assetId);
}

