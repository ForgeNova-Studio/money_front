// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatisticsState {
  /// 선택된 월
  DateTime get selectedMonth;

  /// 현재 월 (미래 이동 방지용)
  DateTime get currentMonth;

  /// 월 통계 데이터
  AsyncValue<MonthlyStatistics?> get statistics;

  /// 카테고리별 전월 대비 데이터
  AsyncValue<CategoryMonthlyComparison?> get categoryComparison;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatisticsStateCopyWith<StatisticsState> get copyWith =>
      _$StatisticsStateCopyWithImpl<StatisticsState>(
          this as StatisticsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatisticsState &&
            (identical(other.selectedMonth, selectedMonth) ||
                other.selectedMonth == selectedMonth) &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics) &&
            (identical(other.categoryComparison, categoryComparison) ||
                other.categoryComparison == categoryComparison));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, selectedMonth, currentMonth, statistics, categoryComparison);

  @override
  String toString() {
    return 'StatisticsState(selectedMonth: $selectedMonth, currentMonth: $currentMonth, statistics: $statistics, categoryComparison: $categoryComparison)';
  }
}

/// @nodoc
abstract mixin class $StatisticsStateCopyWith<$Res> {
  factory $StatisticsStateCopyWith(
          StatisticsState value, $Res Function(StatisticsState) _then) =
      _$StatisticsStateCopyWithImpl;
  @useResult
  $Res call(
      {DateTime selectedMonth,
      DateTime currentMonth,
      AsyncValue<MonthlyStatistics?> statistics,
      AsyncValue<CategoryMonthlyComparison?> categoryComparison});
}

/// @nodoc
class _$StatisticsStateCopyWithImpl<$Res>
    implements $StatisticsStateCopyWith<$Res> {
  _$StatisticsStateCopyWithImpl(this._self, this._then);

  final StatisticsState _self;
  final $Res Function(StatisticsState) _then;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMonth = null,
    Object? currentMonth = null,
    Object? statistics = null,
    Object? categoryComparison = null,
  }) {
    return _then(_self.copyWith(
      selectedMonth: null == selectedMonth
          ? _self.selectedMonth
          : selectedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentMonth: null == currentMonth
          ? _self.currentMonth
          : currentMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statistics: null == statistics
          ? _self.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as AsyncValue<MonthlyStatistics?>,
      categoryComparison: null == categoryComparison
          ? _self.categoryComparison
          : categoryComparison // ignore: cast_nullable_to_non_nullable
              as AsyncValue<CategoryMonthlyComparison?>,
    ));
  }
}

/// Adds pattern-matching-related methods to [StatisticsState].
extension StatisticsStatePatterns on StatisticsState {
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
    TResult Function(_StatisticsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatisticsState() when $default != null:
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
    TResult Function(_StatisticsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatisticsState():
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
    TResult? Function(_StatisticsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatisticsState() when $default != null:
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
            DateTime selectedMonth,
            DateTime currentMonth,
            AsyncValue<MonthlyStatistics?> statistics,
            AsyncValue<CategoryMonthlyComparison?> categoryComparison)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatisticsState() when $default != null:
        return $default(_that.selectedMonth, _that.currentMonth,
            _that.statistics, _that.categoryComparison);
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
            DateTime selectedMonth,
            DateTime currentMonth,
            AsyncValue<MonthlyStatistics?> statistics,
            AsyncValue<CategoryMonthlyComparison?> categoryComparison)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatisticsState():
        return $default(_that.selectedMonth, _that.currentMonth,
            _that.statistics, _that.categoryComparison);
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
            DateTime selectedMonth,
            DateTime currentMonth,
            AsyncValue<MonthlyStatistics?> statistics,
            AsyncValue<CategoryMonthlyComparison?> categoryComparison)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatisticsState() when $default != null:
        return $default(_that.selectedMonth, _that.currentMonth,
            _that.statistics, _that.categoryComparison);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StatisticsState extends StatisticsState {
  const _StatisticsState(
      {required this.selectedMonth,
      required this.currentMonth,
      this.statistics = const AsyncValue.loading(),
      this.categoryComparison = const AsyncValue.loading()})
      : super._();

  /// 선택된 월
  @override
  final DateTime selectedMonth;

  /// 현재 월 (미래 이동 방지용)
  @override
  final DateTime currentMonth;

  /// 월 통계 데이터
  @override
  @JsonKey()
  final AsyncValue<MonthlyStatistics?> statistics;

  /// 카테고리별 전월 대비 데이터
  @override
  @JsonKey()
  final AsyncValue<CategoryMonthlyComparison?> categoryComparison;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatisticsStateCopyWith<_StatisticsState> get copyWith =>
      __$StatisticsStateCopyWithImpl<_StatisticsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatisticsState &&
            (identical(other.selectedMonth, selectedMonth) ||
                other.selectedMonth == selectedMonth) &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics) &&
            (identical(other.categoryComparison, categoryComparison) ||
                other.categoryComparison == categoryComparison));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, selectedMonth, currentMonth, statistics, categoryComparison);

  @override
  String toString() {
    return 'StatisticsState(selectedMonth: $selectedMonth, currentMonth: $currentMonth, statistics: $statistics, categoryComparison: $categoryComparison)';
  }
}

/// @nodoc
abstract mixin class _$StatisticsStateCopyWith<$Res>
    implements $StatisticsStateCopyWith<$Res> {
  factory _$StatisticsStateCopyWith(
          _StatisticsState value, $Res Function(_StatisticsState) _then) =
      __$StatisticsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime selectedMonth,
      DateTime currentMonth,
      AsyncValue<MonthlyStatistics?> statistics,
      AsyncValue<CategoryMonthlyComparison?> categoryComparison});
}

/// @nodoc
class __$StatisticsStateCopyWithImpl<$Res>
    implements _$StatisticsStateCopyWith<$Res> {
  __$StatisticsStateCopyWithImpl(this._self, this._then);

  final _StatisticsState _self;
  final $Res Function(_StatisticsState) _then;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedMonth = null,
    Object? currentMonth = null,
    Object? statistics = null,
    Object? categoryComparison = null,
  }) {
    return _then(_StatisticsState(
      selectedMonth: null == selectedMonth
          ? _self.selectedMonth
          : selectedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentMonth: null == currentMonth
          ? _self.currentMonth
          : currentMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statistics: null == statistics
          ? _self.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as AsyncValue<MonthlyStatistics?>,
      categoryComparison: null == categoryComparison
          ? _self.categoryComparison
          : categoryComparison // ignore: cast_nullable_to_non_nullable
              as AsyncValue<CategoryMonthlyComparison?>,
    ));
  }
}

// dart format on
