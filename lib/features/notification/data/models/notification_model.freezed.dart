// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {
  String get notificationId;
  String get title;
  String get message;
  String get type;
  bool get isRead;
  DateTime? get createdAt; // TODO: 백엔드 saveAndFlush 배포 후 required로 원복
  DateTime? get readAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      _$NotificationModelCopyWithImpl<NotificationModel>(
          this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationModel &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, notificationId, title, message,
      type, isRead, createdAt, readAt);

  @override
  String toString() {
    return 'NotificationModel(notificationId: $notificationId, title: $title, message: $message, type: $type, isRead: $isRead, createdAt: $createdAt, readAt: $readAt)';
  }
}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) _then) =
      _$NotificationModelCopyWithImpl;
  @useResult
  $Res call(
      {String notificationId,
      String title,
      String message,
      String type,
      bool isRead,
      DateTime? createdAt,
      DateTime? readAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? readAt = freezed,
  }) {
    return _then(_self.copyWith(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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
    TResult Function(_NotificationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
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
    TResult Function(_NotificationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel():
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
    TResult? Function(_NotificationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
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
    TResult Function(String notificationId, String title, String message,
            String type, bool isRead, DateTime? createdAt, DateTime? readAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
        return $default(_that.notificationId, _that.title, _that.message,
            _that.type, _that.isRead, _that.createdAt, _that.readAt);
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
    TResult Function(String notificationId, String title, String message,
            String type, bool isRead, DateTime? createdAt, DateTime? readAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel():
        return $default(_that.notificationId, _that.title, _that.message,
            _that.type, _that.isRead, _that.createdAt, _that.readAt);
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
    TResult? Function(String notificationId, String title, String message,
            String type, bool isRead, DateTime? createdAt, DateTime? readAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
        return $default(_that.notificationId, _that.title, _that.message,
            _that.type, _that.isRead, _that.createdAt, _that.readAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationModel implements NotificationModel {
  const _NotificationModel(
      {required this.notificationId,
      required this.title,
      required this.message,
      required this.type,
      required this.isRead,
      this.createdAt,
      this.readAt});
  factory _NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @override
  final String notificationId;
  @override
  final String title;
  @override
  final String message;
  @override
  final String type;
  @override
  final bool isRead;
  @override
  final DateTime? createdAt;
// TODO: 백엔드 saveAndFlush 배포 후 required로 원복
  @override
  final DateTime? readAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationModelCopyWith<_NotificationModel> get copyWith =>
      __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationModel &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, notificationId, title, message,
      type, isRead, createdAt, readAt);

  @override
  String toString() {
    return 'NotificationModel(notificationId: $notificationId, title: $title, message: $message, type: $type, isRead: $isRead, createdAt: $createdAt, readAt: $readAt)';
  }
}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(
          _NotificationModel value, $Res Function(_NotificationModel) _then) =
      __$NotificationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String notificationId,
      String title,
      String message,
      String type,
      bool isRead,
      DateTime? createdAt,
      DateTime? readAt});
}

/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notificationId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? readAt = freezed,
  }) {
    return _then(_NotificationModel(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$NotificationRequestModel {
  String get targetEmail;
  String get title;
  String get message;
  String get type;

  /// Create a copy of NotificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationRequestModelCopyWith<NotificationRequestModel> get copyWith =>
      _$NotificationRequestModelCopyWithImpl<NotificationRequestModel>(
          this as NotificationRequestModel, _$identity);

  /// Serializes this NotificationRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationRequestModel &&
            (identical(other.targetEmail, targetEmail) ||
                other.targetEmail == targetEmail) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetEmail, title, message, type);

  @override
  String toString() {
    return 'NotificationRequestModel(targetEmail: $targetEmail, title: $title, message: $message, type: $type)';
  }
}

/// @nodoc
abstract mixin class $NotificationRequestModelCopyWith<$Res> {
  factory $NotificationRequestModelCopyWith(NotificationRequestModel value,
          $Res Function(NotificationRequestModel) _then) =
      _$NotificationRequestModelCopyWithImpl;
  @useResult
  $Res call({String targetEmail, String title, String message, String type});
}

/// @nodoc
class _$NotificationRequestModelCopyWithImpl<$Res>
    implements $NotificationRequestModelCopyWith<$Res> {
  _$NotificationRequestModelCopyWithImpl(this._self, this._then);

  final NotificationRequestModel _self;
  final $Res Function(NotificationRequestModel) _then;

  /// Create a copy of NotificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetEmail = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
  }) {
    return _then(_self.copyWith(
      targetEmail: null == targetEmail
          ? _self.targetEmail
          : targetEmail // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationRequestModel].
extension NotificationRequestModelPatterns on NotificationRequestModel {
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
    TResult Function(_NotificationRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationRequestModel() when $default != null:
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
    TResult Function(_NotificationRequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationRequestModel():
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
    TResult? Function(_NotificationRequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationRequestModel() when $default != null:
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
            String targetEmail, String title, String message, String type)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationRequestModel() when $default != null:
        return $default(
            _that.targetEmail, _that.title, _that.message, _that.type);
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
            String targetEmail, String title, String message, String type)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationRequestModel():
        return $default(
            _that.targetEmail, _that.title, _that.message, _that.type);
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
            String targetEmail, String title, String message, String type)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationRequestModel() when $default != null:
        return $default(
            _that.targetEmail, _that.title, _that.message, _that.type);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationRequestModel implements NotificationRequestModel {
  const _NotificationRequestModel(
      {required this.targetEmail,
      required this.title,
      required this.message,
      this.type = 'PERSONAL'});
  factory _NotificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestModelFromJson(json);

  @override
  final String targetEmail;
  @override
  final String title;
  @override
  final String message;
  @override
  @JsonKey()
  final String type;

  /// Create a copy of NotificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationRequestModelCopyWith<_NotificationRequestModel> get copyWith =>
      __$NotificationRequestModelCopyWithImpl<_NotificationRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationRequestModel &&
            (identical(other.targetEmail, targetEmail) ||
                other.targetEmail == targetEmail) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetEmail, title, message, type);

  @override
  String toString() {
    return 'NotificationRequestModel(targetEmail: $targetEmail, title: $title, message: $message, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$NotificationRequestModelCopyWith<$Res>
    implements $NotificationRequestModelCopyWith<$Res> {
  factory _$NotificationRequestModelCopyWith(_NotificationRequestModel value,
          $Res Function(_NotificationRequestModel) _then) =
      __$NotificationRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call({String targetEmail, String title, String message, String type});
}

/// @nodoc
class __$NotificationRequestModelCopyWithImpl<$Res>
    implements _$NotificationRequestModelCopyWith<$Res> {
  __$NotificationRequestModelCopyWithImpl(this._self, this._then);

  final _NotificationRequestModel _self;
  final $Res Function(_NotificationRequestModel) _then;

  /// Create a copy of NotificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? targetEmail = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
  }) {
    return _then(_NotificationRequestModel(
      targetEmail: null == targetEmail
          ? _self.targetEmail
          : targetEmail // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UnreadCountModel {
  int get count;

  /// Create a copy of UnreadCountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnreadCountModelCopyWith<UnreadCountModel> get copyWith =>
      _$UnreadCountModelCopyWithImpl<UnreadCountModel>(
          this as UnreadCountModel, _$identity);

  /// Serializes this UnreadCountModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnreadCountModel &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'UnreadCountModel(count: $count)';
  }
}

/// @nodoc
abstract mixin class $UnreadCountModelCopyWith<$Res> {
  factory $UnreadCountModelCopyWith(
          UnreadCountModel value, $Res Function(UnreadCountModel) _then) =
      _$UnreadCountModelCopyWithImpl;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$UnreadCountModelCopyWithImpl<$Res>
    implements $UnreadCountModelCopyWith<$Res> {
  _$UnreadCountModelCopyWithImpl(this._self, this._then);

  final UnreadCountModel _self;
  final $Res Function(UnreadCountModel) _then;

  /// Create a copy of UnreadCountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [UnreadCountModel].
extension UnreadCountModelPatterns on UnreadCountModel {
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
    TResult Function(_UnreadCountModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnreadCountModel() when $default != null:
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
    TResult Function(_UnreadCountModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountModel():
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
    TResult? Function(_UnreadCountModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountModel() when $default != null:
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
    TResult Function(int count)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UnreadCountModel() when $default != null:
        return $default(_that.count);
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
    TResult Function(int count) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountModel():
        return $default(_that.count);
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
    TResult? Function(int count)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UnreadCountModel() when $default != null:
        return $default(_that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UnreadCountModel implements UnreadCountModel {
  const _UnreadCountModel({required this.count});
  factory _UnreadCountModel.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountModelFromJson(json);

  @override
  final int count;

  /// Create a copy of UnreadCountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UnreadCountModelCopyWith<_UnreadCountModel> get copyWith =>
      __$UnreadCountModelCopyWithImpl<_UnreadCountModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UnreadCountModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UnreadCountModel &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count);

  @override
  String toString() {
    return 'UnreadCountModel(count: $count)';
  }
}

/// @nodoc
abstract mixin class _$UnreadCountModelCopyWith<$Res>
    implements $UnreadCountModelCopyWith<$Res> {
  factory _$UnreadCountModelCopyWith(
          _UnreadCountModel value, $Res Function(_UnreadCountModel) _then) =
      __$UnreadCountModelCopyWithImpl;
  @override
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$UnreadCountModelCopyWithImpl<$Res>
    implements _$UnreadCountModelCopyWith<$Res> {
  __$UnreadCountModelCopyWithImpl(this._self, this._then);

  final _UnreadCountModel _self;
  final $Res Function(_UnreadCountModel) _then;

  /// Create a copy of UnreadCountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
  }) {
    return _then(_UnreadCountModel(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
