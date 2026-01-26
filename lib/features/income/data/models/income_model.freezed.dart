// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IncomeModel {
  String? get incomeId;
  String? get userId;
  String? get accountBookId;
  String? get fundingSource;
  int get amount;
  DateTime get date;
  String get source;
  String? get description;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of IncomeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IncomeModelCopyWith<IncomeModel> get copyWith =>
      _$IncomeModelCopyWithImpl<IncomeModel>(this as IncomeModel, _$identity);

  /// Serializes this IncomeModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IncomeModel &&
            (identical(other.incomeId, incomeId) ||
                other.incomeId == incomeId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.fundingSource, fundingSource) ||
                other.fundingSource == fundingSource) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, incomeId, userId, accountBookId,
      fundingSource, amount, date, source, description, createdAt, updatedAt);

  @override
  String toString() {
    return 'IncomeModel(incomeId: $incomeId, userId: $userId, accountBookId: $accountBookId, fundingSource: $fundingSource, amount: $amount, date: $date, source: $source, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $IncomeModelCopyWith<$Res> {
  factory $IncomeModelCopyWith(
          IncomeModel value, $Res Function(IncomeModel) _then) =
      _$IncomeModelCopyWithImpl;
  @useResult
  $Res call(
      {String? incomeId,
      String? userId,
      String? accountBookId,
      String? fundingSource,
      int amount,
      DateTime date,
      String source,
      String? description,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$IncomeModelCopyWithImpl<$Res> implements $IncomeModelCopyWith<$Res> {
  _$IncomeModelCopyWithImpl(this._self, this._then);

  final IncomeModel _self;
  final $Res Function(IncomeModel) _then;

  /// Create a copy of IncomeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incomeId = freezed,
    Object? userId = freezed,
    Object? accountBookId = freezed,
    Object? fundingSource = freezed,
    Object? amount = null,
    Object? date = null,
    Object? source = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      incomeId: freezed == incomeId
          ? _self.incomeId
          : incomeId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBookId: freezed == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      fundingSource: freezed == fundingSource
          ? _self.fundingSource
          : fundingSource // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [IncomeModel].
extension IncomeModelPatterns on IncomeModel {
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
    TResult Function(_IncomeModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncomeModel() when $default != null:
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
    TResult Function(_IncomeModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeModel():
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
    TResult? Function(_IncomeModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeModel() when $default != null:
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
            String? incomeId,
            String? userId,
            String? accountBookId,
            String? fundingSource,
            int amount,
            DateTime date,
            String source,
            String? description,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncomeModel() when $default != null:
        return $default(
            _that.incomeId,
            _that.userId,
            _that.accountBookId,
            _that.fundingSource,
            _that.amount,
            _that.date,
            _that.source,
            _that.description,
            _that.createdAt,
            _that.updatedAt);
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
            String? incomeId,
            String? userId,
            String? accountBookId,
            String? fundingSource,
            int amount,
            DateTime date,
            String source,
            String? description,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeModel():
        return $default(
            _that.incomeId,
            _that.userId,
            _that.accountBookId,
            _that.fundingSource,
            _that.amount,
            _that.date,
            _that.source,
            _that.description,
            _that.createdAt,
            _that.updatedAt);
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
            String? incomeId,
            String? userId,
            String? accountBookId,
            String? fundingSource,
            int amount,
            DateTime date,
            String source,
            String? description,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeModel() when $default != null:
        return $default(
            _that.incomeId,
            _that.userId,
            _that.accountBookId,
            _that.fundingSource,
            _that.amount,
            _that.date,
            _that.source,
            _that.description,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IncomeModel extends IncomeModel {
  const _IncomeModel(
      {this.incomeId,
      this.userId,
      this.accountBookId,
      this.fundingSource,
      required this.amount,
      required this.date,
      required this.source,
      this.description,
      this.createdAt,
      this.updatedAt})
      : super._();
  factory _IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);

  @override
  final String? incomeId;
  @override
  final String? userId;
  @override
  final String? accountBookId;
  @override
  final String? fundingSource;
  @override
  final int amount;
  @override
  final DateTime date;
  @override
  final String source;
  @override
  final String? description;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of IncomeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IncomeModelCopyWith<_IncomeModel> get copyWith =>
      __$IncomeModelCopyWithImpl<_IncomeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IncomeModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IncomeModel &&
            (identical(other.incomeId, incomeId) ||
                other.incomeId == incomeId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.fundingSource, fundingSource) ||
                other.fundingSource == fundingSource) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, incomeId, userId, accountBookId,
      fundingSource, amount, date, source, description, createdAt, updatedAt);

  @override
  String toString() {
    return 'IncomeModel(incomeId: $incomeId, userId: $userId, accountBookId: $accountBookId, fundingSource: $fundingSource, amount: $amount, date: $date, source: $source, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$IncomeModelCopyWith<$Res>
    implements $IncomeModelCopyWith<$Res> {
  factory _$IncomeModelCopyWith(
          _IncomeModel value, $Res Function(_IncomeModel) _then) =
      __$IncomeModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? incomeId,
      String? userId,
      String? accountBookId,
      String? fundingSource,
      int amount,
      DateTime date,
      String source,
      String? description,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$IncomeModelCopyWithImpl<$Res> implements _$IncomeModelCopyWith<$Res> {
  __$IncomeModelCopyWithImpl(this._self, this._then);

  final _IncomeModel _self;
  final $Res Function(_IncomeModel) _then;

  /// Create a copy of IncomeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? incomeId = freezed,
    Object? userId = freezed,
    Object? accountBookId = freezed,
    Object? fundingSource = freezed,
    Object? amount = null,
    Object? date = null,
    Object? source = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_IncomeModel(
      incomeId: freezed == incomeId
          ? _self.incomeId
          : incomeId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBookId: freezed == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      fundingSource: freezed == fundingSource
          ? _self.fundingSource
          : fundingSource // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
