// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_expenses_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingExpensesState {
  /// 대기 중인 지출 목록
  List<PendingExpense> get pendingExpenses;

  /// 저장 중 여부
  bool get isSaving;

  /// 에러 메시지
  String? get error;

  /// Create a copy of PendingExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingExpensesStateCopyWith<PendingExpensesState> get copyWith =>
      _$PendingExpensesStateCopyWithImpl<PendingExpensesState>(
          this as PendingExpensesState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingExpensesState &&
            const DeepCollectionEquality()
                .equals(other.pendingExpenses, pendingExpenses) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(pendingExpenses), isSaving, error);

  @override
  String toString() {
    return 'PendingExpensesState(pendingExpenses: $pendingExpenses, isSaving: $isSaving, error: $error)';
  }
}

/// @nodoc
abstract mixin class $PendingExpensesStateCopyWith<$Res> {
  factory $PendingExpensesStateCopyWith(PendingExpensesState value,
          $Res Function(PendingExpensesState) _then) =
      _$PendingExpensesStateCopyWithImpl;
  @useResult
  $Res call(
      {List<PendingExpense> pendingExpenses, bool isSaving, String? error});
}

/// @nodoc
class _$PendingExpensesStateCopyWithImpl<$Res>
    implements $PendingExpensesStateCopyWith<$Res> {
  _$PendingExpensesStateCopyWithImpl(this._self, this._then);

  final PendingExpensesState _self;
  final $Res Function(PendingExpensesState) _then;

  /// Create a copy of PendingExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingExpenses = null,
    Object? isSaving = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      pendingExpenses: null == pendingExpenses
          ? _self.pendingExpenses
          : pendingExpenses // ignore: cast_nullable_to_non_nullable
              as List<PendingExpense>,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PendingExpensesState].
extension PendingExpensesStatePatterns on PendingExpensesState {
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
    TResult Function(_PendingExpensesState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingExpensesState() when $default != null:
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
    TResult Function(_PendingExpensesState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpensesState():
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
    TResult? Function(_PendingExpensesState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpensesState() when $default != null:
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
            List<PendingExpense> pendingExpenses, bool isSaving, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingExpensesState() when $default != null:
        return $default(_that.pendingExpenses, _that.isSaving, _that.error);
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
            List<PendingExpense> pendingExpenses, bool isSaving, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpensesState():
        return $default(_that.pendingExpenses, _that.isSaving, _that.error);
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
            List<PendingExpense> pendingExpenses, bool isSaving, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpensesState() when $default != null:
        return $default(_that.pendingExpenses, _that.isSaving, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PendingExpensesState extends PendingExpensesState {
  const _PendingExpensesState(
      {final List<PendingExpense> pendingExpenses = const [],
      this.isSaving = false,
      this.error})
      : _pendingExpenses = pendingExpenses,
        super._();

  /// 대기 중인 지출 목록
  final List<PendingExpense> _pendingExpenses;

  /// 대기 중인 지출 목록
  @override
  @JsonKey()
  List<PendingExpense> get pendingExpenses {
    if (_pendingExpenses is EqualUnmodifiableListView) return _pendingExpenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingExpenses);
  }

  /// 저장 중 여부
  @override
  @JsonKey()
  final bool isSaving;

  /// 에러 메시지
  @override
  final String? error;

  /// Create a copy of PendingExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingExpensesStateCopyWith<_PendingExpensesState> get copyWith =>
      __$PendingExpensesStateCopyWithImpl<_PendingExpensesState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PendingExpensesState &&
            const DeepCollectionEquality()
                .equals(other._pendingExpenses, _pendingExpenses) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_pendingExpenses), isSaving, error);

  @override
  String toString() {
    return 'PendingExpensesState(pendingExpenses: $pendingExpenses, isSaving: $isSaving, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$PendingExpensesStateCopyWith<$Res>
    implements $PendingExpensesStateCopyWith<$Res> {
  factory _$PendingExpensesStateCopyWith(_PendingExpensesState value,
          $Res Function(_PendingExpensesState) _then) =
      __$PendingExpensesStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<PendingExpense> pendingExpenses, bool isSaving, String? error});
}

/// @nodoc
class __$PendingExpensesStateCopyWithImpl<$Res>
    implements _$PendingExpensesStateCopyWith<$Res> {
  __$PendingExpensesStateCopyWithImpl(this._self, this._then);

  final _PendingExpensesState _self;
  final $Res Function(_PendingExpensesState) _then;

  /// Create a copy of PendingExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pendingExpenses = null,
    Object? isSaving = null,
    Object? error = freezed,
  }) {
    return _then(_PendingExpensesState(
      pendingExpenses: null == pendingExpenses
          ? _self._pendingExpenses
          : pendingExpenses // ignore: cast_nullable_to_non_nullable
              as List<PendingExpense>,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
