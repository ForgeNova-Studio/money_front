// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterFormState {
  String get displayName;
  String get email;
  String get password;
  String get confirmPassword;
  String get verificationCode;
  Gender? get selectedGender;
  bool get isPasswordVisible;
  bool get isConfirmPasswordVisible;
  bool get isTermsAgreed;
  bool get isVerificationCodeSent;
  bool get isEmailVerified;
  String? get emailError;
  String? get passwordError;

  /// Create a copy of RegisterFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegisterFormStateCopyWith<RegisterFormState> get copyWith =>
      _$RegisterFormStateCopyWithImpl<RegisterFormState>(
          this as RegisterFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegisterFormState &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.selectedGender, selectedGender) ||
                other.selectedGender == selectedGender) &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible) &&
            (identical(
                    other.isConfirmPasswordVisible, isConfirmPasswordVisible) ||
                other.isConfirmPasswordVisible == isConfirmPasswordVisible) &&
            (identical(other.isTermsAgreed, isTermsAgreed) ||
                other.isTermsAgreed == isTermsAgreed) &&
            (identical(other.isVerificationCodeSent, isVerificationCodeSent) ||
                other.isVerificationCodeSent == isVerificationCodeSent) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      displayName,
      email,
      password,
      confirmPassword,
      verificationCode,
      selectedGender,
      isPasswordVisible,
      isConfirmPasswordVisible,
      isTermsAgreed,
      isVerificationCodeSent,
      isEmailVerified,
      emailError,
      passwordError);

  @override
  String toString() {
    return 'RegisterFormState(displayName: $displayName, email: $email, password: $password, confirmPassword: $confirmPassword, verificationCode: $verificationCode, selectedGender: $selectedGender, isPasswordVisible: $isPasswordVisible, isConfirmPasswordVisible: $isConfirmPasswordVisible, isTermsAgreed: $isTermsAgreed, isVerificationCodeSent: $isVerificationCodeSent, isEmailVerified: $isEmailVerified, emailError: $emailError, passwordError: $passwordError)';
  }
}

/// @nodoc
abstract mixin class $RegisterFormStateCopyWith<$Res> {
  factory $RegisterFormStateCopyWith(
          RegisterFormState value, $Res Function(RegisterFormState) _then) =
      _$RegisterFormStateCopyWithImpl;
  @useResult
  $Res call(
      {String displayName,
      String email,
      String password,
      String confirmPassword,
      String verificationCode,
      Gender? selectedGender,
      bool isPasswordVisible,
      bool isConfirmPasswordVisible,
      bool isTermsAgreed,
      bool isVerificationCodeSent,
      bool isEmailVerified,
      String? emailError,
      String? passwordError});
}

/// @nodoc
class _$RegisterFormStateCopyWithImpl<$Res>
    implements $RegisterFormStateCopyWith<$Res> {
  _$RegisterFormStateCopyWithImpl(this._self, this._then);

  final RegisterFormState _self;
  final $Res Function(RegisterFormState) _then;

  /// Create a copy of RegisterFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? verificationCode = null,
    Object? selectedGender = freezed,
    Object? isPasswordVisible = null,
    Object? isConfirmPasswordVisible = null,
    Object? isTermsAgreed = null,
    Object? isVerificationCodeSent = null,
    Object? isEmailVerified = null,
    Object? emailError = freezed,
    Object? passwordError = freezed,
  }) {
    return _then(_self.copyWith(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _self.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      verificationCode: null == verificationCode
          ? _self.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedGender: freezed == selectedGender
          ? _self.selectedGender
          : selectedGender // ignore: cast_nullable_to_non_nullable
              as Gender?,
      isPasswordVisible: null == isPasswordVisible
          ? _self.isPasswordVisible
          : isPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmPasswordVisible: null == isConfirmPasswordVisible
          ? _self.isConfirmPasswordVisible
          : isConfirmPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isTermsAgreed: null == isTermsAgreed
          ? _self.isTermsAgreed
          : isTermsAgreed // ignore: cast_nullable_to_non_nullable
              as bool,
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
      passwordError: freezed == passwordError
          ? _self.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RegisterFormState].
extension RegisterFormStatePatterns on RegisterFormState {
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
    TResult Function(_RegisterFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RegisterFormState() when $default != null:
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
    TResult Function(_RegisterFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterFormState():
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
    TResult? Function(_RegisterFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterFormState() when $default != null:
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
            String displayName,
            String email,
            String password,
            String confirmPassword,
            String verificationCode,
            Gender? selectedGender,
            bool isPasswordVisible,
            bool isConfirmPasswordVisible,
            bool isTermsAgreed,
            bool isVerificationCodeSent,
            bool isEmailVerified,
            String? emailError,
            String? passwordError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RegisterFormState() when $default != null:
        return $default(
            _that.displayName,
            _that.email,
            _that.password,
            _that.confirmPassword,
            _that.verificationCode,
            _that.selectedGender,
            _that.isPasswordVisible,
            _that.isConfirmPasswordVisible,
            _that.isTermsAgreed,
            _that.isVerificationCodeSent,
            _that.isEmailVerified,
            _that.emailError,
            _that.passwordError);
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
            String displayName,
            String email,
            String password,
            String confirmPassword,
            String verificationCode,
            Gender? selectedGender,
            bool isPasswordVisible,
            bool isConfirmPasswordVisible,
            bool isTermsAgreed,
            bool isVerificationCodeSent,
            bool isEmailVerified,
            String? emailError,
            String? passwordError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterFormState():
        return $default(
            _that.displayName,
            _that.email,
            _that.password,
            _that.confirmPassword,
            _that.verificationCode,
            _that.selectedGender,
            _that.isPasswordVisible,
            _that.isConfirmPasswordVisible,
            _that.isTermsAgreed,
            _that.isVerificationCodeSent,
            _that.isEmailVerified,
            _that.emailError,
            _that.passwordError);
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
            String displayName,
            String email,
            String password,
            String confirmPassword,
            String verificationCode,
            Gender? selectedGender,
            bool isPasswordVisible,
            bool isConfirmPasswordVisible,
            bool isTermsAgreed,
            bool isVerificationCodeSent,
            bool isEmailVerified,
            String? emailError,
            String? passwordError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterFormState() when $default != null:
        return $default(
            _that.displayName,
            _that.email,
            _that.password,
            _that.confirmPassword,
            _that.verificationCode,
            _that.selectedGender,
            _that.isPasswordVisible,
            _that.isConfirmPasswordVisible,
            _that.isTermsAgreed,
            _that.isVerificationCodeSent,
            _that.isEmailVerified,
            _that.emailError,
            _that.passwordError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RegisterFormState extends RegisterFormState {
  const _RegisterFormState(
      {this.displayName = '',
      this.email = '',
      this.password = '',
      this.confirmPassword = '',
      this.verificationCode = '',
      this.selectedGender,
      this.isPasswordVisible = false,
      this.isConfirmPasswordVisible = false,
      this.isTermsAgreed = false,
      this.isVerificationCodeSent = false,
      this.isEmailVerified = false,
      this.emailError,
      this.passwordError})
      : super._();

  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String confirmPassword;
  @override
  @JsonKey()
  final String verificationCode;
  @override
  final Gender? selectedGender;
  @override
  @JsonKey()
  final bool isPasswordVisible;
  @override
  @JsonKey()
  final bool isConfirmPasswordVisible;
  @override
  @JsonKey()
  final bool isTermsAgreed;
  @override
  @JsonKey()
  final bool isVerificationCodeSent;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  final String? emailError;
  @override
  final String? passwordError;

  /// Create a copy of RegisterFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RegisterFormStateCopyWith<_RegisterFormState> get copyWith =>
      __$RegisterFormStateCopyWithImpl<_RegisterFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RegisterFormState &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.selectedGender, selectedGender) ||
                other.selectedGender == selectedGender) &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible) &&
            (identical(
                    other.isConfirmPasswordVisible, isConfirmPasswordVisible) ||
                other.isConfirmPasswordVisible == isConfirmPasswordVisible) &&
            (identical(other.isTermsAgreed, isTermsAgreed) ||
                other.isTermsAgreed == isTermsAgreed) &&
            (identical(other.isVerificationCodeSent, isVerificationCodeSent) ||
                other.isVerificationCodeSent == isVerificationCodeSent) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      displayName,
      email,
      password,
      confirmPassword,
      verificationCode,
      selectedGender,
      isPasswordVisible,
      isConfirmPasswordVisible,
      isTermsAgreed,
      isVerificationCodeSent,
      isEmailVerified,
      emailError,
      passwordError);

  @override
  String toString() {
    return 'RegisterFormState(displayName: $displayName, email: $email, password: $password, confirmPassword: $confirmPassword, verificationCode: $verificationCode, selectedGender: $selectedGender, isPasswordVisible: $isPasswordVisible, isConfirmPasswordVisible: $isConfirmPasswordVisible, isTermsAgreed: $isTermsAgreed, isVerificationCodeSent: $isVerificationCodeSent, isEmailVerified: $isEmailVerified, emailError: $emailError, passwordError: $passwordError)';
  }
}

/// @nodoc
abstract mixin class _$RegisterFormStateCopyWith<$Res>
    implements $RegisterFormStateCopyWith<$Res> {
  factory _$RegisterFormStateCopyWith(
          _RegisterFormState value, $Res Function(_RegisterFormState) _then) =
      __$RegisterFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String displayName,
      String email,
      String password,
      String confirmPassword,
      String verificationCode,
      Gender? selectedGender,
      bool isPasswordVisible,
      bool isConfirmPasswordVisible,
      bool isTermsAgreed,
      bool isVerificationCodeSent,
      bool isEmailVerified,
      String? emailError,
      String? passwordError});
}

/// @nodoc
class __$RegisterFormStateCopyWithImpl<$Res>
    implements _$RegisterFormStateCopyWith<$Res> {
  __$RegisterFormStateCopyWithImpl(this._self, this._then);

  final _RegisterFormState _self;
  final $Res Function(_RegisterFormState) _then;

  /// Create a copy of RegisterFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? displayName = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? verificationCode = null,
    Object? selectedGender = freezed,
    Object? isPasswordVisible = null,
    Object? isConfirmPasswordVisible = null,
    Object? isTermsAgreed = null,
    Object? isVerificationCodeSent = null,
    Object? isEmailVerified = null,
    Object? emailError = freezed,
    Object? passwordError = freezed,
  }) {
    return _then(_RegisterFormState(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _self.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      verificationCode: null == verificationCode
          ? _self.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedGender: freezed == selectedGender
          ? _self.selectedGender
          : selectedGender // ignore: cast_nullable_to_non_nullable
              as Gender?,
      isPasswordVisible: null == isPasswordVisible
          ? _self.isPasswordVisible
          : isPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmPasswordVisible: null == isConfirmPasswordVisible
          ? _self.isConfirmPasswordVisible
          : isConfirmPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isTermsAgreed: null == isTermsAgreed
          ? _self.isTermsAgreed
          : isTermsAgreed // ignore: cast_nullable_to_non_nullable
              as bool,
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
      passwordError: freezed == passwordError
          ? _self.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
