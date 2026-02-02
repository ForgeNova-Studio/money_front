// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetFormState {
  String get name;
  AssetCategory get category;
  String get amount;
  String get memo;
  bool get isSaving;
  Asset? get editingAsset;

  /// Create a copy of AssetFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetFormStateCopyWith<AssetFormState> get copyWith =>
      _$AssetFormStateCopyWithImpl<AssetFormState>(
          this as AssetFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetFormState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.editingAsset, editingAsset) ||
                other.editingAsset == editingAsset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, category, amount, memo, isSaving, editingAsset);

  @override
  String toString() {
    return 'AssetFormState(name: $name, category: $category, amount: $amount, memo: $memo, isSaving: $isSaving, editingAsset: $editingAsset)';
  }
}

/// @nodoc
abstract mixin class $AssetFormStateCopyWith<$Res> {
  factory $AssetFormStateCopyWith(
          AssetFormState value, $Res Function(AssetFormState) _then) =
      _$AssetFormStateCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      AssetCategory category,
      String amount,
      String memo,
      bool isSaving,
      Asset? editingAsset});
}

/// @nodoc
class _$AssetFormStateCopyWithImpl<$Res>
    implements $AssetFormStateCopyWith<$Res> {
  _$AssetFormStateCopyWithImpl(this._self, this._then);

  final AssetFormState _self;
  final $Res Function(AssetFormState) _then;

  /// Create a copy of AssetFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? amount = null,
    Object? memo = null,
    Object? isSaving = null,
    Object? editingAsset = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as AssetCategory,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      editingAsset: freezed == editingAsset
          ? _self.editingAsset
          : editingAsset // ignore: cast_nullable_to_non_nullable
              as Asset?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetFormState].
extension AssetFormStatePatterns on AssetFormState {
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
    TResult Function(_AssetFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetFormState() when $default != null:
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
    TResult Function(_AssetFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetFormState():
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
    TResult? Function(_AssetFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetFormState() when $default != null:
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
    TResult Function(String name, AssetCategory category, String amount,
            String memo, bool isSaving, Asset? editingAsset)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetFormState() when $default != null:
        return $default(_that.name, _that.category, _that.amount, _that.memo,
            _that.isSaving, _that.editingAsset);
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
    TResult Function(String name, AssetCategory category, String amount,
            String memo, bool isSaving, Asset? editingAsset)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetFormState():
        return $default(_that.name, _that.category, _that.amount, _that.memo,
            _that.isSaving, _that.editingAsset);
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
    TResult? Function(String name, AssetCategory category, String amount,
            String memo, bool isSaving, Asset? editingAsset)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetFormState() when $default != null:
        return $default(_that.name, _that.category, _that.amount, _that.memo,
            _that.isSaving, _that.editingAsset);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AssetFormState extends AssetFormState {
  const _AssetFormState(
      {this.name = '',
      this.category = AssetCategory.cash,
      this.amount = '',
      this.memo = '',
      this.isSaving = false,
      this.editingAsset})
      : super._();

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final AssetCategory category;
  @override
  @JsonKey()
  final String amount;
  @override
  @JsonKey()
  final String memo;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final Asset? editingAsset;

  /// Create a copy of AssetFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetFormStateCopyWith<_AssetFormState> get copyWith =>
      __$AssetFormStateCopyWithImpl<_AssetFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetFormState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.editingAsset, editingAsset) ||
                other.editingAsset == editingAsset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, category, amount, memo, isSaving, editingAsset);

  @override
  String toString() {
    return 'AssetFormState(name: $name, category: $category, amount: $amount, memo: $memo, isSaving: $isSaving, editingAsset: $editingAsset)';
  }
}

/// @nodoc
abstract mixin class _$AssetFormStateCopyWith<$Res>
    implements $AssetFormStateCopyWith<$Res> {
  factory _$AssetFormStateCopyWith(
          _AssetFormState value, $Res Function(_AssetFormState) _then) =
      __$AssetFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      AssetCategory category,
      String amount,
      String memo,
      bool isSaving,
      Asset? editingAsset});
}

/// @nodoc
class __$AssetFormStateCopyWithImpl<$Res>
    implements _$AssetFormStateCopyWith<$Res> {
  __$AssetFormStateCopyWithImpl(this._self, this._then);

  final _AssetFormState _self;
  final $Res Function(_AssetFormState) _then;

  /// Create a copy of AssetFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? amount = null,
    Object? memo = null,
    Object? isSaving = null,
    Object? editingAsset = freezed,
  }) {
    return _then(_AssetFormState(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as AssetCategory,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      editingAsset: freezed == editingAsset
          ? _self.editingAsset
          : editingAsset // ignore: cast_nullable_to_non_nullable
              as Asset?,
    ));
  }
}

// dart format on
