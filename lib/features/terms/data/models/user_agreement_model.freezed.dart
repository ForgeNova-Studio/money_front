// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_agreement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAgreementModel {
  @DocumentTypeConverter()
  DocumentType get documentType;
  String get documentVersion;
  bool get agreed;
  DateTime get agreedAt;

  /// Create a copy of UserAgreementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserAgreementModelCopyWith<UserAgreementModel> get copyWith =>
      _$UserAgreementModelCopyWithImpl<UserAgreementModel>(
          this as UserAgreementModel, _$identity);

  /// Serializes this UserAgreementModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserAgreementModel &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentVersion, documentVersion) ||
                other.documentVersion == documentVersion) &&
            (identical(other.agreed, agreed) || other.agreed == agreed) &&
            (identical(other.agreedAt, agreedAt) ||
                other.agreedAt == agreedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentType, documentVersion, agreed, agreedAt);

  @override
  String toString() {
    return 'UserAgreementModel(documentType: $documentType, documentVersion: $documentVersion, agreed: $agreed, agreedAt: $agreedAt)';
  }
}

/// @nodoc
abstract mixin class $UserAgreementModelCopyWith<$Res> {
  factory $UserAgreementModelCopyWith(
          UserAgreementModel value, $Res Function(UserAgreementModel) _then) =
      _$UserAgreementModelCopyWithImpl;
  @useResult
  $Res call(
      {@DocumentTypeConverter() DocumentType documentType,
      String documentVersion,
      bool agreed,
      DateTime agreedAt});
}

/// @nodoc
class _$UserAgreementModelCopyWithImpl<$Res>
    implements $UserAgreementModelCopyWith<$Res> {
  _$UserAgreementModelCopyWithImpl(this._self, this._then);

  final UserAgreementModel _self;
  final $Res Function(UserAgreementModel) _then;

  /// Create a copy of UserAgreementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? documentVersion = null,
    Object? agreed = null,
    Object? agreedAt = null,
  }) {
    return _then(_self.copyWith(
      documentType: null == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      documentVersion: null == documentVersion
          ? _self.documentVersion
          : documentVersion // ignore: cast_nullable_to_non_nullable
              as String,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      agreedAt: null == agreedAt
          ? _self.agreedAt
          : agreedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserAgreementModel].
extension UserAgreementModelPatterns on UserAgreementModel {
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
    TResult Function(_UserAgreementModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserAgreementModel() when $default != null:
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
    TResult Function(_UserAgreementModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserAgreementModel():
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
    TResult? Function(_UserAgreementModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserAgreementModel() when $default != null:
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
    TResult Function(@DocumentTypeConverter() DocumentType documentType,
            String documentVersion, bool agreed, DateTime agreedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserAgreementModel() when $default != null:
        return $default(_that.documentType, _that.documentVersion, _that.agreed,
            _that.agreedAt);
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
    TResult Function(@DocumentTypeConverter() DocumentType documentType,
            String documentVersion, bool agreed, DateTime agreedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserAgreementModel():
        return $default(_that.documentType, _that.documentVersion, _that.agreed,
            _that.agreedAt);
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
    TResult? Function(@DocumentTypeConverter() DocumentType documentType,
            String documentVersion, bool agreed, DateTime agreedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserAgreementModel() when $default != null:
        return $default(_that.documentType, _that.documentVersion, _that.agreed,
            _that.agreedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserAgreementModel extends UserAgreementModel {
  const _UserAgreementModel(
      {@DocumentTypeConverter() required this.documentType,
      required this.documentVersion,
      required this.agreed,
      required this.agreedAt})
      : super._();
  factory _UserAgreementModel.fromJson(Map<String, dynamic> json) =>
      _$UserAgreementModelFromJson(json);

  @override
  @DocumentTypeConverter()
  final DocumentType documentType;
  @override
  final String documentVersion;
  @override
  final bool agreed;
  @override
  final DateTime agreedAt;

  /// Create a copy of UserAgreementModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserAgreementModelCopyWith<_UserAgreementModel> get copyWith =>
      __$UserAgreementModelCopyWithImpl<_UserAgreementModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserAgreementModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserAgreementModel &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentVersion, documentVersion) ||
                other.documentVersion == documentVersion) &&
            (identical(other.agreed, agreed) || other.agreed == agreed) &&
            (identical(other.agreedAt, agreedAt) ||
                other.agreedAt == agreedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentType, documentVersion, agreed, agreedAt);

  @override
  String toString() {
    return 'UserAgreementModel(documentType: $documentType, documentVersion: $documentVersion, agreed: $agreed, agreedAt: $agreedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserAgreementModelCopyWith<$Res>
    implements $UserAgreementModelCopyWith<$Res> {
  factory _$UserAgreementModelCopyWith(
          _UserAgreementModel value, $Res Function(_UserAgreementModel) _then) =
      __$UserAgreementModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DocumentTypeConverter() DocumentType documentType,
      String documentVersion,
      bool agreed,
      DateTime agreedAt});
}

/// @nodoc
class __$UserAgreementModelCopyWithImpl<$Res>
    implements _$UserAgreementModelCopyWith<$Res> {
  __$UserAgreementModelCopyWithImpl(this._self, this._then);

  final _UserAgreementModel _self;
  final $Res Function(_UserAgreementModel) _then;

  /// Create a copy of UserAgreementModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? documentType = null,
    Object? documentVersion = null,
    Object? agreed = null,
    Object? agreedAt = null,
  }) {
    return _then(_UserAgreementModel(
      documentType: null == documentType
          ? _self.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      documentVersion: null == documentVersion
          ? _self.documentVersion
          : documentVersion // ignore: cast_nullable_to_non_nullable
              as String,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      agreedAt: null == agreedAt
          ? _self.agreedAt
          : agreedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
