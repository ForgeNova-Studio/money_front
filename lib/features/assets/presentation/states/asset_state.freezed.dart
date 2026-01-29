// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetState {
  /// 자산 요약 정보
  AssetSummary? get summary;

  /// 자산 목록
  List<Asset> get assets;

  /// 로딩 중 여부
  bool get isLoading;

  /// 에러 메시지
  String? get error;

  /// Create a copy of AssetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetStateCopyWith<AssetState> get copyWith =>
      _$AssetStateCopyWithImpl<AssetState>(this as AssetState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetState &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other.assets, assets) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, summary,
      const DeepCollectionEquality().hash(assets), isLoading, error);

  @override
  String toString() {
    return 'AssetState(summary: $summary, assets: $assets, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $AssetStateCopyWith<$Res> {
  factory $AssetStateCopyWith(
          AssetState value, $Res Function(AssetState) _then) =
      _$AssetStateCopyWithImpl;
  @useResult
  $Res call(
      {AssetSummary? summary,
      List<Asset> assets,
      bool isLoading,
      String? error});

  $AssetSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class _$AssetStateCopyWithImpl<$Res> implements $AssetStateCopyWith<$Res> {
  _$AssetStateCopyWithImpl(this._self, this._then);

  final AssetState _self;
  final $Res Function(AssetState) _then;

  /// Create a copy of AssetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = freezed,
    Object? assets = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as AssetSummary?,
      assets: null == assets
          ? _self.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<Asset>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AssetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
      return null;
    }

    return $AssetSummaryCopyWith<$Res>(_self.summary!, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AssetState].
extension AssetStatePatterns on AssetState {
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
    TResult Function(_AssetState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetState() when $default != null:
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
    TResult Function(_AssetState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetState():
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
    TResult? Function(_AssetState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetState() when $default != null:
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
    TResult Function(AssetSummary? summary, List<Asset> assets, bool isLoading,
            String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetState() when $default != null:
        return $default(
            _that.summary, _that.assets, _that.isLoading, _that.error);
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
    TResult Function(AssetSummary? summary, List<Asset> assets, bool isLoading,
            String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetState():
        return $default(
            _that.summary, _that.assets, _that.isLoading, _that.error);
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
    TResult? Function(AssetSummary? summary, List<Asset> assets, bool isLoading,
            String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetState() when $default != null:
        return $default(
            _that.summary, _that.assets, _that.isLoading, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AssetState extends AssetState {
  const _AssetState(
      {this.summary,
      final List<Asset> assets = const [],
      this.isLoading = false,
      this.error})
      : _assets = assets,
        super._();

  /// 자산 요약 정보
  @override
  final AssetSummary? summary;

  /// 자산 목록
  final List<Asset> _assets;

  /// 자산 목록
  @override
  @JsonKey()
  List<Asset> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  /// 로딩 중 여부
  @override
  @JsonKey()
  final bool isLoading;

  /// 에러 메시지
  @override
  final String? error;

  /// Create a copy of AssetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetStateCopyWith<_AssetState> get copyWith =>
      __$AssetStateCopyWithImpl<_AssetState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetState &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, summary,
      const DeepCollectionEquality().hash(_assets), isLoading, error);

  @override
  String toString() {
    return 'AssetState(summary: $summary, assets: $assets, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$AssetStateCopyWith<$Res>
    implements $AssetStateCopyWith<$Res> {
  factory _$AssetStateCopyWith(
          _AssetState value, $Res Function(_AssetState) _then) =
      __$AssetStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AssetSummary? summary,
      List<Asset> assets,
      bool isLoading,
      String? error});

  @override
  $AssetSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class __$AssetStateCopyWithImpl<$Res> implements _$AssetStateCopyWith<$Res> {
  __$AssetStateCopyWithImpl(this._self, this._then);

  final _AssetState _self;
  final $Res Function(_AssetState) _then;

  /// Create a copy of AssetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? summary = freezed,
    Object? assets = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_AssetState(
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as AssetSummary?,
      assets: null == assets
          ? _self._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<Asset>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AssetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssetSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
      return null;
    }

    return $AssetSummaryCopyWith<$Res>(_self.summary!, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

// dart format on
