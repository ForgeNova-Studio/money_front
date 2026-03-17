// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agreement_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgreementRequestModel {
  @DocumentTypeConverter()
  DocumentType get type;
  String get version;
  bool get agreed;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgreementRequestModelCopyWith<AgreementRequestModel> get copyWith =>
      _$AgreementRequestModelCopyWithImpl<AgreementRequestModel>(
          this as AgreementRequestModel, _$identity);

  /// Serializes this AgreementRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgreementRequestModel &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, version, agreed);

  @override
  String toString() {
    return 'AgreementRequestModel(type: $type, version: $version, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class $AgreementRequestModelCopyWith<$Res> {
  factory $AgreementRequestModelCopyWith(AgreementRequestModel value,
          $Res Function(AgreementRequestModel) _then) =
      _$AgreementRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {@DocumentTypeConverter() DocumentType type,
      String version,
      bool agreed});
}

/// @nodoc
class _$AgreementRequestModelCopyWithImpl<$Res>
    implements $AgreementRequestModelCopyWith<$Res> {
  _$AgreementRequestModelCopyWithImpl(this._self, this._then);

  final AgreementRequestModel _self;
  final $Res Function(AgreementRequestModel) _then;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? version = null,
    Object? agreed = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [AgreementRequestModel].
extension AgreementRequestModelPatterns on AgreementRequestModel {
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
    TResult Function(_AgreementRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgreementRequestModel() when $default != null:
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
    TResult Function(_AgreementRequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgreementRequestModel():
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
    TResult? Function(_AgreementRequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgreementRequestModel() when $default != null:
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
    TResult Function(@DocumentTypeConverter() DocumentType type, String version,
            bool agreed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgreementRequestModel() when $default != null:
        return $default(_that.type, _that.version, _that.agreed);
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
    TResult Function(@DocumentTypeConverter() DocumentType type, String version,
            bool agreed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgreementRequestModel():
        return $default(_that.type, _that.version, _that.agreed);
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
    TResult? Function(@DocumentTypeConverter() DocumentType type,
            String version, bool agreed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgreementRequestModel() when $default != null:
        return $default(_that.type, _that.version, _that.agreed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgreementRequestModel extends AgreementRequestModel {
  const _AgreementRequestModel(
      {@DocumentTypeConverter() required this.type,
      required this.version,
      required this.agreed})
      : super._();
  factory _AgreementRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementRequestModelFromJson(json);

  @override
  @DocumentTypeConverter()
  final DocumentType type;
  @override
  final String version;
  @override
  final bool agreed;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgreementRequestModelCopyWith<_AgreementRequestModel> get copyWith =>
      __$AgreementRequestModelCopyWithImpl<_AgreementRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgreementRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgreementRequestModel &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, version, agreed);

  @override
  String toString() {
    return 'AgreementRequestModel(type: $type, version: $version, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class _$AgreementRequestModelCopyWith<$Res>
    implements $AgreementRequestModelCopyWith<$Res> {
  factory _$AgreementRequestModelCopyWith(_AgreementRequestModel value,
          $Res Function(_AgreementRequestModel) _then) =
      __$AgreementRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DocumentTypeConverter() DocumentType type,
      String version,
      bool agreed});
}

/// @nodoc
class __$AgreementRequestModelCopyWithImpl<$Res>
    implements _$AgreementRequestModelCopyWith<$Res> {
  __$AgreementRequestModelCopyWithImpl(this._self, this._then);

  final _AgreementRequestModel _self;
  final $Res Function(_AgreementRequestModel) _then;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? version = null,
    Object? agreed = null,
  }) {
    return _then(_AgreementRequestModel(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
