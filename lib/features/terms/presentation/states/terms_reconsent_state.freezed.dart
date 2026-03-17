// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_reconsent_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TermsReconsentItem {
  /// 약관 문서
  TermsDocumentModel get document;

  /// 동의 여부
  bool get agreed;

  /// Create a copy of TermsReconsentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermsReconsentItemCopyWith<TermsReconsentItem> get copyWith =>
      _$TermsReconsentItemCopyWithImpl<TermsReconsentItem>(
          this as TermsReconsentItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsReconsentItem &&
            (identical(other.document, document) ||
                other.document == document) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, document, agreed);

  @override
  String toString() {
    return 'TermsReconsentItem(document: $document, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class $TermsReconsentItemCopyWith<$Res> {
  factory $TermsReconsentItemCopyWith(
          TermsReconsentItem value, $Res Function(TermsReconsentItem) _then) =
      _$TermsReconsentItemCopyWithImpl;
  @useResult
  $Res call({TermsDocumentModel document, bool agreed});

  $TermsDocumentModelCopyWith<$Res> get document;
}

/// @nodoc
class _$TermsReconsentItemCopyWithImpl<$Res>
    implements $TermsReconsentItemCopyWith<$Res> {
  _$TermsReconsentItemCopyWithImpl(this._self, this._then);

  final TermsReconsentItem _self;
  final $Res Function(TermsReconsentItem) _then;

  /// Create a copy of TermsReconsentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? document = null,
    Object? agreed = null,
  }) {
    return _then(_self.copyWith(
      document: null == document
          ? _self.document
          : document // ignore: cast_nullable_to_non_nullable
              as TermsDocumentModel,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of TermsReconsentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TermsDocumentModelCopyWith<$Res> get document {
    return $TermsDocumentModelCopyWith<$Res>(_self.document, (value) {
      return _then(_self.copyWith(document: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TermsReconsentItem].
extension TermsReconsentItemPatterns on TermsReconsentItem {
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
    TResult Function(_TermsReconsentItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentItem() when $default != null:
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
    TResult Function(_TermsReconsentItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentItem():
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
    TResult? Function(_TermsReconsentItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentItem() when $default != null:
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
    TResult Function(TermsDocumentModel document, bool agreed)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentItem() when $default != null:
        return $default(_that.document, _that.agreed);
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
    TResult Function(TermsDocumentModel document, bool agreed) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentItem():
        return $default(_that.document, _that.agreed);
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
    TResult? Function(TermsDocumentModel document, bool agreed)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentItem() when $default != null:
        return $default(_that.document, _that.agreed);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TermsReconsentItem extends TermsReconsentItem {
  const _TermsReconsentItem({required this.document, this.agreed = false})
      : super._();

  /// 약관 문서
  @override
  final TermsDocumentModel document;

  /// 동의 여부
  @override
  @JsonKey()
  final bool agreed;

  /// Create a copy of TermsReconsentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TermsReconsentItemCopyWith<_TermsReconsentItem> get copyWith =>
      __$TermsReconsentItemCopyWithImpl<_TermsReconsentItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TermsReconsentItem &&
            (identical(other.document, document) ||
                other.document == document) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, document, agreed);

  @override
  String toString() {
    return 'TermsReconsentItem(document: $document, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class _$TermsReconsentItemCopyWith<$Res>
    implements $TermsReconsentItemCopyWith<$Res> {
  factory _$TermsReconsentItemCopyWith(
          _TermsReconsentItem value, $Res Function(_TermsReconsentItem) _then) =
      __$TermsReconsentItemCopyWithImpl;
  @override
  @useResult
  $Res call({TermsDocumentModel document, bool agreed});

  @override
  $TermsDocumentModelCopyWith<$Res> get document;
}

/// @nodoc
class __$TermsReconsentItemCopyWithImpl<$Res>
    implements _$TermsReconsentItemCopyWith<$Res> {
  __$TermsReconsentItemCopyWithImpl(this._self, this._then);

  final _TermsReconsentItem _self;
  final $Res Function(_TermsReconsentItem) _then;

  /// Create a copy of TermsReconsentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? document = null,
    Object? agreed = null,
  }) {
    return _then(_TermsReconsentItem(
      document: null == document
          ? _self.document
          : document // ignore: cast_nullable_to_non_nullable
              as TermsDocumentModel,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of TermsReconsentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TermsDocumentModelCopyWith<$Res> get document {
    return $TermsDocumentModelCopyWith<$Res>(_self.document, (value) {
      return _then(_self.copyWith(document: value));
    });
  }
}

/// @nodoc
mixin _$TermsReconsentState {
  /// 재동의가 필요한 약관 목록
  List<TermsReconsentItem> get items;

  /// 로딩 상태
  bool get isLoading;

  /// 제출 중 상태
  bool get isSubmitting;

  /// 에러 메시지
  String? get errorMessage;

  /// Create a copy of TermsReconsentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermsReconsentStateCopyWith<TermsReconsentState> get copyWith =>
      _$TermsReconsentStateCopyWithImpl<TermsReconsentState>(
          this as TermsReconsentState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsReconsentState &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      isLoading,
      isSubmitting,
      errorMessage);

  @override
  String toString() {
    return 'TermsReconsentState(items: $items, isLoading: $isLoading, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $TermsReconsentStateCopyWith<$Res> {
  factory $TermsReconsentStateCopyWith(
          TermsReconsentState value, $Res Function(TermsReconsentState) _then) =
      _$TermsReconsentStateCopyWithImpl;
  @useResult
  $Res call(
      {List<TermsReconsentItem> items,
      bool isLoading,
      bool isSubmitting,
      String? errorMessage});
}

/// @nodoc
class _$TermsReconsentStateCopyWithImpl<$Res>
    implements $TermsReconsentStateCopyWith<$Res> {
  _$TermsReconsentStateCopyWithImpl(this._self, this._then);

  final TermsReconsentState _self;
  final $Res Function(TermsReconsentState) _then;

  /// Create a copy of TermsReconsentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TermsReconsentItem>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TermsReconsentState].
extension TermsReconsentStatePatterns on TermsReconsentState {
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
    TResult Function(_TermsReconsentState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentState() when $default != null:
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
    TResult Function(_TermsReconsentState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentState():
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
    TResult? Function(_TermsReconsentState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentState() when $default != null:
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
    TResult Function(List<TermsReconsentItem> items, bool isLoading,
            bool isSubmitting, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentState() when $default != null:
        return $default(_that.items, _that.isLoading, _that.isSubmitting,
            _that.errorMessage);
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
    TResult Function(List<TermsReconsentItem> items, bool isLoading,
            bool isSubmitting, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentState():
        return $default(_that.items, _that.isLoading, _that.isSubmitting,
            _that.errorMessage);
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
    TResult? Function(List<TermsReconsentItem> items, bool isLoading,
            bool isSubmitting, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsReconsentState() when $default != null:
        return $default(_that.items, _that.isLoading, _that.isSubmitting,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TermsReconsentState extends TermsReconsentState {
  const _TermsReconsentState(
      {final List<TermsReconsentItem> items = const [],
      this.isLoading = false,
      this.isSubmitting = false,
      this.errorMessage})
      : _items = items,
        super._();

  /// 재동의가 필요한 약관 목록
  final List<TermsReconsentItem> _items;

  /// 재동의가 필요한 약관 목록
  @override
  @JsonKey()
  List<TermsReconsentItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// 로딩 상태
  @override
  @JsonKey()
  final bool isLoading;

  /// 제출 중 상태
  @override
  @JsonKey()
  final bool isSubmitting;

  /// 에러 메시지
  @override
  final String? errorMessage;

  /// Create a copy of TermsReconsentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TermsReconsentStateCopyWith<_TermsReconsentState> get copyWith =>
      __$TermsReconsentStateCopyWithImpl<_TermsReconsentState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TermsReconsentState &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      isLoading,
      isSubmitting,
      errorMessage);

  @override
  String toString() {
    return 'TermsReconsentState(items: $items, isLoading: $isLoading, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$TermsReconsentStateCopyWith<$Res>
    implements $TermsReconsentStateCopyWith<$Res> {
  factory _$TermsReconsentStateCopyWith(_TermsReconsentState value,
          $Res Function(_TermsReconsentState) _then) =
      __$TermsReconsentStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<TermsReconsentItem> items,
      bool isLoading,
      bool isSubmitting,
      String? errorMessage});
}

/// @nodoc
class __$TermsReconsentStateCopyWithImpl<$Res>
    implements _$TermsReconsentStateCopyWith<$Res> {
  __$TermsReconsentStateCopyWithImpl(this._self, this._then);

  final _TermsReconsentState _self;
  final $Res Function(_TermsReconsentState) _then;

  /// Create a copy of TermsReconsentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_TermsReconsentState(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TermsReconsentItem>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TermsReconsentCheckResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsReconsentCheckResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TermsReconsentCheckResult()';
  }
}

/// @nodoc
class $TermsReconsentCheckResultCopyWith<$Res> {
  $TermsReconsentCheckResultCopyWith(
      TermsReconsentCheckResult _, $Res Function(TermsReconsentCheckResult) __);
}

/// Adds pattern-matching-related methods to [TermsReconsentCheckResult].
extension TermsReconsentCheckResultPatterns on TermsReconsentCheckResult {
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
    TResult Function(TermsReconsentCheckResultRequired value)? required,
    TResult Function(TermsReconsentCheckResultNotRequired value)? notRequired,
    TResult Function(TermsReconsentCheckResultError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TermsReconsentCheckResultRequired() when required != null:
        return required(_that);
      case TermsReconsentCheckResultNotRequired() when notRequired != null:
        return notRequired(_that);
      case TermsReconsentCheckResultError() when error != null:
        return error(_that);
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
    required TResult Function(TermsReconsentCheckResultRequired value) required,
    required TResult Function(TermsReconsentCheckResultNotRequired value)
        notRequired,
    required TResult Function(TermsReconsentCheckResultError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case TermsReconsentCheckResultRequired():
        return required(_that);
      case TermsReconsentCheckResultNotRequired():
        return notRequired(_that);
      case TermsReconsentCheckResultError():
        return error(_that);
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
    TResult? Function(TermsReconsentCheckResultRequired value)? required,
    TResult? Function(TermsReconsentCheckResultNotRequired value)? notRequired,
    TResult? Function(TermsReconsentCheckResultError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case TermsReconsentCheckResultRequired() when required != null:
        return required(_that);
      case TermsReconsentCheckResultNotRequired() when notRequired != null:
        return notRequired(_that);
      case TermsReconsentCheckResultError() when error != null:
        return error(_that);
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
    TResult Function(List<TermsReconsentItem> items)? required,
    TResult Function()? notRequired,
    TResult Function(Object error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TermsReconsentCheckResultRequired() when required != null:
        return required(_that.items);
      case TermsReconsentCheckResultNotRequired() when notRequired != null:
        return notRequired();
      case TermsReconsentCheckResultError() when error != null:
        return error(_that.error);
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
    required TResult Function(List<TermsReconsentItem> items) required,
    required TResult Function() notRequired,
    required TResult Function(Object error) error,
  }) {
    final _that = this;
    switch (_that) {
      case TermsReconsentCheckResultRequired():
        return required(_that.items);
      case TermsReconsentCheckResultNotRequired():
        return notRequired();
      case TermsReconsentCheckResultError():
        return error(_that.error);
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
    TResult? Function(List<TermsReconsentItem> items)? required,
    TResult? Function()? notRequired,
    TResult? Function(Object error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case TermsReconsentCheckResultRequired() when required != null:
        return required(_that.items);
      case TermsReconsentCheckResultNotRequired() when notRequired != null:
        return notRequired();
      case TermsReconsentCheckResultError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class TermsReconsentCheckResultRequired implements TermsReconsentCheckResult {
  const TermsReconsentCheckResultRequired(final List<TermsReconsentItem> items)
      : _items = items;

  final List<TermsReconsentItem> _items;
  List<TermsReconsentItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of TermsReconsentCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermsReconsentCheckResultRequiredCopyWith<TermsReconsentCheckResultRequired>
      get copyWith => _$TermsReconsentCheckResultRequiredCopyWithImpl<
          TermsReconsentCheckResultRequired>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsReconsentCheckResultRequired &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'TermsReconsentCheckResult.required(items: $items)';
  }
}

/// @nodoc
abstract mixin class $TermsReconsentCheckResultRequiredCopyWith<$Res>
    implements $TermsReconsentCheckResultCopyWith<$Res> {
  factory $TermsReconsentCheckResultRequiredCopyWith(
          TermsReconsentCheckResultRequired value,
          $Res Function(TermsReconsentCheckResultRequired) _then) =
      _$TermsReconsentCheckResultRequiredCopyWithImpl;
  @useResult
  $Res call({List<TermsReconsentItem> items});
}

/// @nodoc
class _$TermsReconsentCheckResultRequiredCopyWithImpl<$Res>
    implements $TermsReconsentCheckResultRequiredCopyWith<$Res> {
  _$TermsReconsentCheckResultRequiredCopyWithImpl(this._self, this._then);

  final TermsReconsentCheckResultRequired _self;
  final $Res Function(TermsReconsentCheckResultRequired) _then;

  /// Create a copy of TermsReconsentCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(TermsReconsentCheckResultRequired(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TermsReconsentItem>,
    ));
  }
}

/// @nodoc

class TermsReconsentCheckResultNotRequired
    implements TermsReconsentCheckResult {
  const TermsReconsentCheckResultNotRequired();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsReconsentCheckResultNotRequired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TermsReconsentCheckResult.notRequired()';
  }
}

/// @nodoc

class TermsReconsentCheckResultError implements TermsReconsentCheckResult {
  const TermsReconsentCheckResultError(this.error);

  final Object error;

  /// Create a copy of TermsReconsentCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermsReconsentCheckResultErrorCopyWith<TermsReconsentCheckResultError>
      get copyWith => _$TermsReconsentCheckResultErrorCopyWithImpl<
          TermsReconsentCheckResultError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsReconsentCheckResultError &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'TermsReconsentCheckResult.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $TermsReconsentCheckResultErrorCopyWith<$Res>
    implements $TermsReconsentCheckResultCopyWith<$Res> {
  factory $TermsReconsentCheckResultErrorCopyWith(
          TermsReconsentCheckResultError value,
          $Res Function(TermsReconsentCheckResultError) _then) =
      _$TermsReconsentCheckResultErrorCopyWithImpl;
  @useResult
  $Res call({Object error});
}

/// @nodoc
class _$TermsReconsentCheckResultErrorCopyWithImpl<$Res>
    implements $TermsReconsentCheckResultErrorCopyWith<$Res> {
  _$TermsReconsentCheckResultErrorCopyWithImpl(this._self, this._then);

  final TermsReconsentCheckResultError _self;
  final $Res Function(TermsReconsentCheckResultError) _then;

  /// Create a copy of TermsReconsentCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(TermsReconsentCheckResultError(
      null == error ? _self.error : error,
    ));
  }
}

// dart format on
