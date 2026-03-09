// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_scan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OcrScanState {
  /// 대기 중인 영수증 목록
  List<PendingReceipt> get pendingReceipts;

  /// 이미지 처리 중 여부
  bool get isProcessing;

  /// 저장 중 여부
  bool get isSaving;

  /// 에러 메시지
  String? get error;

  /// 선택된 이미지 경로
  String? get selectedImagePath;

  /// Create a copy of OcrScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OcrScanStateCopyWith<OcrScanState> get copyWith =>
      _$OcrScanStateCopyWithImpl<OcrScanState>(
          this as OcrScanState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OcrScanState &&
            const DeepCollectionEquality()
                .equals(other.pendingReceipts, pendingReceipts) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedImagePath, selectedImagePath) ||
                other.selectedImagePath == selectedImagePath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(pendingReceipts),
      isProcessing,
      isSaving,
      error,
      selectedImagePath);

  @override
  String toString() {
    return 'OcrScanState(pendingReceipts: $pendingReceipts, isProcessing: $isProcessing, isSaving: $isSaving, error: $error, selectedImagePath: $selectedImagePath)';
  }
}

/// @nodoc
abstract mixin class $OcrScanStateCopyWith<$Res> {
  factory $OcrScanStateCopyWith(
          OcrScanState value, $Res Function(OcrScanState) _then) =
      _$OcrScanStateCopyWithImpl;
  @useResult
  $Res call(
      {List<PendingReceipt> pendingReceipts,
      bool isProcessing,
      bool isSaving,
      String? error,
      String? selectedImagePath});
}

/// @nodoc
class _$OcrScanStateCopyWithImpl<$Res> implements $OcrScanStateCopyWith<$Res> {
  _$OcrScanStateCopyWithImpl(this._self, this._then);

  final OcrScanState _self;
  final $Res Function(OcrScanState) _then;

  /// Create a copy of OcrScanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingReceipts = null,
    Object? isProcessing = null,
    Object? isSaving = null,
    Object? error = freezed,
    Object? selectedImagePath = freezed,
  }) {
    return _then(_self.copyWith(
      pendingReceipts: null == pendingReceipts
          ? _self.pendingReceipts
          : pendingReceipts // ignore: cast_nullable_to_non_nullable
              as List<PendingReceipt>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedImagePath: freezed == selectedImagePath
          ? _self.selectedImagePath
          : selectedImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OcrScanState].
extension OcrScanStatePatterns on OcrScanState {
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
    TResult Function(_OcrScanState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OcrScanState() when $default != null:
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
    TResult Function(_OcrScanState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrScanState():
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
    TResult? Function(_OcrScanState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrScanState() when $default != null:
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
    TResult Function(List<PendingReceipt> pendingReceipts, bool isProcessing,
            bool isSaving, String? error, String? selectedImagePath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OcrScanState() when $default != null:
        return $default(_that.pendingReceipts, _that.isProcessing,
            _that.isSaving, _that.error, _that.selectedImagePath);
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
    TResult Function(List<PendingReceipt> pendingReceipts, bool isProcessing,
            bool isSaving, String? error, String? selectedImagePath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrScanState():
        return $default(_that.pendingReceipts, _that.isProcessing,
            _that.isSaving, _that.error, _that.selectedImagePath);
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
    TResult? Function(List<PendingReceipt> pendingReceipts, bool isProcessing,
            bool isSaving, String? error, String? selectedImagePath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrScanState() when $default != null:
        return $default(_that.pendingReceipts, _that.isProcessing,
            _that.isSaving, _that.error, _that.selectedImagePath);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OcrScanState extends OcrScanState {
  const _OcrScanState(
      {final List<PendingReceipt> pendingReceipts = const [],
      this.isProcessing = false,
      this.isSaving = false,
      this.error,
      this.selectedImagePath})
      : _pendingReceipts = pendingReceipts,
        super._();

  /// 대기 중인 영수증 목록
  final List<PendingReceipt> _pendingReceipts;

  /// 대기 중인 영수증 목록
  @override
  @JsonKey()
  List<PendingReceipt> get pendingReceipts {
    if (_pendingReceipts is EqualUnmodifiableListView) return _pendingReceipts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingReceipts);
  }

  /// 이미지 처리 중 여부
  @override
  @JsonKey()
  final bool isProcessing;

  /// 저장 중 여부
  @override
  @JsonKey()
  final bool isSaving;

  /// 에러 메시지
  @override
  final String? error;

  /// 선택된 이미지 경로
  @override
  final String? selectedImagePath;

  /// Create a copy of OcrScanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OcrScanStateCopyWith<_OcrScanState> get copyWith =>
      __$OcrScanStateCopyWithImpl<_OcrScanState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OcrScanState &&
            const DeepCollectionEquality()
                .equals(other._pendingReceipts, _pendingReceipts) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedImagePath, selectedImagePath) ||
                other.selectedImagePath == selectedImagePath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pendingReceipts),
      isProcessing,
      isSaving,
      error,
      selectedImagePath);

  @override
  String toString() {
    return 'OcrScanState(pendingReceipts: $pendingReceipts, isProcessing: $isProcessing, isSaving: $isSaving, error: $error, selectedImagePath: $selectedImagePath)';
  }
}

/// @nodoc
abstract mixin class _$OcrScanStateCopyWith<$Res>
    implements $OcrScanStateCopyWith<$Res> {
  factory _$OcrScanStateCopyWith(
          _OcrScanState value, $Res Function(_OcrScanState) _then) =
      __$OcrScanStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<PendingReceipt> pendingReceipts,
      bool isProcessing,
      bool isSaving,
      String? error,
      String? selectedImagePath});
}

/// @nodoc
class __$OcrScanStateCopyWithImpl<$Res>
    implements _$OcrScanStateCopyWith<$Res> {
  __$OcrScanStateCopyWithImpl(this._self, this._then);

  final _OcrScanState _self;
  final $Res Function(_OcrScanState) _then;

  /// Create a copy of OcrScanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pendingReceipts = null,
    Object? isProcessing = null,
    Object? isSaving = null,
    Object? error = freezed,
    Object? selectedImagePath = freezed,
  }) {
    return _then(_OcrScanState(
      pendingReceipts: null == pendingReceipts
          ? _self._pendingReceipts
          : pendingReceipts // ignore: cast_nullable_to_non_nullable
              as List<PendingReceipt>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedImagePath: freezed == selectedImagePath
          ? _self.selectedImagePath
          : selectedImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
