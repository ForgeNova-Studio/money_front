import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class AssetOverview {
  final AssetSummary summary;
  final List<Asset> assets;

  const AssetOverview({
    required this.summary,
    required this.assets,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssetOverview &&
        other.summary == summary &&
        _listEquals(other.assets, assets);
  }

  @override
  int get hashCode => summary.hashCode ^ Object.hashAll(assets);
}
