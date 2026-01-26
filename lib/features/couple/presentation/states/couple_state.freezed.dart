// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleState {
  Couple? get couple;
  InviteInfo? get inviteInfo;
  bool get isLoading;
  String? get errorMessage;

  /// Create a copy of CoupleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoupleStateCopyWith<CoupleState> get copyWith =>
      _$CoupleStateCopyWithImpl<CoupleState>(this as CoupleState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CoupleState &&
            (identical(other.couple, couple) || other.couple == couple) &&
            (identical(other.inviteInfo, inviteInfo) ||
                other.inviteInfo == inviteInfo) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, couple, inviteInfo, isLoading, errorMessage);

  @override
  String toString() {
    return 'CoupleState(couple: $couple, inviteInfo: $inviteInfo, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $CoupleStateCopyWith<$Res> {
  factory $CoupleStateCopyWith(
          CoupleState value, $Res Function(CoupleState) _then) =
      _$CoupleStateCopyWithImpl;
  @useResult
  $Res call(
      {Couple? couple,
      InviteInfo? inviteInfo,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$CoupleStateCopyWithImpl<$Res> implements $CoupleStateCopyWith<$Res> {
  _$CoupleStateCopyWithImpl(this._self, this._then);

  final CoupleState _self;
  final $Res Function(CoupleState) _then;

  /// Create a copy of CoupleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couple = freezed,
    Object? inviteInfo = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      couple: freezed == couple
          ? _self.couple
          : couple // ignore: cast_nullable_to_non_nullable
              as Couple?,
      inviteInfo: freezed == inviteInfo
          ? _self.inviteInfo
          : inviteInfo // ignore: cast_nullable_to_non_nullable
              as InviteInfo?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CoupleState].
extension CoupleStatePatterns on CoupleState {
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
    TResult Function(_CoupleState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoupleState() when $default != null:
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
    TResult Function(_CoupleState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleState():
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
    TResult? Function(_CoupleState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleState() when $default != null:
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
    TResult Function(Couple? couple, InviteInfo? inviteInfo, bool isLoading,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoupleState() when $default != null:
        return $default(_that.couple, _that.inviteInfo, _that.isLoading,
            _that.errorMessage);
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
    TResult Function(Couple? couple, InviteInfo? inviteInfo, bool isLoading,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleState():
        return $default(_that.couple, _that.inviteInfo, _that.isLoading,
            _that.errorMessage);
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
    TResult? Function(Couple? couple, InviteInfo? inviteInfo, bool isLoading,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleState() when $default != null:
        return $default(_that.couple, _that.inviteInfo, _that.isLoading,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CoupleState extends CoupleState {
  const _CoupleState(
      {this.couple, this.inviteInfo, this.isLoading = false, this.errorMessage})
      : super._();

  @override
  final Couple? couple;
  @override
  final InviteInfo? inviteInfo;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  /// Create a copy of CoupleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CoupleStateCopyWith<_CoupleState> get copyWith =>
      __$CoupleStateCopyWithImpl<_CoupleState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CoupleState &&
            (identical(other.couple, couple) || other.couple == couple) &&
            (identical(other.inviteInfo, inviteInfo) ||
                other.inviteInfo == inviteInfo) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, couple, inviteInfo, isLoading, errorMessage);

  @override
  String toString() {
    return 'CoupleState(couple: $couple, inviteInfo: $inviteInfo, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$CoupleStateCopyWith<$Res>
    implements $CoupleStateCopyWith<$Res> {
  factory _$CoupleStateCopyWith(
          _CoupleState value, $Res Function(_CoupleState) _then) =
      __$CoupleStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Couple? couple,
      InviteInfo? inviteInfo,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$CoupleStateCopyWithImpl<$Res> implements _$CoupleStateCopyWith<$Res> {
  __$CoupleStateCopyWithImpl(this._self, this._then);

  final _CoupleState _self;
  final $Res Function(_CoupleState) _then;

  /// Create a copy of CoupleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? couple = freezed,
    Object? inviteInfo = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_CoupleState(
      couple: freezed == couple
          ? _self.couple
          : couple // ignore: cast_nullable_to_non_nullable
              as Couple?,
      inviteInfo: freezed == inviteInfo
          ? _self.inviteInfo
          : inviteInfo // ignore: cast_nullable_to_non_nullable
              as InviteInfo?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
