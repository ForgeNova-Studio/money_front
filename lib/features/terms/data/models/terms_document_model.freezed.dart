// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_document_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TermsDocumentModel {
  @DocumentTypeConverter()
  DocumentType get type;
  String get version;
  String get title;
  String get content;
  DateTime get effectiveAt;
  bool get isRequired;
  bool get requiresReconsent;
  String? get changeSummary;

  /// Create a copy of TermsDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermsDocumentModelCopyWith<TermsDocumentModel> get copyWith =>
      _$TermsDocumentModelCopyWithImpl<TermsDocumentModel>(
          this as TermsDocumentModel, _$identity);

  /// Serializes this TermsDocumentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsDocumentModel &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.effectiveAt, effectiveAt) ||
                other.effectiveAt == effectiveAt) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.requiresReconsent, requiresReconsent) ||
                other.requiresReconsent == requiresReconsent) &&
            (identical(other.changeSummary, changeSummary) ||
                other.changeSummary == changeSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, version, title, content,
      effectiveAt, isRequired, requiresReconsent, changeSummary);

  @override
  String toString() {
    return 'TermsDocumentModel(type: $type, version: $version, title: $title, content: $content, effectiveAt: $effectiveAt, isRequired: $isRequired, requiresReconsent: $requiresReconsent, changeSummary: $changeSummary)';
  }
}

/// @nodoc
abstract mixin class $TermsDocumentModelCopyWith<$Res> {
  factory $TermsDocumentModelCopyWith(
          TermsDocumentModel value, $Res Function(TermsDocumentModel) _then) =
      _$TermsDocumentModelCopyWithImpl;
  @useResult
  $Res call(
      {@DocumentTypeConverter() DocumentType type,
      String version,
      String title,
      String content,
      DateTime effectiveAt,
      bool isRequired,
      bool requiresReconsent,
      String? changeSummary});
}

/// @nodoc
class _$TermsDocumentModelCopyWithImpl<$Res>
    implements $TermsDocumentModelCopyWith<$Res> {
  _$TermsDocumentModelCopyWithImpl(this._self, this._then);

  final TermsDocumentModel _self;
  final $Res Function(TermsDocumentModel) _then;

  /// Create a copy of TermsDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? version = null,
    Object? title = null,
    Object? content = null,
    Object? effectiveAt = null,
    Object? isRequired = null,
    Object? requiresReconsent = null,
    Object? changeSummary = freezed,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      effectiveAt: null == effectiveAt
          ? _self.effectiveAt
          : effectiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRequired: null == isRequired
          ? _self.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresReconsent: null == requiresReconsent
          ? _self.requiresReconsent
          : requiresReconsent // ignore: cast_nullable_to_non_nullable
              as bool,
      changeSummary: freezed == changeSummary
          ? _self.changeSummary
          : changeSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TermsDocumentModel].
extension TermsDocumentModelPatterns on TermsDocumentModel {
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
    TResult Function(_TermsDocumentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsDocumentModel() when $default != null:
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
    TResult Function(_TermsDocumentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsDocumentModel():
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
    TResult? Function(_TermsDocumentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsDocumentModel() when $default != null:
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
            @DocumentTypeConverter() DocumentType type,
            String version,
            String title,
            String content,
            DateTime effectiveAt,
            bool isRequired,
            bool requiresReconsent,
            String? changeSummary)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsDocumentModel() when $default != null:
        return $default(
            _that.type,
            _that.version,
            _that.title,
            _that.content,
            _that.effectiveAt,
            _that.isRequired,
            _that.requiresReconsent,
            _that.changeSummary);
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
            @DocumentTypeConverter() DocumentType type,
            String version,
            String title,
            String content,
            DateTime effectiveAt,
            bool isRequired,
            bool requiresReconsent,
            String? changeSummary)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsDocumentModel():
        return $default(
            _that.type,
            _that.version,
            _that.title,
            _that.content,
            _that.effectiveAt,
            _that.isRequired,
            _that.requiresReconsent,
            _that.changeSummary);
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
            @DocumentTypeConverter() DocumentType type,
            String version,
            String title,
            String content,
            DateTime effectiveAt,
            bool isRequired,
            bool requiresReconsent,
            String? changeSummary)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsDocumentModel() when $default != null:
        return $default(
            _that.type,
            _that.version,
            _that.title,
            _that.content,
            _that.effectiveAt,
            _that.isRequired,
            _that.requiresReconsent,
            _that.changeSummary);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TermsDocumentModel extends TermsDocumentModel {
  const _TermsDocumentModel(
      {@DocumentTypeConverter() required this.type,
      required this.version,
      required this.title,
      required this.content,
      required this.effectiveAt,
      required this.isRequired,
      this.requiresReconsent = false,
      this.changeSummary})
      : super._();
  factory _TermsDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$TermsDocumentModelFromJson(json);

  @override
  @DocumentTypeConverter()
  final DocumentType type;
  @override
  final String version;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime effectiveAt;
  @override
  final bool isRequired;
  @override
  @JsonKey()
  final bool requiresReconsent;
  @override
  final String? changeSummary;

  /// Create a copy of TermsDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TermsDocumentModelCopyWith<_TermsDocumentModel> get copyWith =>
      __$TermsDocumentModelCopyWithImpl<_TermsDocumentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TermsDocumentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TermsDocumentModel &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.effectiveAt, effectiveAt) ||
                other.effectiveAt == effectiveAt) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.requiresReconsent, requiresReconsent) ||
                other.requiresReconsent == requiresReconsent) &&
            (identical(other.changeSummary, changeSummary) ||
                other.changeSummary == changeSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, version, title, content,
      effectiveAt, isRequired, requiresReconsent, changeSummary);

  @override
  String toString() {
    return 'TermsDocumentModel(type: $type, version: $version, title: $title, content: $content, effectiveAt: $effectiveAt, isRequired: $isRequired, requiresReconsent: $requiresReconsent, changeSummary: $changeSummary)';
  }
}

/// @nodoc
abstract mixin class _$TermsDocumentModelCopyWith<$Res>
    implements $TermsDocumentModelCopyWith<$Res> {
  factory _$TermsDocumentModelCopyWith(
          _TermsDocumentModel value, $Res Function(_TermsDocumentModel) _then) =
      __$TermsDocumentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DocumentTypeConverter() DocumentType type,
      String version,
      String title,
      String content,
      DateTime effectiveAt,
      bool isRequired,
      bool requiresReconsent,
      String? changeSummary});
}

/// @nodoc
class __$TermsDocumentModelCopyWithImpl<$Res>
    implements _$TermsDocumentModelCopyWith<$Res> {
  __$TermsDocumentModelCopyWithImpl(this._self, this._then);

  final _TermsDocumentModel _self;
  final $Res Function(_TermsDocumentModel) _then;

  /// Create a copy of TermsDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? version = null,
    Object? title = null,
    Object? content = null,
    Object? effectiveAt = null,
    Object? isRequired = null,
    Object? requiresReconsent = null,
    Object? changeSummary = freezed,
  }) {
    return _then(_TermsDocumentModel(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      effectiveAt: null == effectiveAt
          ? _self.effectiveAt
          : effectiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRequired: null == isRequired
          ? _self.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresReconsent: null == requiresReconsent
          ? _self.requiresReconsent
          : requiresReconsent // ignore: cast_nullable_to_non_nullable
              as bool,
      changeSummary: freezed == changeSummary
          ? _self.changeSummary
          : changeSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
