// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParsedExpense {
  /// 금액 (원)
  int get amount;

  /// 가맹점명
  String get merchant;

  /// 결제 일시
  DateTime get date;

  /// 카드사 ID (samsung, shinhan, kb 등)
  String get cardCompanyId;

  /// 원본 SMS 텍스트
  String get rawText;

  /// 카드 종류 (신용/체크)
  String? get cardType;

  /// 할부 개월 (일시불이면 null)
  int? get installmentMonths;

  /// Create a copy of ParsedExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParsedExpenseCopyWith<ParsedExpense> get copyWith =>
      _$ParsedExpenseCopyWithImpl<ParsedExpense>(
          this as ParsedExpense, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParsedExpense &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.cardCompanyId, cardCompanyId) ||
                other.cardCompanyId == cardCompanyId) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.installmentMonths, installmentMonths) ||
                other.installmentMonths == installmentMonths));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, merchant, date,
      cardCompanyId, rawText, cardType, installmentMonths);

  @override
  String toString() {
    return 'ParsedExpense(amount: $amount, merchant: $merchant, date: $date, cardCompanyId: $cardCompanyId, rawText: $rawText, cardType: $cardType, installmentMonths: $installmentMonths)';
  }
}

/// @nodoc
abstract mixin class $ParsedExpenseCopyWith<$Res> {
  factory $ParsedExpenseCopyWith(
          ParsedExpense value, $Res Function(ParsedExpense) _then) =
      _$ParsedExpenseCopyWithImpl;
  @useResult
  $Res call(
      {int amount,
      String merchant,
      DateTime date,
      String cardCompanyId,
      String rawText,
      String? cardType,
      int? installmentMonths});
}

/// @nodoc
class _$ParsedExpenseCopyWithImpl<$Res>
    implements $ParsedExpenseCopyWith<$Res> {
  _$ParsedExpenseCopyWithImpl(this._self, this._then);

  final ParsedExpense _self;
  final $Res Function(ParsedExpense) _then;

  /// Create a copy of ParsedExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? merchant = null,
    Object? date = null,
    Object? cardCompanyId = null,
    Object? rawText = null,
    Object? cardType = freezed,
    Object? installmentMonths = freezed,
  }) {
    return _then(_self.copyWith(
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      merchant: null == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cardCompanyId: null == cardCompanyId
          ? _self.cardCompanyId
          : cardCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      rawText: null == rawText
          ? _self.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      cardType: freezed == cardType
          ? _self.cardType
          : cardType // ignore: cast_nullable_to_non_nullable
              as String?,
      installmentMonths: freezed == installmentMonths
          ? _self.installmentMonths
          : installmentMonths // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ParsedExpense].
extension ParsedExpensePatterns on ParsedExpense {
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
    TResult Function(_ParsedExpense value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParsedExpense() when $default != null:
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
    TResult Function(_ParsedExpense value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedExpense():
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
    TResult? Function(_ParsedExpense value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedExpense() when $default != null:
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
            int amount,
            String merchant,
            DateTime date,
            String cardCompanyId,
            String rawText,
            String? cardType,
            int? installmentMonths)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParsedExpense() when $default != null:
        return $default(
            _that.amount,
            _that.merchant,
            _that.date,
            _that.cardCompanyId,
            _that.rawText,
            _that.cardType,
            _that.installmentMonths);
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
            int amount,
            String merchant,
            DateTime date,
            String cardCompanyId,
            String rawText,
            String? cardType,
            int? installmentMonths)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedExpense():
        return $default(
            _that.amount,
            _that.merchant,
            _that.date,
            _that.cardCompanyId,
            _that.rawText,
            _that.cardType,
            _that.installmentMonths);
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
            int amount,
            String merchant,
            DateTime date,
            String cardCompanyId,
            String rawText,
            String? cardType,
            int? installmentMonths)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedExpense() when $default != null:
        return $default(
            _that.amount,
            _that.merchant,
            _that.date,
            _that.cardCompanyId,
            _that.rawText,
            _that.cardType,
            _that.installmentMonths);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ParsedExpense implements ParsedExpense {
  const _ParsedExpense(
      {required this.amount,
      required this.merchant,
      required this.date,
      required this.cardCompanyId,
      required this.rawText,
      this.cardType,
      this.installmentMonths});

  /// 금액 (원)
  @override
  final int amount;

  /// 가맹점명
  @override
  final String merchant;

  /// 결제 일시
  @override
  final DateTime date;

  /// 카드사 ID (samsung, shinhan, kb 등)
  @override
  final String cardCompanyId;

  /// 원본 SMS 텍스트
  @override
  final String rawText;

  /// 카드 종류 (신용/체크)
  @override
  final String? cardType;

  /// 할부 개월 (일시불이면 null)
  @override
  final int? installmentMonths;

  /// Create a copy of ParsedExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParsedExpenseCopyWith<_ParsedExpense> get copyWith =>
      __$ParsedExpenseCopyWithImpl<_ParsedExpense>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParsedExpense &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.cardCompanyId, cardCompanyId) ||
                other.cardCompanyId == cardCompanyId) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.installmentMonths, installmentMonths) ||
                other.installmentMonths == installmentMonths));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, merchant, date,
      cardCompanyId, rawText, cardType, installmentMonths);

  @override
  String toString() {
    return 'ParsedExpense(amount: $amount, merchant: $merchant, date: $date, cardCompanyId: $cardCompanyId, rawText: $rawText, cardType: $cardType, installmentMonths: $installmentMonths)';
  }
}

/// @nodoc
abstract mixin class _$ParsedExpenseCopyWith<$Res>
    implements $ParsedExpenseCopyWith<$Res> {
  factory _$ParsedExpenseCopyWith(
          _ParsedExpense value, $Res Function(_ParsedExpense) _then) =
      __$ParsedExpenseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int amount,
      String merchant,
      DateTime date,
      String cardCompanyId,
      String rawText,
      String? cardType,
      int? installmentMonths});
}

/// @nodoc
class __$ParsedExpenseCopyWithImpl<$Res>
    implements _$ParsedExpenseCopyWith<$Res> {
  __$ParsedExpenseCopyWithImpl(this._self, this._then);

  final _ParsedExpense _self;
  final $Res Function(_ParsedExpense) _then;

  /// Create a copy of ParsedExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amount = null,
    Object? merchant = null,
    Object? date = null,
    Object? cardCompanyId = null,
    Object? rawText = null,
    Object? cardType = freezed,
    Object? installmentMonths = freezed,
  }) {
    return _then(_ParsedExpense(
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      merchant: null == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cardCompanyId: null == cardCompanyId
          ? _self.cardCompanyId
          : cardCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      rawText: null == rawText
          ? _self.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      cardType: freezed == cardType
          ? _self.cardType
          : cardType // ignore: cast_nullable_to_non_nullable
              as String?,
      installmentMonths: freezed == installmentMonths
          ? _self.installmentMonths
          : installmentMonths // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$SmsParseResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SmsParseResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SmsParseResult()';
  }
}

/// @nodoc
class $SmsParseResultCopyWith<$Res> {
  $SmsParseResultCopyWith(SmsParseResult _, $Res Function(SmsParseResult) __);
}

/// Adds pattern-matching-related methods to [SmsParseResult].
extension SmsParseResultPatterns on SmsParseResult {
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
    TResult Function(SmsParseSuccess value)? success,
    TResult Function(SmsParseFailure value)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SmsParseSuccess() when success != null:
        return success(_that);
      case SmsParseFailure() when failure != null:
        return failure(_that);
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
    required TResult Function(SmsParseSuccess value) success,
    required TResult Function(SmsParseFailure value) failure,
  }) {
    final _that = this;
    switch (_that) {
      case SmsParseSuccess():
        return success(_that);
      case SmsParseFailure():
        return failure(_that);
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
    TResult? Function(SmsParseSuccess value)? success,
    TResult? Function(SmsParseFailure value)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case SmsParseSuccess() when success != null:
        return success(_that);
      case SmsParseFailure() when failure != null:
        return failure(_that);
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
    TResult Function(ParsedExpense expense)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SmsParseSuccess() when success != null:
        return success(_that.expense);
      case SmsParseFailure() when failure != null:
        return failure(_that.error);
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
    required TResult Function(ParsedExpense expense) success,
    required TResult Function(String error) failure,
  }) {
    final _that = this;
    switch (_that) {
      case SmsParseSuccess():
        return success(_that.expense);
      case SmsParseFailure():
        return failure(_that.error);
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
    TResult? Function(ParsedExpense expense)? success,
    TResult? Function(String error)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case SmsParseSuccess() when success != null:
        return success(_that.expense);
      case SmsParseFailure() when failure != null:
        return failure(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SmsParseSuccess implements SmsParseResult {
  const SmsParseSuccess(this.expense);

  final ParsedExpense expense;

  /// Create a copy of SmsParseResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SmsParseSuccessCopyWith<SmsParseSuccess> get copyWith =>
      _$SmsParseSuccessCopyWithImpl<SmsParseSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SmsParseSuccess &&
            (identical(other.expense, expense) || other.expense == expense));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expense);

  @override
  String toString() {
    return 'SmsParseResult.success(expense: $expense)';
  }
}

/// @nodoc
abstract mixin class $SmsParseSuccessCopyWith<$Res>
    implements $SmsParseResultCopyWith<$Res> {
  factory $SmsParseSuccessCopyWith(
          SmsParseSuccess value, $Res Function(SmsParseSuccess) _then) =
      _$SmsParseSuccessCopyWithImpl;
  @useResult
  $Res call({ParsedExpense expense});

  $ParsedExpenseCopyWith<$Res> get expense;
}

/// @nodoc
class _$SmsParseSuccessCopyWithImpl<$Res>
    implements $SmsParseSuccessCopyWith<$Res> {
  _$SmsParseSuccessCopyWithImpl(this._self, this._then);

  final SmsParseSuccess _self;
  final $Res Function(SmsParseSuccess) _then;

  /// Create a copy of SmsParseResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expense = null,
  }) {
    return _then(SmsParseSuccess(
      null == expense
          ? _self.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as ParsedExpense,
    ));
  }

  /// Create a copy of SmsParseResult
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

class SmsParseFailure implements SmsParseResult {
  const SmsParseFailure(this.error);

  final String error;

  /// Create a copy of SmsParseResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SmsParseFailureCopyWith<SmsParseFailure> get copyWith =>
      _$SmsParseFailureCopyWithImpl<SmsParseFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SmsParseFailure &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'SmsParseResult.failure(error: $error)';
  }
}

/// @nodoc
abstract mixin class $SmsParseFailureCopyWith<$Res>
    implements $SmsParseResultCopyWith<$Res> {
  factory $SmsParseFailureCopyWith(
          SmsParseFailure value, $Res Function(SmsParseFailure) _then) =
      _$SmsParseFailureCopyWithImpl;
  @useResult
  $Res call({String error});
}

/// @nodoc
class _$SmsParseFailureCopyWithImpl<$Res>
    implements $SmsParseFailureCopyWith<$Res> {
  _$SmsParseFailureCopyWithImpl(this._self, this._then);

  final SmsParseFailure _self;
  final $Res Function(SmsParseFailure) _then;

  /// Create a copy of SmsParseResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(SmsParseFailure(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
