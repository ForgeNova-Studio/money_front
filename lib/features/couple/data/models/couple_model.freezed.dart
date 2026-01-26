// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleModel {
  String get coupleId;
  CoupleUserModel? get user1;
  CoupleUserModel? get user2;
  String? get inviteCode;
  DateTime? get codeExpiresAt;
  bool get linked;
  DateTime? get linkedAt;
  DateTime get createdAt;

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoupleModelCopyWith<CoupleModel> get copyWith =>
      _$CoupleModelCopyWithImpl<CoupleModel>(this as CoupleModel, _$identity);

  /// Serializes this CoupleModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CoupleModel &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.user1, user1) || other.user1 == user1) &&
            (identical(other.user2, user2) || other.user2 == user2) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.codeExpiresAt, codeExpiresAt) ||
                other.codeExpiresAt == codeExpiresAt) &&
            (identical(other.linked, linked) || other.linked == linked) &&
            (identical(other.linkedAt, linkedAt) ||
                other.linkedAt == linkedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coupleId, user1, user2,
      inviteCode, codeExpiresAt, linked, linkedAt, createdAt);

  @override
  String toString() {
    return 'CoupleModel(coupleId: $coupleId, user1: $user1, user2: $user2, inviteCode: $inviteCode, codeExpiresAt: $codeExpiresAt, linked: $linked, linkedAt: $linkedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CoupleModelCopyWith<$Res> {
  factory $CoupleModelCopyWith(
          CoupleModel value, $Res Function(CoupleModel) _then) =
      _$CoupleModelCopyWithImpl;
  @useResult
  $Res call(
      {String coupleId,
      CoupleUserModel? user1,
      CoupleUserModel? user2,
      String? inviteCode,
      DateTime? codeExpiresAt,
      bool linked,
      DateTime? linkedAt,
      DateTime createdAt});

  $CoupleUserModelCopyWith<$Res>? get user1;
  $CoupleUserModelCopyWith<$Res>? get user2;
}

/// @nodoc
class _$CoupleModelCopyWithImpl<$Res> implements $CoupleModelCopyWith<$Res> {
  _$CoupleModelCopyWithImpl(this._self, this._then);

  final CoupleModel _self;
  final $Res Function(CoupleModel) _then;

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coupleId = null,
    Object? user1 = freezed,
    Object? user2 = freezed,
    Object? inviteCode = freezed,
    Object? codeExpiresAt = freezed,
    Object? linked = null,
    Object? linkedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      coupleId: null == coupleId
          ? _self.coupleId
          : coupleId // ignore: cast_nullable_to_non_nullable
              as String,
      user1: freezed == user1
          ? _self.user1
          : user1 // ignore: cast_nullable_to_non_nullable
              as CoupleUserModel?,
      user2: freezed == user2
          ? _self.user2
          : user2 // ignore: cast_nullable_to_non_nullable
              as CoupleUserModel?,
      inviteCode: freezed == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      codeExpiresAt: freezed == codeExpiresAt
          ? _self.codeExpiresAt
          : codeExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      linked: null == linked
          ? _self.linked
          : linked // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedAt: freezed == linkedAt
          ? _self.linkedAt
          : linkedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoupleUserModelCopyWith<$Res>? get user1 {
    if (_self.user1 == null) {
      return null;
    }

    return $CoupleUserModelCopyWith<$Res>(_self.user1!, (value) {
      return _then(_self.copyWith(user1: value));
    });
  }

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoupleUserModelCopyWith<$Res>? get user2 {
    if (_self.user2 == null) {
      return null;
    }

    return $CoupleUserModelCopyWith<$Res>(_self.user2!, (value) {
      return _then(_self.copyWith(user2: value));
    });
  }
}

/// Adds pattern-matching-related methods to [CoupleModel].
extension CoupleModelPatterns on CoupleModel {
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
    TResult Function(_CoupleModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoupleModel() when $default != null:
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
    TResult Function(_CoupleModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleModel():
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
    TResult? Function(_CoupleModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleModel() when $default != null:
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
            String coupleId,
            CoupleUserModel? user1,
            CoupleUserModel? user2,
            String? inviteCode,
            DateTime? codeExpiresAt,
            bool linked,
            DateTime? linkedAt,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoupleModel() when $default != null:
        return $default(
            _that.coupleId,
            _that.user1,
            _that.user2,
            _that.inviteCode,
            _that.codeExpiresAt,
            _that.linked,
            _that.linkedAt,
            _that.createdAt);
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
            String coupleId,
            CoupleUserModel? user1,
            CoupleUserModel? user2,
            String? inviteCode,
            DateTime? codeExpiresAt,
            bool linked,
            DateTime? linkedAt,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleModel():
        return $default(
            _that.coupleId,
            _that.user1,
            _that.user2,
            _that.inviteCode,
            _that.codeExpiresAt,
            _that.linked,
            _that.linkedAt,
            _that.createdAt);
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
            String coupleId,
            CoupleUserModel? user1,
            CoupleUserModel? user2,
            String? inviteCode,
            DateTime? codeExpiresAt,
            bool linked,
            DateTime? linkedAt,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleModel() when $default != null:
        return $default(
            _that.coupleId,
            _that.user1,
            _that.user2,
            _that.inviteCode,
            _that.codeExpiresAt,
            _that.linked,
            _that.linkedAt,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CoupleModel extends CoupleModel {
  const _CoupleModel(
      {required this.coupleId,
      this.user1,
      this.user2,
      this.inviteCode,
      this.codeExpiresAt,
      required this.linked,
      this.linkedAt,
      required this.createdAt})
      : super._();
  factory _CoupleModel.fromJson(Map<String, dynamic> json) =>
      _$CoupleModelFromJson(json);

  @override
  final String coupleId;
  @override
  final CoupleUserModel? user1;
  @override
  final CoupleUserModel? user2;
  @override
  final String? inviteCode;
  @override
  final DateTime? codeExpiresAt;
  @override
  final bool linked;
  @override
  final DateTime? linkedAt;
  @override
  final DateTime createdAt;

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CoupleModelCopyWith<_CoupleModel> get copyWith =>
      __$CoupleModelCopyWithImpl<_CoupleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CoupleModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CoupleModel &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.user1, user1) || other.user1 == user1) &&
            (identical(other.user2, user2) || other.user2 == user2) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.codeExpiresAt, codeExpiresAt) ||
                other.codeExpiresAt == codeExpiresAt) &&
            (identical(other.linked, linked) || other.linked == linked) &&
            (identical(other.linkedAt, linkedAt) ||
                other.linkedAt == linkedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coupleId, user1, user2,
      inviteCode, codeExpiresAt, linked, linkedAt, createdAt);

  @override
  String toString() {
    return 'CoupleModel(coupleId: $coupleId, user1: $user1, user2: $user2, inviteCode: $inviteCode, codeExpiresAt: $codeExpiresAt, linked: $linked, linkedAt: $linkedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CoupleModelCopyWith<$Res>
    implements $CoupleModelCopyWith<$Res> {
  factory _$CoupleModelCopyWith(
          _CoupleModel value, $Res Function(_CoupleModel) _then) =
      __$CoupleModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String coupleId,
      CoupleUserModel? user1,
      CoupleUserModel? user2,
      String? inviteCode,
      DateTime? codeExpiresAt,
      bool linked,
      DateTime? linkedAt,
      DateTime createdAt});

  @override
  $CoupleUserModelCopyWith<$Res>? get user1;
  @override
  $CoupleUserModelCopyWith<$Res>? get user2;
}

/// @nodoc
class __$CoupleModelCopyWithImpl<$Res> implements _$CoupleModelCopyWith<$Res> {
  __$CoupleModelCopyWithImpl(this._self, this._then);

  final _CoupleModel _self;
  final $Res Function(_CoupleModel) _then;

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? coupleId = null,
    Object? user1 = freezed,
    Object? user2 = freezed,
    Object? inviteCode = freezed,
    Object? codeExpiresAt = freezed,
    Object? linked = null,
    Object? linkedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_CoupleModel(
      coupleId: null == coupleId
          ? _self.coupleId
          : coupleId // ignore: cast_nullable_to_non_nullable
              as String,
      user1: freezed == user1
          ? _self.user1
          : user1 // ignore: cast_nullable_to_non_nullable
              as CoupleUserModel?,
      user2: freezed == user2
          ? _self.user2
          : user2 // ignore: cast_nullable_to_non_nullable
              as CoupleUserModel?,
      inviteCode: freezed == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      codeExpiresAt: freezed == codeExpiresAt
          ? _self.codeExpiresAt
          : codeExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      linked: null == linked
          ? _self.linked
          : linked // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedAt: freezed == linkedAt
          ? _self.linkedAt
          : linkedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoupleUserModelCopyWith<$Res>? get user1 {
    if (_self.user1 == null) {
      return null;
    }

    return $CoupleUserModelCopyWith<$Res>(_self.user1!, (value) {
      return _then(_self.copyWith(user1: value));
    });
  }

  /// Create a copy of CoupleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoupleUserModelCopyWith<$Res>? get user2 {
    if (_self.user2 == null) {
      return null;
    }

    return $CoupleUserModelCopyWith<$Res>(_self.user2!, (value) {
      return _then(_self.copyWith(user2: value));
    });
  }
}

/// @nodoc
mixin _$CoupleUserModel {
  String get userId;
  String? get nickname;
  String? get email;

  /// Create a copy of CoupleUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoupleUserModelCopyWith<CoupleUserModel> get copyWith =>
      _$CoupleUserModelCopyWithImpl<CoupleUserModel>(
          this as CoupleUserModel, _$identity);

  /// Serializes this CoupleUserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CoupleUserModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, nickname, email);

  @override
  String toString() {
    return 'CoupleUserModel(userId: $userId, nickname: $nickname, email: $email)';
  }
}

/// @nodoc
abstract mixin class $CoupleUserModelCopyWith<$Res> {
  factory $CoupleUserModelCopyWith(
          CoupleUserModel value, $Res Function(CoupleUserModel) _then) =
      _$CoupleUserModelCopyWithImpl;
  @useResult
  $Res call({String userId, String? nickname, String? email});
}

/// @nodoc
class _$CoupleUserModelCopyWithImpl<$Res>
    implements $CoupleUserModelCopyWith<$Res> {
  _$CoupleUserModelCopyWithImpl(this._self, this._then);

  final CoupleUserModel _self;
  final $Res Function(CoupleUserModel) _then;

  /// Create a copy of CoupleUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = freezed,
    Object? email = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CoupleUserModel].
extension CoupleUserModelPatterns on CoupleUserModel {
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
    TResult Function(_CoupleUserModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoupleUserModel() when $default != null:
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
    TResult Function(_CoupleUserModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleUserModel():
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
    TResult? Function(_CoupleUserModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleUserModel() when $default != null:
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
    TResult Function(String userId, String? nickname, String? email)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CoupleUserModel() when $default != null:
        return $default(_that.userId, _that.nickname, _that.email);
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
    TResult Function(String userId, String? nickname, String? email) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleUserModel():
        return $default(_that.userId, _that.nickname, _that.email);
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
    TResult? Function(String userId, String? nickname, String? email)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CoupleUserModel() when $default != null:
        return $default(_that.userId, _that.nickname, _that.email);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CoupleUserModel extends CoupleUserModel {
  const _CoupleUserModel({required this.userId, this.nickname, this.email})
      : super._();
  factory _CoupleUserModel.fromJson(Map<String, dynamic> json) =>
      _$CoupleUserModelFromJson(json);

  @override
  final String userId;
  @override
  final String? nickname;
  @override
  final String? email;

  /// Create a copy of CoupleUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CoupleUserModelCopyWith<_CoupleUserModel> get copyWith =>
      __$CoupleUserModelCopyWithImpl<_CoupleUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CoupleUserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CoupleUserModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, nickname, email);

  @override
  String toString() {
    return 'CoupleUserModel(userId: $userId, nickname: $nickname, email: $email)';
  }
}

/// @nodoc
abstract mixin class _$CoupleUserModelCopyWith<$Res>
    implements $CoupleUserModelCopyWith<$Res> {
  factory _$CoupleUserModelCopyWith(
          _CoupleUserModel value, $Res Function(_CoupleUserModel) _then) =
      __$CoupleUserModelCopyWithImpl;
  @override
  @useResult
  $Res call({String userId, String? nickname, String? email});
}

/// @nodoc
class __$CoupleUserModelCopyWithImpl<$Res>
    implements _$CoupleUserModelCopyWith<$Res> {
  __$CoupleUserModelCopyWithImpl(this._self, this._then);

  final _CoupleUserModel _self;
  final $Res Function(_CoupleUserModel) _then;

  /// Create a copy of CoupleUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? nickname = freezed,
    Object? email = freezed,
  }) {
    return _then(_CoupleUserModel(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$InviteModel {
  String get inviteCode;
  DateTime get expiresAt;
  String? get message;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InviteModelCopyWith<InviteModel> get copyWith =>
      _$InviteModelCopyWithImpl<InviteModel>(this as InviteModel, _$identity);

  /// Serializes this InviteModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InviteModel &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, inviteCode, expiresAt, message);

  @override
  String toString() {
    return 'InviteModel(inviteCode: $inviteCode, expiresAt: $expiresAt, message: $message)';
  }
}

/// @nodoc
abstract mixin class $InviteModelCopyWith<$Res> {
  factory $InviteModelCopyWith(
          InviteModel value, $Res Function(InviteModel) _then) =
      _$InviteModelCopyWithImpl;
  @useResult
  $Res call({String inviteCode, DateTime expiresAt, String? message});
}

/// @nodoc
class _$InviteModelCopyWithImpl<$Res> implements $InviteModelCopyWith<$Res> {
  _$InviteModelCopyWithImpl(this._self, this._then);

  final InviteModel _self;
  final $Res Function(InviteModel) _then;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inviteCode = null,
    Object? expiresAt = null,
    Object? message = freezed,
  }) {
    return _then(_self.copyWith(
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [InviteModel].
extension InviteModelPatterns on InviteModel {
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
    TResult Function(_InviteModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InviteModel() when $default != null:
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
    TResult Function(_InviteModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteModel():
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
    TResult? Function(_InviteModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteModel() when $default != null:
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
    TResult Function(String inviteCode, DateTime expiresAt, String? message)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InviteModel() when $default != null:
        return $default(_that.inviteCode, _that.expiresAt, _that.message);
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
    TResult Function(String inviteCode, DateTime expiresAt, String? message)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteModel():
        return $default(_that.inviteCode, _that.expiresAt, _that.message);
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
    TResult? Function(String inviteCode, DateTime expiresAt, String? message)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InviteModel() when $default != null:
        return $default(_that.inviteCode, _that.expiresAt, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InviteModel extends InviteModel {
  const _InviteModel(
      {required this.inviteCode, required this.expiresAt, this.message})
      : super._();
  factory _InviteModel.fromJson(Map<String, dynamic> json) =>
      _$InviteModelFromJson(json);

  @override
  final String inviteCode;
  @override
  final DateTime expiresAt;
  @override
  final String? message;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InviteModelCopyWith<_InviteModel> get copyWith =>
      __$InviteModelCopyWithImpl<_InviteModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InviteModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InviteModel &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, inviteCode, expiresAt, message);

  @override
  String toString() {
    return 'InviteModel(inviteCode: $inviteCode, expiresAt: $expiresAt, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$InviteModelCopyWith<$Res>
    implements $InviteModelCopyWith<$Res> {
  factory _$InviteModelCopyWith(
          _InviteModel value, $Res Function(_InviteModel) _then) =
      __$InviteModelCopyWithImpl;
  @override
  @useResult
  $Res call({String inviteCode, DateTime expiresAt, String? message});
}

/// @nodoc
class __$InviteModelCopyWithImpl<$Res> implements _$InviteModelCopyWith<$Res> {
  __$InviteModelCopyWithImpl(this._self, this._then);

  final _InviteModel _self;
  final $Res Function(_InviteModel) _then;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? inviteCode = null,
    Object? expiresAt = null,
    Object? message = freezed,
  }) {
    return _then(_InviteModel(
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$JoinCoupleRequest {
  String get inviteCode;

  /// Create a copy of JoinCoupleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JoinCoupleRequestCopyWith<JoinCoupleRequest> get copyWith =>
      _$JoinCoupleRequestCopyWithImpl<JoinCoupleRequest>(
          this as JoinCoupleRequest, _$identity);

  /// Serializes this JoinCoupleRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JoinCoupleRequest &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, inviteCode);

  @override
  String toString() {
    return 'JoinCoupleRequest(inviteCode: $inviteCode)';
  }
}

/// @nodoc
abstract mixin class $JoinCoupleRequestCopyWith<$Res> {
  factory $JoinCoupleRequestCopyWith(
          JoinCoupleRequest value, $Res Function(JoinCoupleRequest) _then) =
      _$JoinCoupleRequestCopyWithImpl;
  @useResult
  $Res call({String inviteCode});
}

/// @nodoc
class _$JoinCoupleRequestCopyWithImpl<$Res>
    implements $JoinCoupleRequestCopyWith<$Res> {
  _$JoinCoupleRequestCopyWithImpl(this._self, this._then);

  final JoinCoupleRequest _self;
  final $Res Function(JoinCoupleRequest) _then;

  /// Create a copy of JoinCoupleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inviteCode = null,
  }) {
    return _then(_self.copyWith(
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [JoinCoupleRequest].
extension JoinCoupleRequestPatterns on JoinCoupleRequest {
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
    TResult Function(_JoinCoupleRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JoinCoupleRequest() when $default != null:
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
    TResult Function(_JoinCoupleRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JoinCoupleRequest():
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
    TResult? Function(_JoinCoupleRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JoinCoupleRequest() when $default != null:
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
    TResult Function(String inviteCode)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JoinCoupleRequest() when $default != null:
        return $default(_that.inviteCode);
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
    TResult Function(String inviteCode) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JoinCoupleRequest():
        return $default(_that.inviteCode);
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
    TResult? Function(String inviteCode)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JoinCoupleRequest() when $default != null:
        return $default(_that.inviteCode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _JoinCoupleRequest implements JoinCoupleRequest {
  const _JoinCoupleRequest({required this.inviteCode});
  factory _JoinCoupleRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinCoupleRequestFromJson(json);

  @override
  final String inviteCode;

  /// Create a copy of JoinCoupleRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$JoinCoupleRequestCopyWith<_JoinCoupleRequest> get copyWith =>
      __$JoinCoupleRequestCopyWithImpl<_JoinCoupleRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$JoinCoupleRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _JoinCoupleRequest &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, inviteCode);

  @override
  String toString() {
    return 'JoinCoupleRequest(inviteCode: $inviteCode)';
  }
}

/// @nodoc
abstract mixin class _$JoinCoupleRequestCopyWith<$Res>
    implements $JoinCoupleRequestCopyWith<$Res> {
  factory _$JoinCoupleRequestCopyWith(
          _JoinCoupleRequest value, $Res Function(_JoinCoupleRequest) _then) =
      __$JoinCoupleRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String inviteCode});
}

/// @nodoc
class __$JoinCoupleRequestCopyWithImpl<$Res>
    implements _$JoinCoupleRequestCopyWith<$Res> {
  __$JoinCoupleRequestCopyWithImpl(this._self, this._then);

  final _JoinCoupleRequest _self;
  final $Res Function(_JoinCoupleRequest) _then;

  /// Create a copy of JoinCoupleRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? inviteCode = null,
  }) {
    return _then(_JoinCoupleRequest(
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
