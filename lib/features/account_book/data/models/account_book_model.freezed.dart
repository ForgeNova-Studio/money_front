// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountBookModel {
  String? get accountBookId;
  String get name;
  String get bookType;
  String? get coupleId;
  int? get memberCount;
  String? get description;
  DateTime? get startDate;
  DateTime? get endDate;
  bool? get isActive;
  DateTime? get createdAt;
  List<AccountBookMemberInfoModel>? get members;

  /// Create a copy of AccountBookModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountBookModelCopyWith<AccountBookModel> get copyWith =>
      _$AccountBookModelCopyWithImpl<AccountBookModel>(
          this as AccountBookModel, _$identity);

  /// Serializes this AccountBookModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountBookModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'AccountBookModel(accountBookId: $accountBookId, name: $name, bookType: $bookType, coupleId: $coupleId, memberCount: $memberCount, description: $description, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class $AccountBookModelCopyWith<$Res> {
  factory $AccountBookModelCopyWith(
          AccountBookModel value, $Res Function(AccountBookModel) _then) =
      _$AccountBookModelCopyWithImpl;
  @useResult
  $Res call(
      {String? accountBookId,
      String name,
      String bookType,
      String? coupleId,
      int? memberCount,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      bool? isActive,
      DateTime? createdAt,
      List<AccountBookMemberInfoModel>? members});
}

/// @nodoc
class _$AccountBookModelCopyWithImpl<$Res>
    implements $AccountBookModelCopyWith<$Res> {
  _$AccountBookModelCopyWithImpl(this._self, this._then);

  final AccountBookModel _self;
  final $Res Function(AccountBookModel) _then;

  /// Create a copy of AccountBookModel
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
              as String,
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
              as List<AccountBookMemberInfoModel>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountBookModel].
extension AccountBookModelPatterns on AccountBookModel {
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
    TResult Function(_AccountBookModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountBookModel() when $default != null:
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
    TResult Function(_AccountBookModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBookModel():
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
    TResult? Function(_AccountBookModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBookModel() when $default != null:
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
            String bookType,
            String? coupleId,
            int? memberCount,
            String? description,
            DateTime? startDate,
            DateTime? endDate,
            bool? isActive,
            DateTime? createdAt,
            List<AccountBookMemberInfoModel>? members)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountBookModel() when $default != null:
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
            String bookType,
            String? coupleId,
            int? memberCount,
            String? description,
            DateTime? startDate,
            DateTime? endDate,
            bool? isActive,
            DateTime? createdAt,
            List<AccountBookMemberInfoModel>? members)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBookModel():
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
            String bookType,
            String? coupleId,
            int? memberCount,
            String? description,
            DateTime? startDate,
            DateTime? endDate,
            bool? isActive,
            DateTime? createdAt,
            List<AccountBookMemberInfoModel>? members)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountBookModel() when $default != null:
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
@JsonSerializable()
class _AccountBookModel extends AccountBookModel {
  const _AccountBookModel(
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
      final List<AccountBookMemberInfoModel>? members})
      : _members = members,
        super._();
  factory _AccountBookModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookModelFromJson(json);

  @override
  final String? accountBookId;
  @override
  final String name;
  @override
  final String bookType;
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
  final List<AccountBookMemberInfoModel>? _members;
  @override
  List<AccountBookMemberInfoModel>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of AccountBookModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountBookModelCopyWith<_AccountBookModel> get copyWith =>
      __$AccountBookModelCopyWithImpl<_AccountBookModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountBookModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountBookModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'AccountBookModel(accountBookId: $accountBookId, name: $name, bookType: $bookType, coupleId: $coupleId, memberCount: $memberCount, description: $description, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$AccountBookModelCopyWith<$Res>
    implements $AccountBookModelCopyWith<$Res> {
  factory _$AccountBookModelCopyWith(
          _AccountBookModel value, $Res Function(_AccountBookModel) _then) =
      __$AccountBookModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? accountBookId,
      String name,
      String bookType,
      String? coupleId,
      int? memberCount,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      bool? isActive,
      DateTime? createdAt,
      List<AccountBookMemberInfoModel>? members});
}

/// @nodoc
class __$AccountBookModelCopyWithImpl<$Res>
    implements _$AccountBookModelCopyWith<$Res> {
  __$AccountBookModelCopyWithImpl(this._self, this._then);

  final _AccountBookModel _self;
  final $Res Function(_AccountBookModel) _then;

  /// Create a copy of AccountBookModel
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
    return _then(_AccountBookModel(
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
              as String,
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
              as List<AccountBookMemberInfoModel>?,
    ));
  }
}

// dart format on
