// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'find_password_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FindPasswordFormState {
  String get email;
  String get verificationCode;
  bool get isVerificationCodeSent;
  bool get isEmailVerified;
  String? get emailError;

  /// Create a copy of FindPasswordFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FindPasswordFormStateCopyWith<FindPasswordFormState> get copyWith =>
      _$FindPasswordFormStateCopyWithImpl<FindPasswordFormState>(
          this as FindPasswordFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FindPasswordFormState &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.isVerificationCodeSent, isVerificationCodeSent) ||
                other.isVerificationCodeSent == isVerificationCodeSent) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, verificationCode,
      isVerificationCodeSent, isEmailVerified, emailError);

  @override
  String toString() {
    return 'FindPasswordFormState(email: $email, verificationCode: $verificationCode, isVerificationCodeSent: $isVerificationCodeSent, isEmailVerified: $isEmailVerified, emailError: $emailError)';
  }
}

/// @nodoc
abstract mixin class $FindPasswordFormStateCopyWith<$Res> {
  factory $FindPasswordFormStateCopyWith(FindPasswordFormState value,
          $Res Function(FindPasswordFormState) _then) =
      _$FindPasswordFormStateCopyWithImpl;
  @useResult
  $Res call(
      {String email,
      String verificationCode,
      bool isVerificationCodeSent,
      bool isEmailVerified,
      String? emailError});
}

/// @nodoc
class _$FindPasswordFormStateCopyWithImpl<$Res>
    implements $FindPasswordFormStateCopyWith<$Res> {
  _$FindPasswordFormStateCopyWithImpl(this._self, this._then);

  final FindPasswordFormState _self;
  final $Res Function(FindPasswordFormState) _then;

  /// Create a copy of FindPasswordFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? verificationCode = null,
    Object? isVerificationCodeSent = null,
    Object? isEmailVerified = null,
    Object? emailError = freezed,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      verificationCode: null == verificationCode
          ? _self.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String,
      isVerificationCodeSent: null == isVerificationCodeSent
          ? _self.isVerificationCodeSent
          : isVerificationCodeSent // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailVerified: null == isEmailVerified
          ? _self.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      emailError: freezed == emailError
          ? _self.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FindPasswordFormState].
extension FindPasswordFormStatePatterns on FindPasswordFormState {
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
    TResult Function(_FindPasswordFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FindPasswordFormState() when $default != null:
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
    TResult Function(_FindPasswordFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordFormState():
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
    TResult? Function(_FindPasswordFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordFormState() when $default != null:
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
            String email,
            String verificationCode,
            bool isVerificationCodeSent,
            bool isEmailVerified,
            String? emailError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FindPasswordFormState() when $default != null:
        return $default(
            _that.email,
            _that.verificationCode,
            _that.isVerificationCodeSent,
            _that.isEmailVerified,
            _that.emailError);
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
            String email,
            String verificationCode,
            bool isVerificationCodeSent,
            bool isEmailVerified,
            String? emailError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordFormState():
        return $default(
            _that.email,
            _that.verificationCode,
            _that.isVerificationCodeSent,
            _that.isEmailVerified,
            _that.emailError);
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
            String email,
            String verificationCode,
            bool isVerificationCodeSent,
            bool isEmailVerified,
            String? emailError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordFormState() when $default != null:
        return $default(
            _that.email,
            _that.verificationCode,
            _that.isVerificationCodeSent,
            _that.isEmailVerified,
            _that.emailError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FindPasswordFormState extends FindPasswordFormState {
  const _FindPasswordFormState(
      {this.email = '',
      this.verificationCode = '',
      this.isVerificationCodeSent = false,
      this.isEmailVerified = false,
      this.emailError})
      : super._();

  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String verificationCode;
  @override
  @JsonKey()
  final bool isVerificationCodeSent;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  final String? emailError;

  /// Create a copy of FindPasswordFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FindPasswordFormStateCopyWith<_FindPasswordFormState> get copyWith =>
      __$FindPasswordFormStateCopyWithImpl<_FindPasswordFormState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FindPasswordFormState &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.isVerificationCodeSent, isVerificationCodeSent) ||
                other.isVerificationCodeSent == isVerificationCodeSent) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, verificationCode,
      isVerificationCodeSent, isEmailVerified, emailError);

  @override
  String toString() {
    return 'FindPasswordFormState(email: $email, verificationCode: $verificationCode, isVerificationCodeSent: $isVerificationCodeSent, isEmailVerified: $isEmailVerified, emailError: $emailError)';
  }
}

/// @nodoc
abstract mixin class _$FindPasswordFormStateCopyWith<$Res>
    implements $FindPasswordFormStateCopyWith<$Res> {
  factory _$FindPasswordFormStateCopyWith(_FindPasswordFormState value,
          $Res Function(_FindPasswordFormState) _then) =
      __$FindPasswordFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String email,
      String verificationCode,
      bool isVerificationCodeSent,
      bool isEmailVerified,
      String? emailError});
}

/// @nodoc
class __$FindPasswordFormStateCopyWithImpl<$Res>
    implements _$FindPasswordFormStateCopyWith<$Res> {
  __$FindPasswordFormStateCopyWithImpl(this._self, this._then);

  final _FindPasswordFormState _self;
  final $Res Function(_FindPasswordFormState) _then;

  /// Create a copy of FindPasswordFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? verificationCode = null,
    Object? isVerificationCodeSent = null,
    Object? isEmailVerified = null,
    Object? emailError = freezed,
  }) {
    return _then(_FindPasswordFormState(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      verificationCode: null == verificationCode
          ? _self.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String,
      isVerificationCodeSent: null == isVerificationCodeSent
          ? _self.isVerificationCodeSent
          : isVerificationCodeSent // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailVerified: null == isEmailVerified
          ? _self.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      emailError: freezed == emailError
          ? _self.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
