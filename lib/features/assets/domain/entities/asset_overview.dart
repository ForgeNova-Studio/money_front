import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';

class AssetOverview {
  final AssetSummary summary;
  final List<Asset> assets;

  const AssetOverview({
    required this.summary,
    required this.assets,
  });
}

