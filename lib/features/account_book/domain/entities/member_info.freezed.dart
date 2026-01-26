// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberInfo {
  String get userId;
  String get nickname;
  String get email;
  String get role;
  DateTime get joinedAt;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberInfoCopyWith<MemberInfo> get copyWith =>
      _$MemberInfoCopyWithImpl<MemberInfo>(this as MemberInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemberInfo &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, email, role, joinedAt);

  @override
  String toString() {
    return 'MemberInfo(userId: $userId, nickname: $nickname, email: $email, role: $role, joinedAt: $joinedAt)';
  }
}

/// @nodoc
abstract mixin class $MemberInfoCopyWith<$Res> {
  factory $MemberInfoCopyWith(
          MemberInfo value, $Res Function(MemberInfo) _then) =
      _$MemberInfoCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String email,
      String role,
      DateTime joinedAt});
}

/// @nodoc
class _$MemberInfoCopyWithImpl<$Res> implements $MemberInfoCopyWith<$Res> {
  _$MemberInfoCopyWithImpl(this._self, this._then);

  final MemberInfo _self;
  final $Res Function(MemberInfo) _then;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? email = null,
    Object? role = null,
    Object? joinedAt = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _self.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [MemberInfo].
extension MemberInfoPatterns on MemberInfo {
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
    TResult Function(_MemberInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemberInfo() when $default != null:
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
    TResult Function(_MemberInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberInfo():
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
    TResult? Function(_MemberInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberInfo() when $default != null:
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
    TResult Function(String userId, String nickname, String email, String role,
            DateTime joinedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemberInfo() when $default != null:
        return $default(_that.userId, _that.nickname, _that.email, _that.role,
            _that.joinedAt);
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
    TResult Function(String userId, String nickname, String email, String role,
            DateTime joinedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberInfo():
        return $default(_that.userId, _that.nickname, _that.email, _that.role,
            _that.joinedAt);
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
    TResult? Function(String userId, String nickname, String email, String role,
            DateTime joinedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemberInfo() when $default != null:
        return $default(_that.userId, _that.nickname, _that.email, _that.role,
            _that.joinedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MemberInfo implements MemberInfo {
  const _MemberInfo(
      {required this.userId,
      required this.nickname,
      required this.email,
      required this.role,
      required this.joinedAt});

  @override
  final String userId;
  @override
  final String nickname;
  @override
  final String email;
  @override
  final String role;
  @override
  final DateTime joinedAt;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MemberInfoCopyWith<_MemberInfo> get copyWith =>
      __$MemberInfoCopyWithImpl<_MemberInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MemberInfo &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, email, role, joinedAt);

  @override
  String toString() {
    return 'MemberInfo(userId: $userId, nickname: $nickname, email: $email, role: $role, joinedAt: $joinedAt)';
  }
}

/// @nodoc
abstract mixin class _$MemberInfoCopyWith<$Res>
    implements $MemberInfoCopyWith<$Res> {
  factory _$MemberInfoCopyWith(
          _MemberInfo value, $Res Function(_MemberInfo) _then) =
      __$MemberInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String email,
      String role,
      DateTime joinedAt});
}

/// @nodoc
class __$MemberInfoCopyWithImpl<$Res> implements _$MemberInfoCopyWith<$Res> {
  __$MemberInfoCopyWithImpl(this._self, this._then);

  final _MemberInfo _self;
  final $Res Function(_MemberInfo) _then;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? email = null,
    Object? role = null,
    Object? joinedAt = null,
  }) {
    return _then(_MemberInfo(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _self.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
