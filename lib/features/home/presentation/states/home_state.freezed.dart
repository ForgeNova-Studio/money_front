// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {
  /// 월별 데이터 (날짜 문자열 Key: "yyyy-MM-dd")
  AsyncValue<Map<String, DailyTransactionSummary>> get monthlyData;

  /// 현재 달력에서 보고 있는 달의 기준 날짜
  DateTime get focusedMonth;

  /// 사용자가 선택한 구체적인 날짜
  DateTime get selectedDate;

  /// 달력 표시 형식
  CalendarFormat get calendarFormat;

  /// 이번 달 예산 정보 (null이면 예산 미설정)
  BudgetEntity? get budgetInfo;

  /// 총 자산 정보
  AssetEntity? get assetInfo;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeStateCopyWith<HomeState> get copyWith =>
      _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeState &&
            (identical(other.monthlyData, monthlyData) ||
                other.monthlyData == monthlyData) &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.calendarFormat, calendarFormat) ||
                other.calendarFormat == calendarFormat) &&
            (identical(other.budgetInfo, budgetInfo) ||
                other.budgetInfo == budgetInfo) &&
            (identical(other.assetInfo, assetInfo) ||
                other.assetInfo == assetInfo));
  }

  @override
  int get hashCode => Object.hash(runtimeType, monthlyData, focusedMonth,
      selectedDate, calendarFormat, budgetInfo, assetInfo);

  @override
  String toString() {
    return 'HomeState(monthlyData: $monthlyData, focusedMonth: $focusedMonth, selectedDate: $selectedDate, calendarFormat: $calendarFormat, budgetInfo: $budgetInfo, assetInfo: $assetInfo)';
  }
}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call(
      {AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,
      DateTime focusedMonth,
      DateTime selectedDate,
      CalendarFormat calendarFormat,
      BudgetEntity? budgetInfo,
      AssetEntity? assetInfo});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlyData = null,
    Object? focusedMonth = null,
    Object? selectedDate = null,
    Object? calendarFormat = null,
    Object? budgetInfo = freezed,
    Object? assetInfo = freezed,
  }) {
    return _then(_self.copyWith(
      monthlyData: null == monthlyData
          ? _self.monthlyData
          : monthlyData // ignore: cast_nullable_to_non_nullable
              as AsyncValue<Map<String, DailyTransactionSummary>>,
      focusedMonth: null == focusedMonth
          ? _self.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDate: null == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      calendarFormat: null == calendarFormat
          ? _self.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
      budgetInfo: freezed == budgetInfo
          ? _self.budgetInfo
          : budgetInfo // ignore: cast_nullable_to_non_nullable
              as BudgetEntity?,
      assetInfo: freezed == assetInfo
          ? _self.assetInfo
          : assetInfo // ignore: cast_nullable_to_non_nullable
              as AssetEntity?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(_HomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(_HomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
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
    TResult? Function(_HomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
            AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,
            DateTime focusedMonth,
            DateTime selectedDate,
            CalendarFormat calendarFormat,
            BudgetEntity? budgetInfo,
            AssetEntity? assetInfo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.monthlyData,
            _that.focusedMonth,
            _that.selectedDate,
            _that.calendarFormat,
            _that.budgetInfo,
            _that.assetInfo);
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
            AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,
            DateTime focusedMonth,
            DateTime selectedDate,
            CalendarFormat calendarFormat,
            BudgetEntity? budgetInfo,
            AssetEntity? assetInfo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
        return $default(
            _that.monthlyData,
            _that.focusedMonth,
            _that.selectedDate,
            _that.calendarFormat,
            _that.budgetInfo,
            _that.assetInfo);
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
            AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,
            DateTime focusedMonth,
            DateTime selectedDate,
            CalendarFormat calendarFormat,
            BudgetEntity? budgetInfo,
            AssetEntity? assetInfo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.monthlyData,
            _that.focusedMonth,
            _that.selectedDate,
            _that.calendarFormat,
            _that.budgetInfo,
            _that.assetInfo);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeState implements HomeState {
  const _HomeState(
      {this.monthlyData = const AsyncValue.loading(),
      required this.focusedMonth,
      required this.selectedDate,
      this.calendarFormat = CalendarFormat.month,
      this.budgetInfo,
      this.assetInfo});

  /// 월별 데이터 (날짜 문자열 Key: "yyyy-MM-dd")
  @override
  @JsonKey()
  final AsyncValue<Map<String, DailyTransactionSummary>> monthlyData;

  /// 현재 달력에서 보고 있는 달의 기준 날짜
  @override
  final DateTime focusedMonth;

  /// 사용자가 선택한 구체적인 날짜
  @override
  final DateTime selectedDate;

  /// 달력 표시 형식
  @override
  @JsonKey()
  final CalendarFormat calendarFormat;

  /// 이번 달 예산 정보 (null이면 예산 미설정)
  @override
  final BudgetEntity? budgetInfo;

  /// 총 자산 정보
  @override
  final AssetEntity? assetInfo;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeStateCopyWith<_HomeState> get copyWith =>
      __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeState &&
            (identical(other.monthlyData, monthlyData) ||
                other.monthlyData == monthlyData) &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.calendarFormat, calendarFormat) ||
                other.calendarFormat == calendarFormat) &&
            (identical(other.budgetInfo, budgetInfo) ||
                other.budgetInfo == budgetInfo) &&
            (identical(other.assetInfo, assetInfo) ||
                other.assetInfo == assetInfo));
  }

  @override
  int get hashCode => Object.hash(runtimeType, monthlyData, focusedMonth,
      selectedDate, calendarFormat, budgetInfo, assetInfo);

  @override
  String toString() {
    return 'HomeState(monthlyData: $monthlyData, focusedMonth: $focusedMonth, selectedDate: $selectedDate, calendarFormat: $calendarFormat, budgetInfo: $budgetInfo, assetInfo: $assetInfo)';
  }
}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,
      DateTime focusedMonth,
      DateTime selectedDate,
      CalendarFormat calendarFormat,
      BudgetEntity? budgetInfo,
      AssetEntity? assetInfo});
}

/// @nodoc
class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? monthlyData = null,
    Object? focusedMonth = null,
    Object? selectedDate = null,
    Object? calendarFormat = null,
    Object? budgetInfo = freezed,
    Object? assetInfo = freezed,
  }) {
    return _then(_HomeState(
      monthlyData: null == monthlyData
          ? _self.monthlyData
          : monthlyData // ignore: cast_nullable_to_non_nullable
              as AsyncValue<Map<String, DailyTransactionSummary>>,
      focusedMonth: null == focusedMonth
          ? _self.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDate: null == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      calendarFormat: null == calendarFormat
          ? _self.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
      budgetInfo: freezed == budgetInfo
          ? _self.budgetInfo
          : budgetInfo // ignore: cast_nullable_to_non_nullable
              as BudgetEntity?,
      assetInfo: freezed == assetInfo
          ? _self.assetInfo
          : assetInfo // ignore: cast_nullable_to_non_nullable
              as AssetEntity?,
    ));
  }
}

// dart format on
