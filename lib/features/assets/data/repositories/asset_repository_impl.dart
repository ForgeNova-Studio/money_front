import 'package:moamoa/features/assets/data/datasources/remote/asset_remote_datasource.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_overview.dart';
import 'package:moamoa/features/assets/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource remoteDataSource;

  AssetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AssetOverview> getAssetOverview() async {
    final model = await remoteDataSource.getAssetSummary();
    return model.toEntity();
  }

  @override
  Future<Asset> createAsset({
    required Asset asset,
    String? accountBookId,
  }) async {
    final model = await remoteDataSource.createAsset(
      name: asset.name,
      category: asset.category.code,
      amount: asset.amount,
      memo: asset.memo,
      accountBookId: accountBookId,
    );
    return model.toEntity();
  }

  @override
  Future<Asset> updateAsset({
    required Asset asset,
    String? accountBookId,
  }) async {
    final model = await remoteDataSource.updateAsset(
      assetId: asset.id,
      name: asset.name,
      category: asset.category.code,
      amount: asset.amount,
      memo: asset.memo,
      accountBookId: accountBookId,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteAsset(String assetId) async {
    await remoteDataSource.deleteAsset(assetId);
  }
}

