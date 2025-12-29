// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_monthly_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeMonthlyResponseModel {
  List<ExpenseModel> get expenses;
  List<IncomeModel> get incomes;

  /// Create a copy of HomeMonthlyResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeMonthlyResponseModelCopyWith<HomeMonthlyResponseModel> get copyWith =>
      _$HomeMonthlyResponseModelCopyWithImpl<HomeMonthlyResponseModel>(
          this as HomeMonthlyResponseModel, _$identity);

  /// Serializes this HomeMonthlyResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeMonthlyResponseModel &&
            const DeepCollectionEquality().equals(other.expenses, expenses) &&
            const DeepCollectionEquality().equals(other.incomes, incomes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(expenses),
      const DeepCollectionEquality().hash(incomes));

  @override
  String toString() {
    return 'HomeMonthlyResponseModel(expenses: $expenses, incomes: $incomes)';
  }
}

/// @nodoc
abstract mixin class $HomeMonthlyResponseModelCopyWith<$Res> {
  factory $HomeMonthlyResponseModelCopyWith(HomeMonthlyResponseModel value,
          $Res Function(HomeMonthlyResponseModel) _then) =
      _$HomeMonthlyResponseModelCopyWithImpl;
  @useResult
  $Res call({List<ExpenseModel> expenses, List<IncomeModel> incomes});
}

/// @nodoc
class _$HomeMonthlyResponseModelCopyWithImpl<$Res>
    implements $HomeMonthlyResponseModelCopyWith<$Res> {
  _$HomeMonthlyResponseModelCopyWithImpl(this._self, this._then);

  final HomeMonthlyResponseModel _self;
  final $Res Function(HomeMonthlyResponseModel) _then;

  /// Create a copy of HomeMonthlyResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenses = null,
    Object? incomes = null,
  }) {
    return _then(_self.copyWith(
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<ExpenseModel>,
      incomes: null == incomes
          ? _self.incomes
          : incomes // ignore: cast_nullable_to_non_nullable
              as List<IncomeModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeMonthlyResponseModel].
extension HomeMonthlyResponseModelPatterns on HomeMonthlyResponseModel {
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
    TResult Function(_HomeMonthlyResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeMonthlyResponseModel() when $default != null:
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
    TResult Function(_HomeMonthlyResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeMonthlyResponseModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_HomeMonthlyResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeMonthlyResponseModel() when $default != null:
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
    TResult Function(List<ExpenseModel> expenses, List<IncomeModel> incomes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeMonthlyResponseModel() when $default != null:
        return $default(_that.expenses, _that.incomes);
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
    TResult Function(List<ExpenseModel> expenses, List<IncomeModel> incomes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeMonthlyResponseModel():
        return $default(_that.expenses, _that.incomes);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(List<ExpenseModel> expenses, List<IncomeModel> incomes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeMonthlyResponseModel() when $default != null:
        return $default(_that.expenses, _that.incomes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HomeMonthlyResponseModel implements HomeMonthlyResponseModel {
  const _HomeMonthlyResponseModel(
      {final List<ExpenseModel> expenses = const [],
      final List<IncomeModel> incomes = const []})
      : _expenses = expenses,
        _incomes = incomes;
  factory _HomeMonthlyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HomeMonthlyResponseModelFromJson(json);

  final List<ExpenseModel> _expenses;
  @override
  @JsonKey()
  List<ExpenseModel> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

  final List<IncomeModel> _incomes;
  @override
  @JsonKey()
  List<IncomeModel> get incomes {
    if (_incomes is EqualUnmodifiableListView) return _incomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomes);
  }

  /// Create a copy of HomeMonthlyResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeMonthlyResponseModelCopyWith<_HomeMonthlyResponseModel> get copyWith =>
      __$HomeMonthlyResponseModelCopyWithImpl<_HomeMonthlyResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HomeMonthlyResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeMonthlyResponseModel &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            const DeepCollectionEquality().equals(other._incomes, _incomes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_expenses),
      const DeepCollectionEquality().hash(_incomes));

  @override
  String toString() {
    return 'HomeMonthlyResponseModel(expenses: $expenses, incomes: $incomes)';
  }
}

/// @nodoc
abstract mixin class _$HomeMonthlyResponseModelCopyWith<$Res>
    implements $HomeMonthlyResponseModelCopyWith<$Res> {
  factory _$HomeMonthlyResponseModelCopyWith(_HomeMonthlyResponseModel value,
          $Res Function(_HomeMonthlyResponseModel) _then) =
      __$HomeMonthlyResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<ExpenseModel> expenses, List<IncomeModel> incomes});
}

/// @nodoc
class __$HomeMonthlyResponseModelCopyWithImpl<$Res>
    implements _$HomeMonthlyResponseModelCopyWith<$Res> {
  __$HomeMonthlyResponseModelCopyWithImpl(this._self, this._then);

  final _HomeMonthlyResponseModel _self;
  final $Res Function(_HomeMonthlyResponseModel) _then;

  /// Create a copy of HomeMonthlyResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expenses = null,
    Object? incomes = null,
  }) {
    return _then(_HomeMonthlyResponseModel(
      expenses: null == expenses
          ? _self._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<ExpenseModel>,
      incomes: null == incomes
          ? _self._incomes
          : incomes // ignore: cast_nullable_to_non_nullable
              as List<IncomeModel>,
    ));
  }
}

// dart format on
