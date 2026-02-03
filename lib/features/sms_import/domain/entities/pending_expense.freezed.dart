// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingExpense {
  /// 고유 식별자 (UUID)
  String get id;

  /// 원본 파싱 데이터
  ParsedExpense get parsedExpense;

  /// 사용자가 수정한 카테고리 (null이면 미분류)
  String? get category;

  /// 사용자가 수정한 메모
  String? get memo;

  /// 사용자가 수정한 가맹점명 (null이면 파싱 원본 사용)
  String? get merchantOverride;

  /// 생성 시간
  DateTime get createdAt;

  /// Create a copy of PendingExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingExpenseCopyWith<PendingExpense> get copyWith =>
      _$PendingExpenseCopyWithImpl<PendingExpense>(
          this as PendingExpense, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingExpense &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parsedExpense, parsedExpense) ||
                other.parsedExpense == parsedExpense) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.merchantOverride, merchantOverride) ||
                other.merchantOverride == merchantOverride) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, parsedExpense, category,
      memo, merchantOverride, createdAt);

  @override
  String toString() {
    return 'PendingExpense(id: $id, parsedExpense: $parsedExpense, category: $category, memo: $memo, merchantOverride: $merchantOverride, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PendingExpenseCopyWith<$Res> {
  factory $PendingExpenseCopyWith(
          PendingExpense value, $Res Function(PendingExpense) _then) =
      _$PendingExpenseCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      ParsedExpense parsedExpense,
      String? category,
      String? memo,
      String? merchantOverride,
      DateTime createdAt});

  $ParsedExpenseCopyWith<$Res> get parsedExpense;
}

/// @nodoc
class _$PendingExpenseCopyWithImpl<$Res>
    implements $PendingExpenseCopyWith<$Res> {
  _$PendingExpenseCopyWithImpl(this._self, this._then);

  final PendingExpense _self;
  final $Res Function(PendingExpense) _then;

  /// Create a copy of PendingExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parsedExpense = null,
    Object? category = freezed,
    Object? memo = freezed,
    Object? merchantOverride = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parsedExpense: null == parsedExpense
          ? _self.parsedExpense
          : parsedExpense // ignore: cast_nullable_to_non_nullable
              as ParsedExpense,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantOverride: freezed == merchantOverride
          ? _self.merchantOverride
          : merchantOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of PendingExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParsedExpenseCopyWith<$Res> get parsedExpense {
    return $ParsedExpenseCopyWith<$Res>(_self.parsedExpense, (value) {
      return _then(_self.copyWith(parsedExpense: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PendingExpense].
extension PendingExpensePatterns on PendingExpense {
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
    TResult Function(_PendingExpense value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingExpense() when $default != null:
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
    TResult Function(_PendingExpense value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpense():
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
    TResult? Function(_PendingExpense value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpense() when $default != null:
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
    TResult Function(String id, ParsedExpense parsedExpense, String? category,
            String? memo, String? merchantOverride, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingExpense() when $default != null:
        return $default(_that.id, _that.parsedExpense, _that.category,
            _that.memo, _that.merchantOverride, _that.createdAt);
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
    TResult Function(String id, ParsedExpense parsedExpense, String? category,
            String? memo, String? merchantOverride, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpense():
        return $default(_that.id, _that.parsedExpense, _that.category,
            _that.memo, _that.merchantOverride, _that.createdAt);
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
    TResult? Function(String id, ParsedExpense parsedExpense, String? category,
            String? memo, String? merchantOverride, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingExpense() when $default != null:
        return $default(_that.id, _that.parsedExpense, _that.category,
            _that.memo, _that.merchantOverride, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PendingExpense extends PendingExpense {
  const _PendingExpense(
      {required this.id,
      required this.parsedExpense,
      this.category,
      this.memo,
      this.merchantOverride,
      required this.createdAt})
      : super._();

  /// 고유 식별자 (UUID)
  @override
  final String id;

  /// 원본 파싱 데이터
  @override
  final ParsedExpense parsedExpense;

  /// 사용자가 수정한 카테고리 (null이면 미분류)
  @override
  final String? category;

  /// 사용자가 수정한 메모
  @override
  final String? memo;

  /// 사용자가 수정한 가맹점명 (null이면 파싱 원본 사용)
  @override
  final String? merchantOverride;

  /// 생성 시간
  @override
  final DateTime createdAt;

  /// Create a copy of PendingExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingExpenseCopyWith<_PendingExpense> get copyWith =>
      __$PendingExpenseCopyWithImpl<_PendingExpense>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PendingExpense &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parsedExpense, parsedExpense) ||
                other.parsedExpense == parsedExpense) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.merchantOverride, merchantOverride) ||
                other.merchantOverride == merchantOverride) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, parsedExpense, category,
      memo, merchantOverride, createdAt);

  @override
  String toString() {
    return 'PendingExpense(id: $id, parsedExpense: $parsedExpense, category: $category, memo: $memo, merchantOverride: $merchantOverride, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PendingExpenseCopyWith<$Res>
    implements $PendingExpenseCopyWith<$Res> {
  factory _$PendingExpenseCopyWith(
          _PendingExpense value, $Res Function(_PendingExpense) _then) =
      __$PendingExpenseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      ParsedExpense parsedExpense,
      String? category,
      String? memo,
      String? merchantOverride,
      DateTime createdAt});

  @override
  $ParsedExpenseCopyWith<$Res> get parsedExpense;
}

/// @nodoc
class __$PendingExpenseCopyWithImpl<$Res>
    implements _$PendingExpenseCopyWith<$Res> {
  __$PendingExpenseCopyWithImpl(this._self, this._then);

  final _PendingExpense _self;
  final $Res Function(_PendingExpense) _then;

  /// Create a copy of PendingExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? parsedExpense = null,
    Object? category = freezed,
    Object? memo = freezed,
    Object? merchantOverride = freezed,
    Object? createdAt = null,
  }) {
    return _then(_PendingExpense(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parsedExpense: null == parsedExpense
          ? _self.parsedExpense
          : parsedExpense // ignore: cast_nullable_to_non_nullable
              as ParsedExpense,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantOverride: freezed == merchantOverride
          ? _self.merchantOverride
          : merchantOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of PendingExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParsedExpenseCopyWith<$Res> get parsedExpense {
    return $ParsedExpenseCopyWith<$Res>(_self.parsedExpense, (value) {
      return _then(_self.copyWith(parsedExpense: value));
    });
  }
}

// dart format on
