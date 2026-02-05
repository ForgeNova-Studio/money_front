// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_monthly_comparison_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryComparisonModel {
  String get category;
  num get currentAmount; // BigDecimal 호환
  num get previousAmount; // BigDecimal 호환
  num get diff; // BigDecimal 호환
  num? get diffPercentage;

  /// Create a copy of CategoryComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryComparisonModelCopyWith<CategoryComparisonModel> get copyWith =>
      _$CategoryComparisonModelCopyWithImpl<CategoryComparisonModel>(
          this as CategoryComparisonModel, _$identity);

  /// Serializes this CategoryComparisonModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryComparisonModel &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.previousAmount, previousAmount) ||
                other.previousAmount == previousAmount) &&
            (identical(other.diff, diff) || other.diff == diff) &&
            (identical(other.diffPercentage, diffPercentage) ||
                other.diffPercentage == diffPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, currentAmount,
      previousAmount, diff, diffPercentage);

  @override
  String toString() {
    return 'CategoryComparisonModel(category: $category, currentAmount: $currentAmount, previousAmount: $previousAmount, diff: $diff, diffPercentage: $diffPercentage)';
  }
}

/// @nodoc
abstract mixin class $CategoryComparisonModelCopyWith<$Res> {
  factory $CategoryComparisonModelCopyWith(CategoryComparisonModel value,
          $Res Function(CategoryComparisonModel) _then) =
      _$CategoryComparisonModelCopyWithImpl;
  @useResult
  $Res call(
      {String category,
      num currentAmount,
      num previousAmount,
      num diff,
      num? diffPercentage});
}

/// @nodoc
class _$CategoryComparisonModelCopyWithImpl<$Res>
    implements $CategoryComparisonModelCopyWith<$Res> {
  _$CategoryComparisonModelCopyWithImpl(this._self, this._then);

  final CategoryComparisonModel _self;
  final $Res Function(CategoryComparisonModel) _then;

  /// Create a copy of CategoryComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? currentAmount = null,
    Object? previousAmount = null,
    Object? diff = null,
    Object? diffPercentage = freezed,
  }) {
    return _then(_self.copyWith(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      currentAmount: null == currentAmount
          ? _self.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as num,
      previousAmount: null == previousAmount
          ? _self.previousAmount
          : previousAmount // ignore: cast_nullable_to_non_nullable
              as num,
      diff: null == diff
          ? _self.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as num,
      diffPercentage: freezed == diffPercentage
          ? _self.diffPercentage
          : diffPercentage // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryComparisonModel].
extension CategoryComparisonModelPatterns on CategoryComparisonModel {
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
    TResult Function(_CategoryComparisonModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryComparisonModel() when $default != null:
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
    TResult Function(_CategoryComparisonModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryComparisonModel():
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
    TResult? Function(_CategoryComparisonModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryComparisonModel() when $default != null:
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
    TResult Function(String category, num currentAmount, num previousAmount,
            num diff, num? diffPercentage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryComparisonModel() when $default != null:
        return $default(_that.category, _that.currentAmount,
            _that.previousAmount, _that.diff, _that.diffPercentage);
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
    TResult Function(String category, num currentAmount, num previousAmount,
            num diff, num? diffPercentage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryComparisonModel():
        return $default(_that.category, _that.currentAmount,
            _that.previousAmount, _that.diff, _that.diffPercentage);
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
    TResult? Function(String category, num currentAmount, num previousAmount,
            num diff, num? diffPercentage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryComparisonModel() when $default != null:
        return $default(_that.category, _that.currentAmount,
            _that.previousAmount, _that.diff, _that.diffPercentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryComparisonModel extends CategoryComparisonModel {
  const _CategoryComparisonModel(
      {required this.category,
      required this.currentAmount,
      required this.previousAmount,
      required this.diff,
      this.diffPercentage})
      : super._();
  factory _CategoryComparisonModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryComparisonModelFromJson(json);

  @override
  final String category;
  @override
  final num currentAmount;
// BigDecimal 호환
  @override
  final num previousAmount;
// BigDecimal 호환
  @override
  final num diff;
// BigDecimal 호환
  @override
  final num? diffPercentage;

  /// Create a copy of CategoryComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryComparisonModelCopyWith<_CategoryComparisonModel> get copyWith =>
      __$CategoryComparisonModelCopyWithImpl<_CategoryComparisonModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryComparisonModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryComparisonModel &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.previousAmount, previousAmount) ||
                other.previousAmount == previousAmount) &&
            (identical(other.diff, diff) || other.diff == diff) &&
            (identical(other.diffPercentage, diffPercentage) ||
                other.diffPercentage == diffPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, currentAmount,
      previousAmount, diff, diffPercentage);

  @override
  String toString() {
    return 'CategoryComparisonModel(category: $category, currentAmount: $currentAmount, previousAmount: $previousAmount, diff: $diff, diffPercentage: $diffPercentage)';
  }
}

/// @nodoc
abstract mixin class _$CategoryComparisonModelCopyWith<$Res>
    implements $CategoryComparisonModelCopyWith<$Res> {
  factory _$CategoryComparisonModelCopyWith(_CategoryComparisonModel value,
          $Res Function(_CategoryComparisonModel) _then) =
      __$CategoryComparisonModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String category,
      num currentAmount,
      num previousAmount,
      num diff,
      num? diffPercentage});
}

/// @nodoc
class __$CategoryComparisonModelCopyWithImpl<$Res>
    implements _$CategoryComparisonModelCopyWith<$Res> {
  __$CategoryComparisonModelCopyWithImpl(this._self, this._then);

  final _CategoryComparisonModel _self;
  final $Res Function(_CategoryComparisonModel) _then;

  /// Create a copy of CategoryComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? currentAmount = null,
    Object? previousAmount = null,
    Object? diff = null,
    Object? diffPercentage = freezed,
  }) {
    return _then(_CategoryComparisonModel(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      currentAmount: null == currentAmount
          ? _self.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as num,
      previousAmount: null == previousAmount
          ? _self.previousAmount
          : previousAmount // ignore: cast_nullable_to_non_nullable
              as num,
      diff: null == diff
          ? _self.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as num,
      diffPercentage: freezed == diffPercentage
          ? _self.diffPercentage
          : diffPercentage // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
mixin _$CategoryMonthlyComparisonModel {
  String get accountBookId;
  String get accountBookName;
  int get year;
  int get month;
  num get currentMonthTotal; // BigDecimal 호환
  num get previousMonthTotal; // BigDecimal 호환
  List<CategoryComparisonModel> get categories;

  /// Create a copy of CategoryMonthlyComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryMonthlyComparisonModelCopyWith<CategoryMonthlyComparisonModel>
      get copyWith => _$CategoryMonthlyComparisonModelCopyWithImpl<
              CategoryMonthlyComparisonModel>(
          this as CategoryMonthlyComparisonModel, _$identity);

  /// Serializes this CategoryMonthlyComparisonModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryMonthlyComparisonModel &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.accountBookName, accountBookName) ||
                other.accountBookName == accountBookName) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.currentMonthTotal, currentMonthTotal) ||
                other.currentMonthTotal == currentMonthTotal) &&
            (identical(other.previousMonthTotal, previousMonthTotal) ||
                other.previousMonthTotal == previousMonthTotal) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      accountBookName,
      year,
      month,
      currentMonthTotal,
      previousMonthTotal,
      const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'CategoryMonthlyComparisonModel(accountBookId: $accountBookId, accountBookName: $accountBookName, year: $year, month: $month, currentMonthTotal: $currentMonthTotal, previousMonthTotal: $previousMonthTotal, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $CategoryMonthlyComparisonModelCopyWith<$Res> {
  factory $CategoryMonthlyComparisonModelCopyWith(
          CategoryMonthlyComparisonModel value,
          $Res Function(CategoryMonthlyComparisonModel) _then) =
      _$CategoryMonthlyComparisonModelCopyWithImpl;
  @useResult
  $Res call(
      {String accountBookId,
      String accountBookName,
      int year,
      int month,
      num currentMonthTotal,
      num previousMonthTotal,
      List<CategoryComparisonModel> categories});
}

/// @nodoc
class _$CategoryMonthlyComparisonModelCopyWithImpl<$Res>
    implements $CategoryMonthlyComparisonModelCopyWith<$Res> {
  _$CategoryMonthlyComparisonModelCopyWithImpl(this._self, this._then);

  final CategoryMonthlyComparisonModel _self;
  final $Res Function(CategoryMonthlyComparisonModel) _then;

  /// Create a copy of CategoryMonthlyComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountBookId = null,
    Object? accountBookName = null,
    Object? year = null,
    Object? month = null,
    Object? currentMonthTotal = null,
    Object? previousMonthTotal = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      accountBookId: null == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String,
      accountBookName: null == accountBookName
          ? _self.accountBookName
          : accountBookName // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      currentMonthTotal: null == currentMonthTotal
          ? _self.currentMonthTotal
          : currentMonthTotal // ignore: cast_nullable_to_non_nullable
              as num,
      previousMonthTotal: null == previousMonthTotal
          ? _self.previousMonthTotal
          : previousMonthTotal // ignore: cast_nullable_to_non_nullable
              as num,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryComparisonModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryMonthlyComparisonModel].
extension CategoryMonthlyComparisonModelPatterns
    on CategoryMonthlyComparisonModel {
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
    TResult Function(_CategoryMonthlyComparisonModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryMonthlyComparisonModel() when $default != null:
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
    TResult Function(_CategoryMonthlyComparisonModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryMonthlyComparisonModel():
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
    TResult? Function(_CategoryMonthlyComparisonModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryMonthlyComparisonModel() when $default != null:
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
            String accountBookId,
            String accountBookName,
            int year,
            int month,
            num currentMonthTotal,
            num previousMonthTotal,
            List<CategoryComparisonModel> categories)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryMonthlyComparisonModel() when $default != null:
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.year,
            _that.month,
            _that.currentMonthTotal,
            _that.previousMonthTotal,
            _that.categories);
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
            String accountBookId,
            String accountBookName,
            int year,
            int month,
            num currentMonthTotal,
            num previousMonthTotal,
            List<CategoryComparisonModel> categories)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryMonthlyComparisonModel():
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.year,
            _that.month,
            _that.currentMonthTotal,
            _that.previousMonthTotal,
            _that.categories);
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
            String accountBookId,
            String accountBookName,
            int year,
            int month,
            num currentMonthTotal,
            num previousMonthTotal,
            List<CategoryComparisonModel> categories)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryMonthlyComparisonModel() when $default != null:
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.year,
            _that.month,
            _that.currentMonthTotal,
            _that.previousMonthTotal,
            _that.categories);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryMonthlyComparisonModel extends CategoryMonthlyComparisonModel {
  const _CategoryMonthlyComparisonModel(
      {required this.accountBookId,
      required this.accountBookName,
      required this.year,
      required this.month,
      required this.currentMonthTotal,
      required this.previousMonthTotal,
      required final List<CategoryComparisonModel> categories})
      : _categories = categories,
        super._();
  factory _CategoryMonthlyComparisonModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryMonthlyComparisonModelFromJson(json);

  @override
  final String accountBookId;
  @override
  final String accountBookName;
  @override
  final int year;
  @override
  final int month;
  @override
  final num currentMonthTotal;
// BigDecimal 호환
  @override
  final num previousMonthTotal;
// BigDecimal 호환
  final List<CategoryComparisonModel> _categories;
// BigDecimal 호환
  @override
  List<CategoryComparisonModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of CategoryMonthlyComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryMonthlyComparisonModelCopyWith<_CategoryMonthlyComparisonModel>
      get copyWith => __$CategoryMonthlyComparisonModelCopyWithImpl<
          _CategoryMonthlyComparisonModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryMonthlyComparisonModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryMonthlyComparisonModel &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.accountBookName, accountBookName) ||
                other.accountBookName == accountBookName) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.currentMonthTotal, currentMonthTotal) ||
                other.currentMonthTotal == currentMonthTotal) &&
            (identical(other.previousMonthTotal, previousMonthTotal) ||
                other.previousMonthTotal == previousMonthTotal) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      accountBookName,
      year,
      month,
      currentMonthTotal,
      previousMonthTotal,
      const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'CategoryMonthlyComparisonModel(accountBookId: $accountBookId, accountBookName: $accountBookName, year: $year, month: $month, currentMonthTotal: $currentMonthTotal, previousMonthTotal: $previousMonthTotal, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$CategoryMonthlyComparisonModelCopyWith<$Res>
    implements $CategoryMonthlyComparisonModelCopyWith<$Res> {
  factory _$CategoryMonthlyComparisonModelCopyWith(
          _CategoryMonthlyComparisonModel value,
          $Res Function(_CategoryMonthlyComparisonModel) _then) =
      __$CategoryMonthlyComparisonModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accountBookId,
      String accountBookName,
      int year,
      int month,
      num currentMonthTotal,
      num previousMonthTotal,
      List<CategoryComparisonModel> categories});
}

/// @nodoc
class __$CategoryMonthlyComparisonModelCopyWithImpl<$Res>
    implements _$CategoryMonthlyComparisonModelCopyWith<$Res> {
  __$CategoryMonthlyComparisonModelCopyWithImpl(this._self, this._then);

  final _CategoryMonthlyComparisonModel _self;
  final $Res Function(_CategoryMonthlyComparisonModel) _then;

  /// Create a copy of CategoryMonthlyComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountBookId = null,
    Object? accountBookName = null,
    Object? year = null,
    Object? month = null,
    Object? currentMonthTotal = null,
    Object? previousMonthTotal = null,
    Object? categories = null,
  }) {
    return _then(_CategoryMonthlyComparisonModel(
      accountBookId: null == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String,
      accountBookName: null == accountBookName
          ? _self.accountBookName
          : accountBookName // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      currentMonthTotal: null == currentMonthTotal
          ? _self.currentMonthTotal
          : currentMonthTotal // ignore: cast_nullable_to_non_nullable
              as num,
      previousMonthTotal: null == previousMonthTotal
          ? _self.previousMonthTotal
          : previousMonthTotal // ignore: cast_nullable_to_non_nullable
              as num,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryComparisonModel>,
    ));
  }
}

// dart format on
