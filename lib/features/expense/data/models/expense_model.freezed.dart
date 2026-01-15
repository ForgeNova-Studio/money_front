// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseModel {
  String? get expenseId;
  String? get userId;
  String? get coupleId;
  String? get accountBookId;
  double get amount;
  DateTime get date;
  String get category;
  String? get merchant;
  String? get memo;
  String get paymentMethod;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      _$ExpenseModelCopyWithImpl<ExpenseModel>(
          this as ExpenseModel, _$identity);

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseModel &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      expenseId,
      userId,
      coupleId,
      accountBookId,
      amount,
      date,
      category,
      merchant,
      memo,
      paymentMethod,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'ExpenseModel(expenseId: $expenseId, userId: $userId, coupleId: $coupleId, accountBookId: $accountBookId, amount: $amount, date: $date, category: $category, merchant: $merchant, memo: $memo, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
          ExpenseModel value, $Res Function(ExpenseModel) _then) =
      _$ExpenseModelCopyWithImpl;
  @useResult
  $Res call(
      {String? expenseId,
      String? userId,
      String? coupleId,
      String? accountBookId,
      double amount,
      DateTime date,
      String category,
      String? merchant,
      String? memo,
      String paymentMethod,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res> implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._self, this._then);

  final ExpenseModel _self;
  final $Res Function(ExpenseModel) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenseId = freezed,
    Object? userId = freezed,
    Object? coupleId = freezed,
    Object? accountBookId = freezed,
    Object? amount = null,
    Object? date = null,
    Object? category = null,
    Object? merchant = freezed,
    Object? memo = freezed,
    Object? paymentMethod = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      expenseId: freezed == expenseId
          ? _self.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      coupleId: freezed == coupleId
          ? _self.coupleId
          : coupleId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBookId: freezed == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
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

/// Adds pattern-matching-related methods to [ExpenseModel].
extension ExpenseModelPatterns on ExpenseModel {
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
    TResult Function(_ExpenseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseModel() when $default != null:
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
    TResult Function(_ExpenseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseModel():
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
    TResult? Function(_ExpenseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseModel() when $default != null:
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
            String? expenseId,
            String? userId,
            String? coupleId,
            String? accountBookId,
            double amount,
            DateTime date,
            String category,
            String? merchant,
            String? memo,
            String paymentMethod,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseModel() when $default != null:
        return $default(
            _that.expenseId,
            _that.userId,
            _that.coupleId,
            _that.accountBookId,
            _that.amount,
            _that.date,
            _that.category,
            _that.merchant,
            _that.memo,
            _that.paymentMethod,
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
            String? expenseId,
            String? userId,
            String? coupleId,
            String? accountBookId,
            double amount,
            DateTime date,
            String category,
            String? merchant,
            String? memo,
            String paymentMethod,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseModel():
        return $default(
            _that.expenseId,
            _that.userId,
            _that.coupleId,
            _that.accountBookId,
            _that.amount,
            _that.date,
            _that.category,
            _that.merchant,
            _that.memo,
            _that.paymentMethod,
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
            String? expenseId,
            String? userId,
            String? coupleId,
            String? accountBookId,
            double amount,
            DateTime date,
            String category,
            String? merchant,
            String? memo,
            String paymentMethod,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseModel() when $default != null:
        return $default(
            _that.expenseId,
            _that.userId,
            _that.coupleId,
            _that.accountBookId,
            _that.amount,
            _that.date,
            _that.category,
            _that.merchant,
            _that.memo,
            _that.paymentMethod,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExpenseModel extends ExpenseModel {
  const _ExpenseModel(
      {this.expenseId,
      this.userId,
      this.coupleId,
      this.accountBookId,
      required this.amount,
      required this.date,
      required this.category,
      this.merchant,
      this.memo,
      required this.paymentMethod,
      this.createdAt,
      this.updatedAt})
      : super._();
  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  @override
  final String? expenseId;
  @override
  final String? userId;
  @override
  final String? coupleId;
  @override
  final String? accountBookId;
  @override
  final double amount;
  @override
  final DateTime date;
  @override
  final String category;
  @override
  final String? merchant;
  @override
  final String? memo;
  @override
  final String paymentMethod;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseModelCopyWith<_ExpenseModel> get copyWith =>
      __$ExpenseModelCopyWithImpl<_ExpenseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseModel &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      expenseId,
      userId,
      coupleId,
      accountBookId,
      amount,
      date,
      category,
      merchant,
      memo,
      paymentMethod,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'ExpenseModel(expenseId: $expenseId, userId: $userId, coupleId: $coupleId, accountBookId: $accountBookId, amount: $amount, date: $date, category: $category, merchant: $merchant, memo: $memo, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseModelCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$ExpenseModelCopyWith(
          _ExpenseModel value, $Res Function(_ExpenseModel) _then) =
      __$ExpenseModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? expenseId,
      String? userId,
      String? coupleId,
      String? accountBookId,
      double amount,
      DateTime date,
      String category,
      String? merchant,
      String? memo,
      String paymentMethod,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$ExpenseModelCopyWithImpl<$Res>
    implements _$ExpenseModelCopyWith<$Res> {
  __$ExpenseModelCopyWithImpl(this._self, this._then);

  final _ExpenseModel _self;
  final $Res Function(_ExpenseModel) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expenseId = freezed,
    Object? userId = freezed,
    Object? coupleId = freezed,
    Object? accountBookId = freezed,
    Object? amount = null,
    Object? date = null,
    Object? category = null,
    Object? merchant = freezed,
    Object? memo = freezed,
    Object? paymentMethod = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_ExpenseModel(
      expenseId: freezed == expenseId
          ? _self.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      coupleId: freezed == coupleId
          ? _self.coupleId
          : coupleId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountBookId: freezed == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
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
