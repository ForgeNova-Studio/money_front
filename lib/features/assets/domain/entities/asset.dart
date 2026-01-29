import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';

part 'asset.freezed.dart';

/// 개별 자산 엔티티
@freezed
sealed class Asset with _$Asset {
  const Asset._();

  const factory Asset({
    /// 자산 ID
    required String id,

    /// 자산명 (예: "비상금 통장", "삼성전자")
    required String name,

    /// 자산 카테고리
    required AssetCategory category,

    /// 현재 금액
    required int amount,

    /// 메모 (선택)
    String? memo,

    /// 생성일
    DateTime? createdAt,

    /// 수정일
    DateTime? updatedAt,
  }) = _Asset;

  /// 금액 포맷팅 (1,000,000)
  String get formattedAmount {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}
