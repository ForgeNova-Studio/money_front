// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_list_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IncomeListResponseModel {
  List<IncomeModel> get incomes;
  double get totalAmount;
  int get count;

  /// Create a copy of IncomeListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IncomeListResponseModelCopyWith<IncomeListResponseModel> get copyWith =>
      _$IncomeListResponseModelCopyWithImpl<IncomeListResponseModel>(
          this as IncomeListResponseModel, _$identity);

  /// Serializes this IncomeListResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IncomeListResponseModel &&
            const DeepCollectionEquality().equals(other.incomes, incomes) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(incomes), totalAmount, count);

  @override
  String toString() {
    return 'IncomeListResponseModel(incomes: $incomes, totalAmount: $totalAmount, count: $count)';
  }
}

/// @nodoc
abstract mixin class $IncomeListResponseModelCopyWith<$Res> {
  factory $IncomeListResponseModelCopyWith(IncomeListResponseModel value,
          $Res Function(IncomeListResponseModel) _then) =
      _$IncomeListResponseModelCopyWithImpl;
  @useResult
  $Res call({List<IncomeModel> incomes, double totalAmount, int count});
}

/// @nodoc
class _$IncomeListResponseModelCopyWithImpl<$Res>
    implements $IncomeListResponseModelCopyWith<$Res> {
  _$IncomeListResponseModelCopyWithImpl(this._self, this._then);

  final IncomeListResponseModel _self;
  final $Res Function(IncomeListResponseModel) _then;

  /// Create a copy of IncomeListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incomes = null,
    Object? totalAmount = null,
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      incomes: null == incomes
          ? _self.incomes
          : incomes // ignore: cast_nullable_to_non_nullable
              as List<IncomeModel>,
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

/// Adds pattern-matching-related methods to [IncomeListResponseModel].
extension IncomeListResponseModelPatterns on IncomeListResponseModel {
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
    TResult Function(_IncomeListResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncomeListResponseModel() when $default != null:
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
    TResult Function(_IncomeListResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeListResponseModel():
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
    TResult? Function(_IncomeListResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeListResponseModel() when $default != null:
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
    TResult Function(List<IncomeModel> incomes, double totalAmount, int count)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncomeListResponseModel() when $default != null:
        return $default(_that.incomes, _that.totalAmount, _that.count);
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
    TResult Function(List<IncomeModel> incomes, double totalAmount, int count)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeListResponseModel():
        return $default(_that.incomes, _that.totalAmount, _that.count);
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
    TResult? Function(List<IncomeModel> incomes, double totalAmount, int count)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncomeListResponseModel() when $default != null:
        return $default(_that.incomes, _that.totalAmount, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IncomeListResponseModel implements IncomeListResponseModel {
  const _IncomeListResponseModel(
      {required final List<IncomeModel> incomes,
      required this.totalAmount,
      required this.count})
      : _incomes = incomes;
  factory _IncomeListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeListResponseModelFromJson(json);

  final List<IncomeModel> _incomes;
  @override
  List<IncomeModel> get incomes {
    if (_incomes is EqualUnmodifiableListView) return _incomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomes);
  }

  @override
  final double totalAmount;
  @override
  final int count;

  /// Create a copy of IncomeListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IncomeListResponseModelCopyWith<_IncomeListResponseModel> get copyWith =>
      __$IncomeListResponseModelCopyWithImpl<_IncomeListResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IncomeListResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IncomeListResponseModel &&
            const DeepCollectionEquality().equals(other._incomes, _incomes) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_incomes), totalAmount, count);

  @override
  String toString() {
    return 'IncomeListResponseModel(incomes: $incomes, totalAmount: $totalAmount, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$IncomeListResponseModelCopyWith<$Res>
    implements $IncomeListResponseModelCopyWith<$Res> {
  factory _$IncomeListResponseModelCopyWith(_IncomeListResponseModel value,
          $Res Function(_IncomeListResponseModel) _then) =
      __$IncomeListResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<IncomeModel> incomes, double totalAmount, int count});
}

/// @nodoc
class __$IncomeListResponseModelCopyWithImpl<$Res>
    implements _$IncomeListResponseModelCopyWith<$Res> {
  __$IncomeListResponseModelCopyWithImpl(this._self, this._then);

  final _IncomeListResponseModel _self;
  final $Res Function(_IncomeListResponseModel) _then;

  /// Create a copy of IncomeListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? incomes = null,
    Object? totalAmount = null,
    Object? count = null,
  }) {
    return _then(_IncomeListResponseModel(
      incomes: null == incomes
          ? _self._incomes
          : incomes // ignore: cast_nullable_to_non_nullable
              as List<IncomeModel>,
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
