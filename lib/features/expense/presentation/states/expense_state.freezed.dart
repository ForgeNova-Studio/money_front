// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseState {
  /// 지출 목록 (AsyncValue로 로딩/에러 상태 관리)
  AsyncValue<List<Expense>> get expenses;

  /// 현재 보여지는 달력의 기준 날짜 (월 단위 조회를 위함)
  DateTime get focusedDay;

  /// 사용자가 선택한 특정 날짜 (null이면 해당 월 전체)
  DateTime? get selectedDate;

  /// 총 지출 금액 (현재 조회된 목록 기준)
  double get totalAmount;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseStateCopyWith<ExpenseState> get copyWith =>
      _$ExpenseStateCopyWithImpl<ExpenseState>(
          this as ExpenseState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseState &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.focusedDay, focusedDay) ||
                other.focusedDay == focusedDay) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, expenses, focusedDay, selectedDate, totalAmount);

  @override
  String toString() {
    return 'ExpenseState(expenses: $expenses, focusedDay: $focusedDay, selectedDate: $selectedDate, totalAmount: $totalAmount)';
  }
}

/// @nodoc
abstract mixin class $ExpenseStateCopyWith<$Res> {
  factory $ExpenseStateCopyWith(
          ExpenseState value, $Res Function(ExpenseState) _then) =
      _$ExpenseStateCopyWithImpl;
  @useResult
  $Res call(
      {AsyncValue<List<Expense>> expenses,
      DateTime focusedDay,
      DateTime? selectedDate,
      double totalAmount});
}

/// @nodoc
class _$ExpenseStateCopyWithImpl<$Res> implements $ExpenseStateCopyWith<$Res> {
  _$ExpenseStateCopyWithImpl(this._self, this._then);

  final ExpenseState _self;
  final $Res Function(ExpenseState) _then;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenses = null,
    Object? focusedDay = null,
    Object? selectedDate = freezed,
    Object? totalAmount = null,
  }) {
    return _then(_self.copyWith(
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<Expense>>,
      focusedDay: null == focusedDay
          ? _self.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExpenseState].
extension ExpenseStatePatterns on ExpenseState {
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
    TResult Function(_ExpenseState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseState() when $default != null:
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
    TResult Function(_ExpenseState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseState():
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
    TResult? Function(_ExpenseState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseState() when $default != null:
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
    TResult Function(AsyncValue<List<Expense>> expenses, DateTime focusedDay,
            DateTime? selectedDate, double totalAmount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseState() when $default != null:
        return $default(_that.expenses, _that.focusedDay, _that.selectedDate,
            _that.totalAmount);
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
    TResult Function(AsyncValue<List<Expense>> expenses, DateTime focusedDay,
            DateTime? selectedDate, double totalAmount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseState():
        return $default(_that.expenses, _that.focusedDay, _that.selectedDate,
            _that.totalAmount);
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
    TResult? Function(AsyncValue<List<Expense>> expenses, DateTime focusedDay,
            DateTime? selectedDate, double totalAmount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseState() when $default != null:
        return $default(_that.expenses, _that.focusedDay, _that.selectedDate,
            _that.totalAmount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ExpenseState implements ExpenseState {
  const _ExpenseState(
      {this.expenses = const AsyncValue.loading(),
      required this.focusedDay,
      this.selectedDate,
      this.totalAmount = 0});

  /// 지출 목록 (AsyncValue로 로딩/에러 상태 관리)
  @override
  @JsonKey()
  final AsyncValue<List<Expense>> expenses;

  /// 현재 보여지는 달력의 기준 날짜 (월 단위 조회를 위함)
  @override
  final DateTime focusedDay;

  /// 사용자가 선택한 특정 날짜 (null이면 해당 월 전체)
  @override
  final DateTime? selectedDate;

  /// 총 지출 금액 (현재 조회된 목록 기준)
  @override
  @JsonKey()
  final double totalAmount;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseStateCopyWith<_ExpenseState> get copyWith =>
      __$ExpenseStateCopyWithImpl<_ExpenseState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseState &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.focusedDay, focusedDay) ||
                other.focusedDay == focusedDay) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, expenses, focusedDay, selectedDate, totalAmount);

  @override
  String toString() {
    return 'ExpenseState(expenses: $expenses, focusedDay: $focusedDay, selectedDate: $selectedDate, totalAmount: $totalAmount)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseStateCopyWith<$Res>
    implements $ExpenseStateCopyWith<$Res> {
  factory _$ExpenseStateCopyWith(
          _ExpenseState value, $Res Function(_ExpenseState) _then) =
      __$ExpenseStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AsyncValue<List<Expense>> expenses,
      DateTime focusedDay,
      DateTime? selectedDate,
      double totalAmount});
}

/// @nodoc
class __$ExpenseStateCopyWithImpl<$Res>
    implements _$ExpenseStateCopyWith<$Res> {
  __$ExpenseStateCopyWithImpl(this._self, this._then);

  final _ExpenseState _self;
  final $Res Function(_ExpenseState) _then;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expenses = null,
    Object? focusedDay = null,
    Object? selectedDate = freezed,
    Object? totalAmount = null,
  }) {
    return _then(_ExpenseState(
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<Expense>>,
      focusedDay: null == focusedDay
          ? _self.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
