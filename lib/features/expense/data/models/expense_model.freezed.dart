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
  String? get accountBookId;
  String? get fundingSource;
  int get amount;
  DateTime get date;
  String? get category;
  String? get merchant;
  String? get memo;
  String? get paymentMethod;
  String? get imageUrl;
  bool? get isAutoCategorized;
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
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.fundingSource, fundingSource) ||
                other.fundingSource == fundingSource) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAutoCategorized, isAutoCategorized) ||
                other.isAutoCategorized == isAutoCategorized) &&
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
      accountBookId,
      fundingSource,
      amount,
      date,
      category,
      merchant,
      memo,
      paymentMethod,
      imageUrl,
      isAutoCategorized,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'ExpenseModel(expenseId: $expenseId, userId: $userId, accountBookId: $accountBookId, fundingSource: $fundingSource, amount: $amount, date: $date, category: $category, merchant: $merchant, memo: $memo, paymentMethod: $paymentMethod, imageUrl: $imageUrl, isAutoCategorized: $isAutoCategorized, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      String? accountBookId,
      String? fundingSource,
      int amount,
      DateTime date,
      String? category,
      String? merchant,
      String? memo,
      String? paymentMethod,
      String? imageUrl,
      bool? isAutoCategorized,
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
    Object? accountBookId = freezed,
    Object? fundingSource = freezed,
    Object? amount = null,
    Object? date = null,
    Object? category = freezed,
    Object? merchant = freezed,
    Object? memo = freezed,
    Object? paymentMethod = freezed,
    Object? imageUrl = freezed,
    Object? isAutoCategorized = freezed,
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
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAutoCategorized: freezed == isAutoCategorized
          ? _self.isAutoCategorized
          : isAutoCategorized // ignore: cast_nullable_to_non_nullable
              as bool?,
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
            String? accountBookId,
            String? fundingSource,
            int amount,
            DateTime date,
            String? category,
            String? merchant,
            String? memo,
            String? paymentMethod,
            String? imageUrl,
            bool? isAutoCategorized,
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
            _that.accountBookId,
            _that.fundingSource,
            _that.amount,
            _that.date,
            _that.category,
            _that.merchant,
            _that.memo,
            _that.paymentMethod,
            _that.imageUrl,
            _that.isAutoCategorized,
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
            String? accountBookId,
            String? fundingSource,
            int amount,
            DateTime date,
            String? category,
            String? merchant,
            String? memo,
            String? paymentMethod,
            String? imageUrl,
            bool? isAutoCategorized,
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
            _that.accountBookId,
            _that.fundingSource,
            _that.amount,
            _that.date,
            _that.category,
            _that.merchant,
            _that.memo,
            _that.paymentMethod,
            _that.imageUrl,
            _that.isAutoCategorized,
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
            String? accountBookId,
            String? fundingSource,
            int amount,
            DateTime date,
            String? category,
            String? merchant,
            String? memo,
            String? paymentMethod,
            String? imageUrl,
            bool? isAutoCategorized,
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
            _that.accountBookId,
            _that.fundingSource,
            _that.amount,
            _that.date,
            _that.category,
            _that.merchant,
            _that.memo,
            _that.paymentMethod,
            _that.imageUrl,
            _that.isAutoCategorized,
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
      this.accountBookId,
      this.fundingSource,
      required this.amount,
      required this.date,
      this.category,
      this.merchant,
      this.memo,
      this.paymentMethod,
      this.imageUrl,
      this.isAutoCategorized,
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
  final String? accountBookId;
  @override
  final String? fundingSource;
  @override
  final int amount;
  @override
  final DateTime date;
  @override
  final String? category;
  @override
  final String? merchant;
  @override
  final String? memo;
  @override
  final String? paymentMethod;
  @override
  final String? imageUrl;
  @override
  final bool? isAutoCategorized;
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
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.fundingSource, fundingSource) ||
                other.fundingSource == fundingSource) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAutoCategorized, isAutoCategorized) ||
                other.isAutoCategorized == isAutoCategorized) &&
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
      accountBookId,
      fundingSource,
      amount,
      date,
      category,
      merchant,
      memo,
      paymentMethod,
      imageUrl,
      isAutoCategorized,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'ExpenseModel(expenseId: $expenseId, userId: $userId, accountBookId: $accountBookId, fundingSource: $fundingSource, amount: $amount, date: $date, category: $category, merchant: $merchant, memo: $memo, paymentMethod: $paymentMethod, imageUrl: $imageUrl, isAutoCategorized: $isAutoCategorized, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      String? accountBookId,
      String? fundingSource,
      int amount,
      DateTime date,
      String? category,
      String? merchant,
      String? memo,
      String? paymentMethod,
      String? imageUrl,
      bool? isAutoCategorized,
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
    Object? accountBookId = freezed,
    Object? fundingSource = freezed,
    Object? amount = null,
    Object? date = null,
    Object? category = freezed,
    Object? merchant = freezed,
    Object? memo = freezed,
    Object? paymentMethod = freezed,
    Object? imageUrl = freezed,
    Object? isAutoCategorized = freezed,
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
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAutoCategorized: freezed == isAutoCategorized
          ? _self.isAutoCategorized
          : isAutoCategorized // ignore: cast_nullable_to_non_nullable
              as bool?,
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
