// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountBook {
  String? get accountBookId;
  String get name;
  BookType get bookType;
  String? get coupleId;
  int? get memberCount;
  String? get description;
  DateTime? get startDate;
  DateTime? get endDate;
  bool? get isActive;
  DateTime? get createdAt;
  List<MemberInfo>? get members;

  /// Create a copy of AccountBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountBookCopyWith<AccountBook> get copyWith =>
      _$AccountBookCopyWithImpl<AccountBook>(this as AccountBook, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountBook &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bookType, bookType) ||
                other.bookType == bookType) &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      name,
      bookType,
      coupleId,
      memberCount,
      description,
      startDate,
      endDate,
      isActive,
      createdAt,
      const DeepCollectionEquality().hash(members));

  @override
  String toString() {
    return 'AccountBook(accountBookId: $accountBookId, name: $name, bookType: $bookType, coupleId: $coupleId, memberCount: $memberCount, description: $description, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class $AccountBookCopyWith<$Res> {
  factory $AccountBookCopyWith(
          AccountBook value, $Res Function(AccountBook) _then) =
      _$AccountBookCopyWithImpl;
  @useResult
  $Res call(
      {String? accountBookId,
      String name,
      BookType bookType,
      String? coupleId,
      int? memberCount,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      bool? isActive,
      DateTime? createdAt,
      List<MemberInfo>? members});
}

/// @nodoc
class _$AccountBookCopyWithImpl<$Res> implements $AccountBookCopyWith<$Res> {
  _$AccountBookCopyWithImpl(this._self, this._then);

  final AccountBook _self;
  final $Res Function(AccountBook) _then;

  /// Create a copy of AccountBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountBookId = freezed,
    Object? name = null,
    Object? bookType = null,
    Object? coupleId = freezed,
    Object? memberCount = freezed,
    Object? description = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? members = freezed,
  }) {
    return _then(_self.copyWith(
      accountBookId: freezed == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bookType: null == bookType
          ? _self.bookType
          : bookType // ignore: cast_nullable_to_non_nullable
              as BookType,
      coupleId: freezed == coupleId
          ? _self.coupleId
          : coupleId // ignore: cast_nullable_to_non_nullable
              as String?,
      memberCount: freezed == memberCount
          ? _self.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: freezed == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      members: freezed == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberInfo>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountBook].
extension AccountBookPatterns on AccountBook {
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
    TResult Function(_AccountBook value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountBook() when $default != null:
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
    TResult Function(_AccountBook value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBook():
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
    TResult? Function(_AccountBook value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBook() when $default != null:
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
            String? accountBookId,
            String name,
            BookType bookType,
            String? coupleId,
            int? memberCount,
            String? description,
            DateTime? startDate,
            DateTime? endDate,
            bool? isActive,
            DateTime? createdAt,
            List<MemberInfo>? members)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountBook() when $default != null:
        return $default(
            _that.accountBookId,
            _that.name,
            _that.bookType,
            _that.coupleId,
            _that.memberCount,
            _that.description,
            _that.startDate,
            _that.endDate,
            _that.isActive,
            _that.createdAt,
            _that.members);
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
            String? accountBookId,
            String name,
            BookType bookType,
            String? coupleId,
            int? memberCount,
            String? description,
            DateTime? startDate,
            DateTime? endDate,
            bool? isActive,
            DateTime? createdAt,
            List<MemberInfo>? members)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBook():
        return $default(
            _that.accountBookId,
            _that.name,
            _that.bookType,
            _that.coupleId,
            _that.memberCount,
            _that.description,
            _that.startDate,
            _that.endDate,
            _that.isActive,
            _that.createdAt,
            _that.members);
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
            String? accountBookId,
            String name,
            BookType bookType,
            String? coupleId,
            int? memberCount,
            String? description,
            DateTime? startDate,
            DateTime? endDate,
            bool? isActive,
            DateTime? createdAt,
            List<MemberInfo>? members)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBook() when $default != null:
        return $default(
            _that.accountBookId,
            _that.name,
            _that.bookType,
            _that.coupleId,
            _that.memberCount,
            _that.description,
            _that.startDate,
            _that.endDate,
            _that.isActive,
            _that.createdAt,
            _that.members);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AccountBook implements AccountBook {
  const _AccountBook(
      {this.accountBookId,
      required this.name,
      required this.bookType,
      this.coupleId,
      this.memberCount,
      this.description,
      this.startDate,
      this.endDate,
      this.isActive,
      this.createdAt,
      final List<MemberInfo>? members})
      : _members = members;

  @override
  final String? accountBookId;
  @override
  final String name;
  @override
  final BookType bookType;
  @override
  final String? coupleId;
  @override
  final int? memberCount;
  @override
  final String? description;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  final List<MemberInfo>? _members;
  @override
  List<MemberInfo>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of AccountBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountBookCopyWith<_AccountBook> get copyWith =>
      __$AccountBookCopyWithImpl<_AccountBook>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountBook &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bookType, bookType) ||
                other.bookType == bookType) &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      name,
      bookType,
      coupleId,
      memberCount,
      description,
      startDate,
      endDate,
      isActive,
      createdAt,
      const DeepCollectionEquality().hash(_members));

  @override
  String toString() {
    return 'AccountBook(accountBookId: $accountBookId, name: $name, bookType: $bookType, coupleId: $coupleId, memberCount: $memberCount, description: $description, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$AccountBookCopyWith<$Res>
    implements $AccountBookCopyWith<$Res> {
  factory _$AccountBookCopyWith(
          _AccountBook value, $Res Function(_AccountBook) _then) =
      __$AccountBookCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? accountBookId,
      String name,
      BookType bookType,
      String? coupleId,
      int? memberCount,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      bool? isActive,
      DateTime? createdAt,
      List<MemberInfo>? members});
}

/// @nodoc
class __$AccountBookCopyWithImpl<$Res> implements _$AccountBookCopyWith<$Res> {
  __$AccountBookCopyWithImpl(this._self, this._then);

  final _AccountBook _self;
  final $Res Function(_AccountBook) _then;

  /// Create a copy of AccountBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountBookId = freezed,
    Object? name = null,
    Object? bookType = null,
    Object? coupleId = freezed,
    Object? memberCount = freezed,
    Object? description = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? members = freezed,
  }) {
    return _then(_AccountBook(
      accountBookId: freezed == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bookType: null == bookType
          ? _self.bookType
          : bookType // ignore: cast_nullable_to_non_nullable
              as BookType,
      coupleId: freezed == coupleId
          ? _self.coupleId
          : coupleId // ignore: cast_nullable_to_non_nullable
              as String?,
      memberCount: freezed == memberCount
          ? _self.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: freezed == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      members: freezed == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberInfo>?,
    ));
  }
}

// dart format on
