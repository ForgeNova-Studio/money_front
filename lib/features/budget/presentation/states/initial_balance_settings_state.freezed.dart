// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'initial_balance_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InitialBalanceSettingsState {
  bool get isLoading;
  bool get isSaving;
  bool get isNegative;
  double? get currentTotalAssets;
  int? get initialAmount;
  InitialBalanceSettingsEvent? get event;

  /// Create a copy of InitialBalanceSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InitialBalanceSettingsStateCopyWith<InitialBalanceSettingsState>
      get copyWith => _$InitialBalanceSettingsStateCopyWithImpl<
              InitialBalanceSettingsState>(
          this as InitialBalanceSettingsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InitialBalanceSettingsState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isNegative, isNegative) ||
                other.isNegative == isNegative) &&
            (identical(other.currentTotalAssets, currentTotalAssets) ||
                other.currentTotalAssets == currentTotalAssets) &&
            (identical(other.initialAmount, initialAmount) ||
                other.initialAmount == initialAmount) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isSaving, isNegative,
      currentTotalAssets, initialAmount, event);

  @override
  String toString() {
    return 'InitialBalanceSettingsState(isLoading: $isLoading, isSaving: $isSaving, isNegative: $isNegative, currentTotalAssets: $currentTotalAssets, initialAmount: $initialAmount, event: $event)';
  }
}

/// @nodoc
abstract mixin class $InitialBalanceSettingsStateCopyWith<$Res> {
  factory $InitialBalanceSettingsStateCopyWith(
          InitialBalanceSettingsState value,
          $Res Function(InitialBalanceSettingsState) _then) =
      _$InitialBalanceSettingsStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool isSaving,
      bool isNegative,
      double? currentTotalAssets,
      int? initialAmount,
      InitialBalanceSettingsEvent? event});
}

/// @nodoc
class _$InitialBalanceSettingsStateCopyWithImpl<$Res>
    implements $InitialBalanceSettingsStateCopyWith<$Res> {
  _$InitialBalanceSettingsStateCopyWithImpl(this._self, this._then);

  final InitialBalanceSettingsState _self;
  final $Res Function(InitialBalanceSettingsState) _then;

  /// Create a copy of InitialBalanceSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isNegative = null,
    Object? currentTotalAssets = freezed,
    Object? initialAmount = freezed,
    Object? event = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isNegative: null == isNegative
          ? _self.isNegative
          : isNegative // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTotalAssets: freezed == currentTotalAssets
          ? _self.currentTotalAssets
          : currentTotalAssets // ignore: cast_nullable_to_non_nullable
              as double?,
      initialAmount: freezed == initialAmount
          ? _self.initialAmount
          : initialAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      event: freezed == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as InitialBalanceSettingsEvent?,
    ));
  }
}

/// Adds pattern-matching-related methods to [InitialBalanceSettingsState].
extension InitialBalanceSettingsStatePatterns on InitialBalanceSettingsState {
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
    TResult Function(_InitialBalanceSettingsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InitialBalanceSettingsState() when $default != null:
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
    TResult Function(_InitialBalanceSettingsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InitialBalanceSettingsState():
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
    TResult? Function(_InitialBalanceSettingsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InitialBalanceSettingsState() when $default != null:
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
            bool isLoading,
            bool isSaving,
            bool isNegative,
            double? currentTotalAssets,
            int? initialAmount,
            InitialBalanceSettingsEvent? event)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InitialBalanceSettingsState() when $default != null:
        return $default(_that.isLoading, _that.isSaving, _that.isNegative,
            _that.currentTotalAssets, _that.initialAmount, _that.event);
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
            bool isLoading,
            bool isSaving,
            bool isNegative,
            double? currentTotalAssets,
            int? initialAmount,
            InitialBalanceSettingsEvent? event)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InitialBalanceSettingsState():
        return $default(_that.isLoading, _that.isSaving, _that.isNegative,
            _that.currentTotalAssets, _that.initialAmount, _that.event);
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
            bool isLoading,
            bool isSaving,
            bool isNegative,
            double? currentTotalAssets,
            int? initialAmount,
            InitialBalanceSettingsEvent? event)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InitialBalanceSettingsState() when $default != null:
        return $default(_that.isLoading, _that.isSaving, _that.isNegative,
            _that.currentTotalAssets, _that.initialAmount, _that.event);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InitialBalanceSettingsState extends InitialBalanceSettingsState {
  const _InitialBalanceSettingsState(
      {this.isLoading = false,
      this.isSaving = false,
      this.isNegative = false,
      this.currentTotalAssets,
      this.initialAmount,
      this.event})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isNegative;
  @override
  final double? currentTotalAssets;
  @override
  final int? initialAmount;
  @override
  final InitialBalanceSettingsEvent? event;

  /// Create a copy of InitialBalanceSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitialBalanceSettingsStateCopyWith<_InitialBalanceSettingsState>
      get copyWith => __$InitialBalanceSettingsStateCopyWithImpl<
          _InitialBalanceSettingsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InitialBalanceSettingsState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isNegative, isNegative) ||
                other.isNegative == isNegative) &&
            (identical(other.currentTotalAssets, currentTotalAssets) ||
                other.currentTotalAssets == currentTotalAssets) &&
            (identical(other.initialAmount, initialAmount) ||
                other.initialAmount == initialAmount) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isSaving, isNegative,
      currentTotalAssets, initialAmount, event);

  @override
  String toString() {
    return 'InitialBalanceSettingsState(isLoading: $isLoading, isSaving: $isSaving, isNegative: $isNegative, currentTotalAssets: $currentTotalAssets, initialAmount: $initialAmount, event: $event)';
  }
}

/// @nodoc
abstract mixin class _$InitialBalanceSettingsStateCopyWith<$Res>
    implements $InitialBalanceSettingsStateCopyWith<$Res> {
  factory _$InitialBalanceSettingsStateCopyWith(
          _InitialBalanceSettingsState value,
          $Res Function(_InitialBalanceSettingsState) _then) =
      __$InitialBalanceSettingsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isSaving,
      bool isNegative,
      double? currentTotalAssets,
      int? initialAmount,
      InitialBalanceSettingsEvent? event});
}

/// @nodoc
class __$InitialBalanceSettingsStateCopyWithImpl<$Res>
    implements _$InitialBalanceSettingsStateCopyWith<$Res> {
  __$InitialBalanceSettingsStateCopyWithImpl(this._self, this._then);

  final _InitialBalanceSettingsState _self;
  final $Res Function(_InitialBalanceSettingsState) _then;

  /// Create a copy of InitialBalanceSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isNegative = null,
    Object? currentTotalAssets = freezed,
    Object? initialAmount = freezed,
    Object? event = freezed,
  }) {
    return _then(_InitialBalanceSettingsState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isNegative: null == isNegative
          ? _self.isNegative
          : isNegative // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTotalAssets: freezed == currentTotalAssets
          ? _self.currentTotalAssets
          : currentTotalAssets // ignore: cast_nullable_to_non_nullable
              as double?,
      initialAmount: freezed == initialAmount
          ? _self.initialAmount
          : initialAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      event: freezed == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as InitialBalanceSettingsEvent?,
    ));
  }
}

// dart format on
