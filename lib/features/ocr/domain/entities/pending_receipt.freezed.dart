// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingReceipt {
  /// 고유 식별자 (UUID)
  String get id;

  /// 원본 파싱 데이터
  ReceiptData get receiptData;

  /// 사용자가 수정한 금액 (null이면 파싱 원본 사용)
  int? get amountOverride;

  /// 사용자가 수정한 날짜 (null이면 파싱 원본 사용)
  DateTime? get dateOverride;

  /// 사용자가 수정한 카테고리 (null이면 미분류)
  String? get category;

  /// 사용자가 수정한 메모
  String? get memo;

  /// 사용자가 수정한 가맹점명 (null이면 파싱 원본 사용)
  String? get merchantOverride;

  /// 생성 시간
  DateTime get createdAt;

  /// Create a copy of PendingReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingReceiptCopyWith<PendingReceipt> get copyWith =>
      _$PendingReceiptCopyWithImpl<PendingReceipt>(
          this as PendingReceipt, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingReceipt &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receiptData, receiptData) ||
                other.receiptData == receiptData) &&
            (identical(other.amountOverride, amountOverride) ||
                other.amountOverride == amountOverride) &&
            (identical(other.dateOverride, dateOverride) ||
                other.dateOverride == dateOverride) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.merchantOverride, merchantOverride) ||
                other.merchantOverride == merchantOverride) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, receiptData, amountOverride,
      dateOverride, category, memo, merchantOverride, createdAt);

  @override
  String toString() {
    return 'PendingReceipt(id: $id, receiptData: $receiptData, amountOverride: $amountOverride, dateOverride: $dateOverride, category: $category, memo: $memo, merchantOverride: $merchantOverride, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PendingReceiptCopyWith<$Res> {
  factory $PendingReceiptCopyWith(
          PendingReceipt value, $Res Function(PendingReceipt) _then) =
      _$PendingReceiptCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      ReceiptData receiptData,
      int? amountOverride,
      DateTime? dateOverride,
      String? category,
      String? memo,
      String? merchantOverride,
      DateTime createdAt});
}

/// @nodoc
class _$PendingReceiptCopyWithImpl<$Res>
    implements $PendingReceiptCopyWith<$Res> {
  _$PendingReceiptCopyWithImpl(this._self, this._then);

  final PendingReceipt _self;
  final $Res Function(PendingReceipt) _then;

  /// Create a copy of PendingReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receiptData = null,
    Object? amountOverride = freezed,
    Object? dateOverride = freezed,
    Object? category = freezed,
    Object? memo = freezed,
    Object? merchantOverride = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      receiptData: null == receiptData
          ? _self.receiptData
          : receiptData // ignore: cast_nullable_to_non_nullable
              as ReceiptData,
      amountOverride: freezed == amountOverride
          ? _self.amountOverride
          : amountOverride // ignore: cast_nullable_to_non_nullable
              as int?,
      dateOverride: freezed == dateOverride
          ? _self.dateOverride
          : dateOverride // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantOverride: freezed == merchantOverride
          ? _self.merchantOverride
          : merchantOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [PendingReceipt].
extension PendingReceiptPatterns on PendingReceipt {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PendingReceipt value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingReceipt() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PendingReceipt value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingReceipt():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PendingReceipt value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingReceipt() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            ReceiptData receiptData,
            int? amountOverride,
            DateTime? dateOverride,
            String? category,
            String? memo,
            String? merchantOverride,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingReceipt() when $default != null:
        return $default(
            _that.id,
            _that.receiptData,
            _that.amountOverride,
            _that.dateOverride,
            _that.category,
            _that.memo,
            _that.merchantOverride,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            ReceiptData receiptData,
            int? amountOverride,
            DateTime? dateOverride,
            String? category,
            String? memo,
            String? merchantOverride,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingReceipt():
        return $default(
            _that.id,
            _that.receiptData,
            _that.amountOverride,
            _that.dateOverride,
            _that.category,
            _that.memo,
            _that.merchantOverride,
            _that.createdAt);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            ReceiptData receiptData,
            int? amountOverride,
            DateTime? dateOverride,
            String? category,
            String? memo,
            String? merchantOverride,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingReceipt() when $default != null:
        return $default(
            _that.id,
            _that.receiptData,
            _that.amountOverride,
            _that.dateOverride,
            _that.category,
            _that.memo,
            _that.merchantOverride,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PendingReceipt extends PendingReceipt {
  const _PendingReceipt(
      {required this.id,
      required this.receiptData,
      this.amountOverride,
      this.dateOverride,
      this.category,
      this.memo,
      this.merchantOverride,
      required this.createdAt})
      : super._();

  /// 고유 식별자 (UUID)
  @override
  final String id;

  /// 원본 파싱 데이터
  @override
  final ReceiptData receiptData;

  /// 사용자가 수정한 금액 (null이면 파싱 원본 사용)
  @override
  final int? amountOverride;

  /// 사용자가 수정한 날짜 (null이면 파싱 원본 사용)
  @override
  final DateTime? dateOverride;

  /// 사용자가 수정한 카테고리 (null이면 미분류)
  @override
  final String? category;

  /// 사용자가 수정한 메모
  @override
  final String? memo;

  /// 사용자가 수정한 가맹점명 (null이면 파싱 원본 사용)
  @override
  final String? merchantOverride;

  /// 생성 시간
  @override
  final DateTime createdAt;

  /// Create a copy of PendingReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingReceiptCopyWith<_PendingReceipt> get copyWith =>
      __$PendingReceiptCopyWithImpl<_PendingReceipt>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PendingReceipt &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receiptData, receiptData) ||
                other.receiptData == receiptData) &&
            (identical(other.amountOverride, amountOverride) ||
                other.amountOverride == amountOverride) &&
            (identical(other.dateOverride, dateOverride) ||
                other.dateOverride == dateOverride) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.merchantOverride, merchantOverride) ||
                other.merchantOverride == merchantOverride) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, receiptData, amountOverride,
      dateOverride, category, memo, merchantOverride, createdAt);

  @override
  String toString() {
    return 'PendingReceipt(id: $id, receiptData: $receiptData, amountOverride: $amountOverride, dateOverride: $dateOverride, category: $category, memo: $memo, merchantOverride: $merchantOverride, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PendingReceiptCopyWith<$Res>
    implements $PendingReceiptCopyWith<$Res> {
  factory _$PendingReceiptCopyWith(
          _PendingReceipt value, $Res Function(_PendingReceipt) _then) =
      __$PendingReceiptCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      ReceiptData receiptData,
      int? amountOverride,
      DateTime? dateOverride,
      String? category,
      String? memo,
      String? merchantOverride,
      DateTime createdAt});
}

/// @nodoc
class __$PendingReceiptCopyWithImpl<$Res>
    implements _$PendingReceiptCopyWith<$Res> {
  __$PendingReceiptCopyWithImpl(this._self, this._then);

  final _PendingReceipt _self;
  final $Res Function(_PendingReceipt) _then;

  /// Create a copy of PendingReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? receiptData = null,
    Object? amountOverride = freezed,
    Object? dateOverride = freezed,
    Object? category = freezed,
    Object? memo = freezed,
    Object? merchantOverride = freezed,
    Object? createdAt = null,
  }) {
    return _then(_PendingReceipt(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      receiptData: null == receiptData
          ? _self.receiptData
          : receiptData // ignore: cast_nullable_to_non_nullable
              as ReceiptData,
      amountOverride: freezed == amountOverride
          ? _self.amountOverride
          : amountOverride // ignore: cast_nullable_to_non_nullable
              as int?,
      dateOverride: freezed == dateOverride
          ? _self.dateOverride
          : dateOverride // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantOverride: freezed == merchantOverride
          ? _self.merchantOverride
          : merchantOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
