import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';

part 'asset_state.freezed.dart';

/// 자산 화면 상태
@freezed
sealed class AssetState with _$AssetState {
  const AssetState._();

  const factory AssetState({
    /// 자산 요약 정보
    AssetSummary? summary,

    /// 자산 목록
    @Default([]) List<Asset> assets,

    /// 로딩 중 여부
    @Default(false) bool isLoading,

    /// 에러 메시지
    String? error,
  }) = _AssetState;

  /// 자산이 있는지 여부
  bool get hasAssets => assets.isNotEmpty;

  /// 총 자산 금액
  int get totalAmount => summary?.totalAmount ?? 0;
}
