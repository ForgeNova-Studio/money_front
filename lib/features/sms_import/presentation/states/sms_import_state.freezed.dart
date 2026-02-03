// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_import_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmsImportState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SmsImportState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SmsImportState()';
  }
}

/// @nodoc
class $SmsImportStateCopyWith<$Res> {
  $SmsImportStateCopyWith(SmsImportState _, $Res Function(SmsImportState) __);
}

/// Adds pattern-matching-related methods to [SmsImportState].
extension SmsImportStatePatterns on SmsImportState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SmsImportIdle value)? idle,
    TResult Function(SmsImportParsing value)? parsing,
    TResult Function(SmsImportParsed value)? parsed,
    TResult Function(SmsImportSaving value)? saving,
    TResult Function(SmsImportSaved value)? saved,
    TResult Function(SmsImportError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SmsImportIdle() when idle != null:
        return idle(_that);
      case SmsImportParsing() when parsing != null:
        return parsing(_that);
      case SmsImportParsed() when parsed != null:
        return parsed(_that);
      case SmsImportSaving() when saving != null:
        return saving(_that);
      case SmsImportSaved() when saved != null:
        return saved(_that);
      case SmsImportError() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(SmsImportIdle value) idle,
    required TResult Function(SmsImportParsing value) parsing,
    required TResult Function(SmsImportParsed value) parsed,
    required TResult Function(SmsImportSaving value) saving,
    required TResult Function(SmsImportSaved value) saved,
    required TResult Function(SmsImportError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case SmsImportIdle():
        return idle(_that);
      case SmsImportParsing():
        return parsing(_that);
      case SmsImportParsed():
        return parsed(_that);
      case SmsImportSaving():
        return saving(_that);
      case SmsImportSaved():
        return saved(_that);
      case SmsImportError():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SmsImportIdle value)? idle,
    TResult? Function(SmsImportParsing value)? parsing,
    TResult? Function(SmsImportParsed value)? parsed,
    TResult? Function(SmsImportSaving value)? saving,
    TResult? Function(SmsImportSaved value)? saved,
    TResult? Function(SmsImportError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SmsImportIdle() when idle != null:
        return idle(_that);
      case SmsImportParsing() when parsing != null:
        return parsing(_that);
      case SmsImportParsed() when parsed != null:
        return parsed(_that);
      case SmsImportSaving() when saving != null:
        return saving(_that);
      case SmsImportSaved() when saved != null:
        return saved(_that);
      case SmsImportError() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(ParsedExpense expense)? parsed,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message, String? rawText)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SmsImportIdle() when idle != null:
        return idle();
      case SmsImportParsing() when parsing != null:
        return parsing();
      case SmsImportParsed() when parsed != null:
        return parsed(_that.expense);
      case SmsImportSaving() when saving != null:
        return saving();
      case SmsImportSaved() when saved != null:
        return saved();
      case SmsImportError() when error != null:
        return error(_that.message, _that.rawText);
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
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() parsing,
    required TResult Function(ParsedExpense expense) parsed,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message, String? rawText) error,
  }) {
    final _that = this;
    switch (_that) {
      case SmsImportIdle():
        return idle();
      case SmsImportParsing():
        return parsing();
      case SmsImportParsed():
        return parsed(_that.expense);
      case SmsImportSaving():
        return saving();
      case SmsImportSaved():
        return saved();
      case SmsImportError():
        return error(_that.message, _that.rawText);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(ParsedExpense expense)? parsed,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message, String? rawText)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SmsImportIdle() when idle != null:
        return idle();
      case SmsImportParsing() when parsing != null:
        return parsing();
      case SmsImportParsed() when parsed != null:
        return parsed(_that.expense);
      case SmsImportSaving() when saving != null:
        return saving();
      case SmsImportSaved() when saved != null:
        return saved();
      case SmsImportError() when error != null:
        return error(_that.message, _that.rawText);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SmsImportIdle extends SmsImportState {
  const SmsImportIdle() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SmsImportIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SmsImportState.idle()';
  }
}

/// @nodoc

class SmsImportParsing extends SmsImportState {
  const SmsImportParsing() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SmsImportParsing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SmsImportState.parsing()';
  }
}

/// @nodoc

class SmsImportParsed extends SmsImportState {
  const SmsImportParsed({required this.expense}) : super._();

  final ParsedExpense expense;

  /// Create a copy of SmsImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SmsImportParsedCopyWith<SmsImportParsed> get copyWith =>
      _$SmsImportParsedCopyWithImpl<SmsImportParsed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SmsImportParsed &&
            (identical(other.expense, expense) || other.expense == expense));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expense);

  @override
  String toString() {
    return 'SmsImportState.parsed(expense: $expense)';
  }
}

/// @nodoc
abstract mixin class $SmsImportParsedCopyWith<$Res>
    implements $SmsImportStateCopyWith<$Res> {
  factory $SmsImportParsedCopyWith(
          SmsImportParsed value, $Res Function(SmsImportParsed) _then) =
      _$SmsImportParsedCopyWithImpl;
  @useResult
  $Res call({ParsedExpense expense});

  $ParsedExpenseCopyWith<$Res> get expense;
}

/// @nodoc
class _$SmsImportParsedCopyWithImpl<$Res>
    implements $SmsImportParsedCopyWith<$Res> {
  _$SmsImportParsedCopyWithImpl(this._self, this._then);

  final SmsImportParsed _self;
  final $Res Function(SmsImportParsed) _then;

  /// Create a copy of SmsImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expense = null,
  }) {
    return _then(SmsImportParsed(
      expense: null == expense
          ? _self.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as ParsedExpense,
    ));
  }

  /// Create a copy of SmsImportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParsedExpenseCopyWith<$Res> get expense {
    return $ParsedExpenseCopyWith<$Res>(_self.expense, (value) {
      return _then(_self.copyWith(expense: value));
    });
  }
}

/// @nodoc

class SmsImportSaving extends SmsImportState {
  const SmsImportSaving() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SmsImportSaving);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SmsImportState.saving()';
  }
}

/// @nodoc

class SmsImportSaved extends SmsImportState {
  const SmsImportSaved() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SmsImportSaved);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SmsImportState.saved()';
  }
}

/// @nodoc

class SmsImportError extends SmsImportState {
  const SmsImportError({required this.message, this.rawText}) : super._();

  final String message;
  final String? rawText;

  /// Create a copy of SmsImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SmsImportErrorCopyWith<SmsImportError> get copyWith =>
      _$SmsImportErrorCopyWithImpl<SmsImportError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SmsImportError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.rawText, rawText) || other.rawText == rawText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, rawText);

  @override
  String toString() {
    return 'SmsImportState.error(message: $message, rawText: $rawText)';
  }
}

/// @nodoc
abstract mixin class $SmsImportErrorCopyWith<$Res>
    implements $SmsImportStateCopyWith<$Res> {
  factory $SmsImportErrorCopyWith(
          SmsImportError value, $Res Function(SmsImportError) _then) =
      _$SmsImportErrorCopyWithImpl;
  @useResult
  $Res call({String message, String? rawText});
}

/// @nodoc
class _$SmsImportErrorCopyWithImpl<$Res>
    implements $SmsImportErrorCopyWith<$Res> {
  _$SmsImportErrorCopyWithImpl(this._self, this._then);

  final SmsImportError _self;
  final $Res Function(SmsImportError) _then;

  /// Create a copy of SmsImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? rawText = freezed,
  }) {
    return _then(SmsImportError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      rawText: freezed == rawText
          ? _self.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
