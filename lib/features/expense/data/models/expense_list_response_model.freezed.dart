// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseListResponseModel {
  List<ExpenseModel> get expenses;
  double get totalAmount;
  int get count;

  /// Create a copy of ExpenseListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseListResponseModelCopyWith<ExpenseListResponseModel> get copyWith =>
      _$ExpenseListResponseModelCopyWithImpl<ExpenseListResponseModel>(
          this as ExpenseListResponseModel, _$identity);

  /// Serializes this ExpenseListResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseListResponseModel &&
            const DeepCollectionEquality().equals(other.expenses, expenses) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(expenses), totalAmount, count);

  @override
  String toString() {
    return 'ExpenseListResponseModel(expenses: $expenses, totalAmount: $totalAmount, count: $count)';
  }
}

/// @nodoc
abstract mixin class $ExpenseListResponseModelCopyWith<$Res> {
  factory $ExpenseListResponseModelCopyWith(ExpenseListResponseModel value,
          $Res Function(ExpenseListResponseModel) _then) =
      _$ExpenseListResponseModelCopyWithImpl;
  @useResult
  $Res call({List<ExpenseModel> expenses, double totalAmount, int count});
}

/// @nodoc
class _$ExpenseListResponseModelCopyWithImpl<$Res>
    implements $ExpenseListResponseModelCopyWith<$Res> {
  _$ExpenseListResponseModelCopyWithImpl(this._self, this._then);

  final ExpenseListResponseModel _self;
  final $Res Function(ExpenseListResponseModel) _then;

  /// Create a copy of ExpenseListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenses = null,
    Object? totalAmount = null,
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<ExpenseModel>,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExpenseListResponseModel].
extension ExpenseListResponseModelPatterns on ExpenseListResponseModel {
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
    TResult Function(_ExpenseListResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseListResponseModel() when $default != null:
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
    TResult Function(_ExpenseListResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseListResponseModel():
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
    TResult? Function(_ExpenseListResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseListResponseModel() when $default != null:
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
            List<ExpenseModel> expenses, double totalAmount, int count)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseListResponseModel() when $default != null:
        return $default(_that.expenses, _that.totalAmount, _that.count);
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
    TResult Function(List<ExpenseModel> expenses, double totalAmount, int count)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseListResponseModel():
        return $default(_that.expenses, _that.totalAmount, _that.count);
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
            List<ExpenseModel> expenses, double totalAmount, int count)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseListResponseModel() when $default != null:
        return $default(_that.expenses, _that.totalAmount, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExpenseListResponseModel implements ExpenseListResponseModel {
  const _ExpenseListResponseModel(
      {required final List<ExpenseModel> expenses,
      required this.totalAmount,
      required this.count})
      : _expenses = expenses;
  factory _ExpenseListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseListResponseModelFromJson(json);

  final List<ExpenseModel> _expenses;
  @override
  List<ExpenseModel> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

  @override
  final double totalAmount;
  @override
  final int count;

  /// Create a copy of ExpenseListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseListResponseModelCopyWith<_ExpenseListResponseModel> get copyWith =>
      __$ExpenseListResponseModelCopyWithImpl<_ExpenseListResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseListResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseListResponseModel &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_expenses), totalAmount, count);

  @override
  String toString() {
    return 'ExpenseListResponseModel(expenses: $expenses, totalAmount: $totalAmount, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseListResponseModelCopyWith<$Res>
    implements $ExpenseListResponseModelCopyWith<$Res> {
  factory _$ExpenseListResponseModelCopyWith(_ExpenseListResponseModel value,
          $Res Function(_ExpenseListResponseModel) _then) =
      __$ExpenseListResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<ExpenseModel> expenses, double totalAmount, int count});
}

/// @nodoc
class __$ExpenseListResponseModelCopyWithImpl<$Res>
    implements _$ExpenseListResponseModelCopyWith<$Res> {
  __$ExpenseListResponseModelCopyWithImpl(this._self, this._then);

  final _ExpenseListResponseModel _self;
  final $Res Function(_ExpenseListResponseModel) _then;

  /// Create a copy of ExpenseListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expenses = null,
    Object? totalAmount = null,
    Object? count = null,
  }) {
    return _then(_ExpenseListResponseModel(
      expenses: null == expenses
          ? _self._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<ExpenseModel>,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
