import 'package:moamoa/features/assets/domain/entities/asset_category.dart';

class Asset {
  /// 자산 ID
  final String id;

  /// 자산명 (예: "비상금 통장", "삼성전자")
  final String name;

  /// 자산 카테고리
  final AssetCategory category;

  /// 현재 금액
  final int amount;

  /// 메모 (선택)
  final String? memo;

  /// 생성일
  final DateTime? createdAt;

  /// 수정일
  final DateTime? updatedAt;

  const Asset({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    this.memo,
    this.createdAt,
    this.updatedAt,
  });

  Asset copyWith({
    String? id,
    String? name,
    AssetCategory? category,
    int? amount,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Asset &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        other.amount == amount &&
        other.memo == memo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        amount.hashCode ^
        memo.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
