// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetSettingsState {
  DateTime get currentMonth;
  DateTime get selectedMonth;
  Map<String, BudgetEntity?> get budgetCache;
  bool get isInitialLoading;
  bool get isSaving;
  bool get isDeleting;
  BudgetSettingsEvent? get event;

  /// Create a copy of BudgetSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetSettingsStateCopyWith<BudgetSettingsState> get copyWith =>
      _$BudgetSettingsStateCopyWithImpl<BudgetSettingsState>(
          this as BudgetSettingsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetSettingsState &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.selectedMonth, selectedMonth) ||
                other.selectedMonth == selectedMonth) &&
            const DeepCollectionEquality()
                .equals(other.budgetCache, budgetCache) &&
            (identical(other.isInitialLoading, isInitialLoading) ||
                other.isInitialLoading == isInitialLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentMonth,
      selectedMonth,
      const DeepCollectionEquality().hash(budgetCache),
      isInitialLoading,
      isSaving,
      isDeleting,
      event);

  @override
  String toString() {
    return 'BudgetSettingsState(currentMonth: $currentMonth, selectedMonth: $selectedMonth, budgetCache: $budgetCache, isInitialLoading: $isInitialLoading, isSaving: $isSaving, isDeleting: $isDeleting, event: $event)';
  }
}

/// @nodoc
abstract mixin class $BudgetSettingsStateCopyWith<$Res> {
  factory $BudgetSettingsStateCopyWith(
          BudgetSettingsState value, $Res Function(BudgetSettingsState) _then) =
      _$BudgetSettingsStateCopyWithImpl;
  @useResult
  $Res call(
      {DateTime currentMonth,
      DateTime selectedMonth,
      Map<String, BudgetEntity?> budgetCache,
      bool isInitialLoading,
      bool isSaving,
      bool isDeleting,
      BudgetSettingsEvent? event});
}

/// @nodoc
class _$BudgetSettingsStateCopyWithImpl<$Res>
    implements $BudgetSettingsStateCopyWith<$Res> {
  _$BudgetSettingsStateCopyWithImpl(this._self, this._then);

  final BudgetSettingsState _self;
  final $Res Function(BudgetSettingsState) _then;

  /// Create a copy of BudgetSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMonth = null,
    Object? selectedMonth = null,
    Object? budgetCache = null,
    Object? isInitialLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? event = freezed,
  }) {
    return _then(_self.copyWith(
      currentMonth: null == currentMonth
          ? _self.currentMonth
          : currentMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedMonth: null == selectedMonth
          ? _self.selectedMonth
          : selectedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      budgetCache: null == budgetCache
          ? _self.budgetCache
          : budgetCache // ignore: cast_nullable_to_non_nullable
              as Map<String, BudgetEntity?>,
      isInitialLoading: null == isInitialLoading
          ? _self.isInitialLoading
          : isInitialLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _self.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      event: freezed == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as BudgetSettingsEvent?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BudgetSettingsState].
extension BudgetSettingsStatePatterns on BudgetSettingsState {
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
    TResult Function(_BudgetSettingsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetSettingsState() when $default != null:
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
    TResult Function(_BudgetSettingsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSettingsState():
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
    TResult? Function(_BudgetSettingsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSettingsState() when $default != null:
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
            DateTime currentMonth,
            DateTime selectedMonth,
            Map<String, BudgetEntity?> budgetCache,
            bool isInitialLoading,
            bool isSaving,
            bool isDeleting,
            BudgetSettingsEvent? event)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetSettingsState() when $default != null:
        return $default(
            _that.currentMonth,
            _that.selectedMonth,
            _that.budgetCache,
            _that.isInitialLoading,
            _that.isSaving,
            _that.isDeleting,
            _that.event);
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
            DateTime currentMonth,
            DateTime selectedMonth,
            Map<String, BudgetEntity?> budgetCache,
            bool isInitialLoading,
            bool isSaving,
            bool isDeleting,
            BudgetSettingsEvent? event)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSettingsState():
        return $default(
            _that.currentMonth,
            _that.selectedMonth,
            _that.budgetCache,
            _that.isInitialLoading,
            _that.isSaving,
            _that.isDeleting,
            _that.event);
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
            DateTime currentMonth,
            DateTime selectedMonth,
            Map<String, BudgetEntity?> budgetCache,
            bool isInitialLoading,
            bool isSaving,
            bool isDeleting,
            BudgetSettingsEvent? event)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSettingsState() when $default != null:
        return $default(
            _that.currentMonth,
            _that.selectedMonth,
            _that.budgetCache,
            _that.isInitialLoading,
            _that.isSaving,
            _that.isDeleting,
            _that.event);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BudgetSettingsState extends BudgetSettingsState {
  const _BudgetSettingsState(
      {required this.currentMonth,
      required this.selectedMonth,
      final Map<String, BudgetEntity?> budgetCache =
          const <String, BudgetEntity?>{},
      this.isInitialLoading = true,
      this.isSaving = false,
      this.isDeleting = false,
      this.event})
      : _budgetCache = budgetCache,
        super._();

  @override
  final DateTime currentMonth;
  @override
  final DateTime selectedMonth;
  final Map<String, BudgetEntity?> _budgetCache;
  @override
  @JsonKey()
  Map<String, BudgetEntity?> get budgetCache {
    if (_budgetCache is EqualUnmodifiableMapView) return _budgetCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_budgetCache);
  }

  @override
  @JsonKey()
  final bool isInitialLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isDeleting;
  @override
  final BudgetSettingsEvent? event;

  /// Create a copy of BudgetSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetSettingsStateCopyWith<_BudgetSettingsState> get copyWith =>
      __$BudgetSettingsStateCopyWithImpl<_BudgetSettingsState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetSettingsState &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.selectedMonth, selectedMonth) ||
                other.selectedMonth == selectedMonth) &&
            const DeepCollectionEquality()
                .equals(other._budgetCache, _budgetCache) &&
            (identical(other.isInitialLoading, isInitialLoading) ||
                other.isInitialLoading == isInitialLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentMonth,
      selectedMonth,
      const DeepCollectionEquality().hash(_budgetCache),
      isInitialLoading,
      isSaving,
      isDeleting,
      event);

  @override
  String toString() {
    return 'BudgetSettingsState(currentMonth: $currentMonth, selectedMonth: $selectedMonth, budgetCache: $budgetCache, isInitialLoading: $isInitialLoading, isSaving: $isSaving, isDeleting: $isDeleting, event: $event)';
  }
}

/// @nodoc
abstract mixin class _$BudgetSettingsStateCopyWith<$Res>
    implements $BudgetSettingsStateCopyWith<$Res> {
  factory _$BudgetSettingsStateCopyWith(_BudgetSettingsState value,
          $Res Function(_BudgetSettingsState) _then) =
      __$BudgetSettingsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime currentMonth,
      DateTime selectedMonth,
      Map<String, BudgetEntity?> budgetCache,
      bool isInitialLoading,
      bool isSaving,
      bool isDeleting,
      BudgetSettingsEvent? event});
}

/// @nodoc
class __$BudgetSettingsStateCopyWithImpl<$Res>
    implements _$BudgetSettingsStateCopyWith<$Res> {
  __$BudgetSettingsStateCopyWithImpl(this._self, this._then);

  final _BudgetSettingsState _self;
  final $Res Function(_BudgetSettingsState) _then;

  /// Create a copy of BudgetSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentMonth = null,
    Object? selectedMonth = null,
    Object? budgetCache = null,
    Object? isInitialLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? event = freezed,
  }) {
    return _then(_BudgetSettingsState(
      currentMonth: null == currentMonth
          ? _self.currentMonth
          : currentMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedMonth: null == selectedMonth
          ? _self.selectedMonth
          : selectedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      budgetCache: null == budgetCache
          ? _self._budgetCache
          : budgetCache // ignore: cast_nullable_to_non_nullable
              as Map<String, BudgetEntity?>,
      isInitialLoading: null == isInitialLoading
          ? _self.isInitialLoading
          : isInitialLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _self.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      event: freezed == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as BudgetSettingsEvent?,
    ));
  }
}

// dart format on
