// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetSummary {
  /// 총 자산 금액
  int get totalAmount;

  /// 전월 대비 변화 금액
  int get previousMonthDiff;

  /// 카테고리별 요약
  List<CategoryBreakdown> get categoryBreakdowns;

  /// Create a copy of AssetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetSummaryCopyWith<AssetSummary> get copyWith =>
      _$AssetSummaryCopyWithImpl<AssetSummary>(
          this as AssetSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetSummary &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.previousMonthDiff, previousMonthDiff) ||
                other.previousMonthDiff == previousMonthDiff) &&
            const DeepCollectionEquality()
                .equals(other.categoryBreakdowns, categoryBreakdowns));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalAmount, previousMonthDiff,
      const DeepCollectionEquality().hash(categoryBreakdowns));

  @override
  String toString() {
    return 'AssetSummary(totalAmount: $totalAmount, previousMonthDiff: $previousMonthDiff, categoryBreakdowns: $categoryBreakdowns)';
  }
}

/// @nodoc
abstract mixin class $AssetSummaryCopyWith<$Res> {
  factory $AssetSummaryCopyWith(
          AssetSummary value, $Res Function(AssetSummary) _then) =
      _$AssetSummaryCopyWithImpl;
  @useResult
  $Res call(
      {int totalAmount,
      int previousMonthDiff,
      List<CategoryBreakdown> categoryBreakdowns});
}

/// @nodoc
class _$AssetSummaryCopyWithImpl<$Res> implements $AssetSummaryCopyWith<$Res> {
  _$AssetSummaryCopyWithImpl(this._self, this._then);

  final AssetSummary _self;
  final $Res Function(AssetSummary) _then;

  /// Create a copy of AssetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? previousMonthDiff = null,
    Object? categoryBreakdowns = null,
  }) {
    return _then(_self.copyWith(
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      previousMonthDiff: null == previousMonthDiff
          ? _self.previousMonthDiff
          : previousMonthDiff // ignore: cast_nullable_to_non_nullable
              as int,
      categoryBreakdowns: null == categoryBreakdowns
          ? _self.categoryBreakdowns
          : categoryBreakdowns // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetSummary].
extension AssetSummaryPatterns on AssetSummary {
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
    TResult Function(_AssetSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetSummary() when $default != null:
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
    TResult Function(_AssetSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSummary():
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
    TResult? Function(_AssetSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSummary() when $default != null:
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
    TResult Function(int totalAmount, int previousMonthDiff,
            List<CategoryBreakdown> categoryBreakdowns)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetSummary() when $default != null:
        return $default(_that.totalAmount, _that.previousMonthDiff,
            _that.categoryBreakdowns);
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
    TResult Function(int totalAmount, int previousMonthDiff,
            List<CategoryBreakdown> categoryBreakdowns)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSummary():
        return $default(_that.totalAmount, _that.previousMonthDiff,
            _that.categoryBreakdowns);
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
    TResult? Function(int totalAmount, int previousMonthDiff,
            List<CategoryBreakdown> categoryBreakdowns)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetSummary() when $default != null:
        return $default(_that.totalAmount, _that.previousMonthDiff,
            _that.categoryBreakdowns);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AssetSummary extends AssetSummary {
  const _AssetSummary(
      {required this.totalAmount,
      this.previousMonthDiff = 0,
      final List<CategoryBreakdown> categoryBreakdowns = const []})
      : _categoryBreakdowns = categoryBreakdowns,
        super._();

  /// 총 자산 금액
  @override
  final int totalAmount;

  /// 전월 대비 변화 금액
  @override
  @JsonKey()
  final int previousMonthDiff;

  /// 카테고리별 요약
  final List<CategoryBreakdown> _categoryBreakdowns;

  /// 카테고리별 요약
  @override
  @JsonKey()
  List<CategoryBreakdown> get categoryBreakdowns {
    if (_categoryBreakdowns is EqualUnmodifiableListView)
      return _categoryBreakdowns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdowns);
  }

  /// Create a copy of AssetSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetSummaryCopyWith<_AssetSummary> get copyWith =>
      __$AssetSummaryCopyWithImpl<_AssetSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetSummary &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.previousMonthDiff, previousMonthDiff) ||
                other.previousMonthDiff == previousMonthDiff) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdowns, _categoryBreakdowns));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalAmount, previousMonthDiff,
      const DeepCollectionEquality().hash(_categoryBreakdowns));

  @override
  String toString() {
    return 'AssetSummary(totalAmount: $totalAmount, previousMonthDiff: $previousMonthDiff, categoryBreakdowns: $categoryBreakdowns)';
  }
}

/// @nodoc
abstract mixin class _$AssetSummaryCopyWith<$Res>
    implements $AssetSummaryCopyWith<$Res> {
  factory _$AssetSummaryCopyWith(
          _AssetSummary value, $Res Function(_AssetSummary) _then) =
      __$AssetSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalAmount,
      int previousMonthDiff,
      List<CategoryBreakdown> categoryBreakdowns});
}

/// @nodoc
class __$AssetSummaryCopyWithImpl<$Res>
    implements _$AssetSummaryCopyWith<$Res> {
  __$AssetSummaryCopyWithImpl(this._self, this._then);

  final _AssetSummary _self;
  final $Res Function(_AssetSummary) _then;

  /// Create a copy of AssetSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalAmount = null,
    Object? previousMonthDiff = null,
    Object? categoryBreakdowns = null,
  }) {
    return _then(_AssetSummary(
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      previousMonthDiff: null == previousMonthDiff
          ? _self.previousMonthDiff
          : previousMonthDiff // ignore: cast_nullable_to_non_nullable
              as int,
      categoryBreakdowns: null == categoryBreakdowns
          ? _self._categoryBreakdowns
          : categoryBreakdowns // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
    ));
  }
}

/// @nodoc
mixin _$CategoryBreakdown {
  /// 카테고리
  AssetCategory get category;

  /// 금액
  int get amount;

  /// 전체 대비 비율 (%)
  double get percent;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith =>
      _$CategoryBreakdownCopyWithImpl<CategoryBreakdown>(
          this as CategoryBreakdown, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryBreakdown &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, amount, percent);

  @override
  String toString() {
    return 'CategoryBreakdown(category: $category, amount: $amount, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class $CategoryBreakdownCopyWith<$Res> {
  factory $CategoryBreakdownCopyWith(
          CategoryBreakdown value, $Res Function(CategoryBreakdown) _then) =
      _$CategoryBreakdownCopyWithImpl;
  @useResult
  $Res call({AssetCategory category, int amount, double percent});
}

/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._self, this._then);

  final CategoryBreakdown _self;
  final $Res Function(CategoryBreakdown) _then;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percent = null,
  }) {
    return _then(_self.copyWith(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as AssetCategory,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryBreakdown].
extension CategoryBreakdownPatterns on CategoryBreakdown {
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
    TResult Function(_CategoryBreakdown value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdown() when $default != null:
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
    TResult Function(_CategoryBreakdown value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdown():
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
    TResult? Function(_CategoryBreakdown value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdown() when $default != null:
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
    TResult Function(AssetCategory category, int amount, double percent)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdown() when $default != null:
        return $default(_that.category, _that.amount, _that.percent);
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
    TResult Function(AssetCategory category, int amount, double percent)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdown():
        return $default(_that.category, _that.amount, _that.percent);
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
    TResult? Function(AssetCategory category, int amount, double percent)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdown() when $default != null:
        return $default(_that.category, _that.amount, _that.percent);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CategoryBreakdown extends CategoryBreakdown {
  const _CategoryBreakdown(
      {required this.category, required this.amount, required this.percent})
      : super._();

  /// 카테고리
  @override
  final AssetCategory category;

  /// 금액
  @override
  final int amount;

  /// 전체 대비 비율 (%)
  @override
  final double percent;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryBreakdownCopyWith<_CategoryBreakdown> get copyWith =>
      __$CategoryBreakdownCopyWithImpl<_CategoryBreakdown>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryBreakdown &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percent, percent) || other.percent == percent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, amount, percent);

  @override
  String toString() {
    return 'CategoryBreakdown(category: $category, amount: $amount, percent: $percent)';
  }
}

/// @nodoc
abstract mixin class _$CategoryBreakdownCopyWith<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  factory _$CategoryBreakdownCopyWith(
          _CategoryBreakdown value, $Res Function(_CategoryBreakdown) _then) =
      __$CategoryBreakdownCopyWithImpl;
  @override
  @useResult
  $Res call({AssetCategory category, int amount, double percent});
}

/// @nodoc
class __$CategoryBreakdownCopyWithImpl<$Res>
    implements _$CategoryBreakdownCopyWith<$Res> {
  __$CategoryBreakdownCopyWithImpl(this._self, this._then);

  final _CategoryBreakdown _self;
  final $Res Function(_CategoryBreakdown) _then;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percent = null,
  }) {
    return _then(_CategoryBreakdown(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as AssetCategory,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      percent: null == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
