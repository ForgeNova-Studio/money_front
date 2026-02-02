// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_statistics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryBreakdownModel {
  String get category;
  num get amount; // BigDecimal 호환
  num get percentage;

  /// Create a copy of CategoryBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryBreakdownModelCopyWith<CategoryBreakdownModel> get copyWith =>
      _$CategoryBreakdownModelCopyWithImpl<CategoryBreakdownModel>(
          this as CategoryBreakdownModel, _$identity);

  /// Serializes this CategoryBreakdownModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryBreakdownModel &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, amount, percentage);

  @override
  String toString() {
    return 'CategoryBreakdownModel(category: $category, amount: $amount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $CategoryBreakdownModelCopyWith<$Res> {
  factory $CategoryBreakdownModelCopyWith(CategoryBreakdownModel value,
          $Res Function(CategoryBreakdownModel) _then) =
      _$CategoryBreakdownModelCopyWithImpl;
  @useResult
  $Res call({String category, num amount, num percentage});
}

/// @nodoc
class _$CategoryBreakdownModelCopyWithImpl<$Res>
    implements $CategoryBreakdownModelCopyWith<$Res> {
  _$CategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final CategoryBreakdownModel _self;
  final $Res Function(CategoryBreakdownModel) _then;

  /// Create a copy of CategoryBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
  }) {
    return _then(_self.copyWith(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryBreakdownModel].
extension CategoryBreakdownModelPatterns on CategoryBreakdownModel {
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
    TResult Function(_CategoryBreakdownModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownModel() when $default != null:
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
    TResult Function(_CategoryBreakdownModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownModel():
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
    TResult? Function(_CategoryBreakdownModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownModel() when $default != null:
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
    TResult Function(String category, num amount, num percentage)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownModel() when $default != null:
        return $default(_that.category, _that.amount, _that.percentage);
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
    TResult Function(String category, num amount, num percentage) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownModel():
        return $default(_that.category, _that.amount, _that.percentage);
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
    TResult? Function(String category, num amount, num percentage)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownModel() when $default != null:
        return $default(_that.category, _that.amount, _that.percentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryBreakdownModel extends CategoryBreakdownModel {
  const _CategoryBreakdownModel(
      {required this.category, required this.amount, required this.percentage})
      : super._();
  factory _CategoryBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownModelFromJson(json);

  @override
  final String category;
  @override
  final num amount;
// BigDecimal 호환
  @override
  final num percentage;

  /// Create a copy of CategoryBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryBreakdownModelCopyWith<_CategoryBreakdownModel> get copyWith =>
      __$CategoryBreakdownModelCopyWithImpl<_CategoryBreakdownModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryBreakdownModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryBreakdownModel &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, amount, percentage);

  @override
  String toString() {
    return 'CategoryBreakdownModel(category: $category, amount: $amount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$CategoryBreakdownModelCopyWith<$Res>
    implements $CategoryBreakdownModelCopyWith<$Res> {
  factory _$CategoryBreakdownModelCopyWith(_CategoryBreakdownModel value,
          $Res Function(_CategoryBreakdownModel) _then) =
      __$CategoryBreakdownModelCopyWithImpl;
  @override
  @useResult
  $Res call({String category, num amount, num percentage});
}

/// @nodoc
class __$CategoryBreakdownModelCopyWithImpl<$Res>
    implements _$CategoryBreakdownModelCopyWith<$Res> {
  __$CategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownModel _self;
  final $Res Function(_CategoryBreakdownModel) _then;

  /// Create a copy of CategoryBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
  }) {
    return _then(_CategoryBreakdownModel(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
mixin _$ComparisonDataModel {
  num get diff; // BigDecimal 호환
  num get diffPercentage;

  /// Create a copy of ComparisonDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ComparisonDataModelCopyWith<ComparisonDataModel> get copyWith =>
      _$ComparisonDataModelCopyWithImpl<ComparisonDataModel>(
          this as ComparisonDataModel, _$identity);

  /// Serializes this ComparisonDataModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ComparisonDataModel &&
            (identical(other.diff, diff) || other.diff == diff) &&
            (identical(other.diffPercentage, diffPercentage) ||
                other.diffPercentage == diffPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, diff, diffPercentage);

  @override
  String toString() {
    return 'ComparisonDataModel(diff: $diff, diffPercentage: $diffPercentage)';
  }
}

/// @nodoc
abstract mixin class $ComparisonDataModelCopyWith<$Res> {
  factory $ComparisonDataModelCopyWith(
          ComparisonDataModel value, $Res Function(ComparisonDataModel) _then) =
      _$ComparisonDataModelCopyWithImpl;
  @useResult
  $Res call({num diff, num diffPercentage});
}

/// @nodoc
class _$ComparisonDataModelCopyWithImpl<$Res>
    implements $ComparisonDataModelCopyWith<$Res> {
  _$ComparisonDataModelCopyWithImpl(this._self, this._then);

  final ComparisonDataModel _self;
  final $Res Function(ComparisonDataModel) _then;

  /// Create a copy of ComparisonDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diff = null,
    Object? diffPercentage = null,
  }) {
    return _then(_self.copyWith(
      diff: null == diff
          ? _self.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as num,
      diffPercentage: null == diffPercentage
          ? _self.diffPercentage
          : diffPercentage // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// Adds pattern-matching-related methods to [ComparisonDataModel].
extension ComparisonDataModelPatterns on ComparisonDataModel {
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
    TResult Function(_ComparisonDataModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComparisonDataModel() when $default != null:
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
    TResult Function(_ComparisonDataModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComparisonDataModel():
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
    TResult? Function(_ComparisonDataModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComparisonDataModel() when $default != null:
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
    TResult Function(num diff, num diffPercentage)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComparisonDataModel() when $default != null:
        return $default(_that.diff, _that.diffPercentage);
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
    TResult Function(num diff, num diffPercentage) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComparisonDataModel():
        return $default(_that.diff, _that.diffPercentage);
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
    TResult? Function(num diff, num diffPercentage)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComparisonDataModel() when $default != null:
        return $default(_that.diff, _that.diffPercentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ComparisonDataModel extends ComparisonDataModel {
  const _ComparisonDataModel({required this.diff, required this.diffPercentage})
      : super._();
  factory _ComparisonDataModel.fromJson(Map<String, dynamic> json) =>
      _$ComparisonDataModelFromJson(json);

  @override
  final num diff;
// BigDecimal 호환
  @override
  final num diffPercentage;

  /// Create a copy of ComparisonDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ComparisonDataModelCopyWith<_ComparisonDataModel> get copyWith =>
      __$ComparisonDataModelCopyWithImpl<_ComparisonDataModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ComparisonDataModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ComparisonDataModel &&
            (identical(other.diff, diff) || other.diff == diff) &&
            (identical(other.diffPercentage, diffPercentage) ||
                other.diffPercentage == diffPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, diff, diffPercentage);

  @override
  String toString() {
    return 'ComparisonDataModel(diff: $diff, diffPercentage: $diffPercentage)';
  }
}

/// @nodoc
abstract mixin class _$ComparisonDataModelCopyWith<$Res>
    implements $ComparisonDataModelCopyWith<$Res> {
  factory _$ComparisonDataModelCopyWith(_ComparisonDataModel value,
          $Res Function(_ComparisonDataModel) _then) =
      __$ComparisonDataModelCopyWithImpl;
  @override
  @useResult
  $Res call({num diff, num diffPercentage});
}

/// @nodoc
class __$ComparisonDataModelCopyWithImpl<$Res>
    implements _$ComparisonDataModelCopyWith<$Res> {
  __$ComparisonDataModelCopyWithImpl(this._self, this._then);

  final _ComparisonDataModel _self;
  final $Res Function(_ComparisonDataModel) _then;

  /// Create a copy of ComparisonDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? diff = null,
    Object? diffPercentage = null,
  }) {
    return _then(_ComparisonDataModel(
      diff: null == diff
          ? _self.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as num,
      diffPercentage: null == diffPercentage
          ? _self.diffPercentage
          : diffPercentage // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
mixin _$MonthlyStatisticsModel {
  String get accountBookId;
  String get accountBookName;
  num get totalAmount; // BigDecimal 호환
  List<CategoryBreakdownModel> get categoryBreakdown;
  ComparisonDataModel get comparisonWithLastMonth;

  /// Create a copy of MonthlyStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyStatisticsModelCopyWith<MonthlyStatisticsModel> get copyWith =>
      _$MonthlyStatisticsModelCopyWithImpl<MonthlyStatisticsModel>(
          this as MonthlyStatisticsModel, _$identity);

  /// Serializes this MonthlyStatisticsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyStatisticsModel &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.accountBookName, accountBookName) ||
                other.accountBookName == accountBookName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other.categoryBreakdown, categoryBreakdown) &&
            (identical(
                    other.comparisonWithLastMonth, comparisonWithLastMonth) ||
                other.comparisonWithLastMonth == comparisonWithLastMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      accountBookName,
      totalAmount,
      const DeepCollectionEquality().hash(categoryBreakdown),
      comparisonWithLastMonth);

  @override
  String toString() {
    return 'MonthlyStatisticsModel(accountBookId: $accountBookId, accountBookName: $accountBookName, totalAmount: $totalAmount, categoryBreakdown: $categoryBreakdown, comparisonWithLastMonth: $comparisonWithLastMonth)';
  }
}

/// @nodoc
abstract mixin class $MonthlyStatisticsModelCopyWith<$Res> {
  factory $MonthlyStatisticsModelCopyWith(MonthlyStatisticsModel value,
          $Res Function(MonthlyStatisticsModel) _then) =
      _$MonthlyStatisticsModelCopyWithImpl;
  @useResult
  $Res call(
      {String accountBookId,
      String accountBookName,
      num totalAmount,
      List<CategoryBreakdownModel> categoryBreakdown,
      ComparisonDataModel comparisonWithLastMonth});

  $ComparisonDataModelCopyWith<$Res> get comparisonWithLastMonth;
}

/// @nodoc
class _$MonthlyStatisticsModelCopyWithImpl<$Res>
    implements $MonthlyStatisticsModelCopyWith<$Res> {
  _$MonthlyStatisticsModelCopyWithImpl(this._self, this._then);

  final MonthlyStatisticsModel _self;
  final $Res Function(MonthlyStatisticsModel) _then;

  /// Create a copy of MonthlyStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountBookId = null,
    Object? accountBookName = null,
    Object? totalAmount = null,
    Object? categoryBreakdown = null,
    Object? comparisonWithLastMonth = null,
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
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as num,
      categoryBreakdown: null == categoryBreakdown
          ? _self.categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdownModel>,
      comparisonWithLastMonth: null == comparisonWithLastMonth
          ? _self.comparisonWithLastMonth
          : comparisonWithLastMonth // ignore: cast_nullable_to_non_nullable
              as ComparisonDataModel,
    ));
  }

  /// Create a copy of MonthlyStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComparisonDataModelCopyWith<$Res> get comparisonWithLastMonth {
    return $ComparisonDataModelCopyWith<$Res>(_self.comparisonWithLastMonth,
        (value) {
      return _then(_self.copyWith(comparisonWithLastMonth: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MonthlyStatisticsModel].
extension MonthlyStatisticsModelPatterns on MonthlyStatisticsModel {
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
    TResult Function(_MonthlyStatisticsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyStatisticsModel() when $default != null:
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
    TResult Function(_MonthlyStatisticsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyStatisticsModel():
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
    TResult? Function(_MonthlyStatisticsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyStatisticsModel() when $default != null:
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
            num totalAmount,
            List<CategoryBreakdownModel> categoryBreakdown,
            ComparisonDataModel comparisonWithLastMonth)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyStatisticsModel() when $default != null:
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.totalAmount,
            _that.categoryBreakdown,
            _that.comparisonWithLastMonth);
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
            num totalAmount,
            List<CategoryBreakdownModel> categoryBreakdown,
            ComparisonDataModel comparisonWithLastMonth)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyStatisticsModel():
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.totalAmount,
            _that.categoryBreakdown,
            _that.comparisonWithLastMonth);
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
            num totalAmount,
            List<CategoryBreakdownModel> categoryBreakdown,
            ComparisonDataModel comparisonWithLastMonth)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyStatisticsModel() when $default != null:
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.totalAmount,
            _that.categoryBreakdown,
            _that.comparisonWithLastMonth);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MonthlyStatisticsModel extends MonthlyStatisticsModel {
  const _MonthlyStatisticsModel(
      {required this.accountBookId,
      required this.accountBookName,
      required this.totalAmount,
      required final List<CategoryBreakdownModel> categoryBreakdown,
      required this.comparisonWithLastMonth})
      : _categoryBreakdown = categoryBreakdown,
        super._();
  factory _MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatisticsModelFromJson(json);

  @override
  final String accountBookId;
  @override
  final String accountBookName;
  @override
  final num totalAmount;
// BigDecimal 호환
  final List<CategoryBreakdownModel> _categoryBreakdown;
// BigDecimal 호환
  @override
  List<CategoryBreakdownModel> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  @override
  final ComparisonDataModel comparisonWithLastMonth;

  /// Create a copy of MonthlyStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyStatisticsModelCopyWith<_MonthlyStatisticsModel> get copyWith =>
      __$MonthlyStatisticsModelCopyWithImpl<_MonthlyStatisticsModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MonthlyStatisticsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyStatisticsModel &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.accountBookName, accountBookName) ||
                other.accountBookName == accountBookName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdown, _categoryBreakdown) &&
            (identical(
                    other.comparisonWithLastMonth, comparisonWithLastMonth) ||
                other.comparisonWithLastMonth == comparisonWithLastMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      accountBookName,
      totalAmount,
      const DeepCollectionEquality().hash(_categoryBreakdown),
      comparisonWithLastMonth);

  @override
  String toString() {
    return 'MonthlyStatisticsModel(accountBookId: $accountBookId, accountBookName: $accountBookName, totalAmount: $totalAmount, categoryBreakdown: $categoryBreakdown, comparisonWithLastMonth: $comparisonWithLastMonth)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyStatisticsModelCopyWith<$Res>
    implements $MonthlyStatisticsModelCopyWith<$Res> {
  factory _$MonthlyStatisticsModelCopyWith(_MonthlyStatisticsModel value,
          $Res Function(_MonthlyStatisticsModel) _then) =
      __$MonthlyStatisticsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accountBookId,
      String accountBookName,
      num totalAmount,
      List<CategoryBreakdownModel> categoryBreakdown,
      ComparisonDataModel comparisonWithLastMonth});

  @override
  $ComparisonDataModelCopyWith<$Res> get comparisonWithLastMonth;
}

/// @nodoc
class __$MonthlyStatisticsModelCopyWithImpl<$Res>
    implements _$MonthlyStatisticsModelCopyWith<$Res> {
  __$MonthlyStatisticsModelCopyWithImpl(this._self, this._then);

  final _MonthlyStatisticsModel _self;
  final $Res Function(_MonthlyStatisticsModel) _then;

  /// Create a copy of MonthlyStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountBookId = null,
    Object? accountBookName = null,
    Object? totalAmount = null,
    Object? categoryBreakdown = null,
    Object? comparisonWithLastMonth = null,
  }) {
    return _then(_MonthlyStatisticsModel(
      accountBookId: null == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String,
      accountBookName: null == accountBookName
          ? _self.accountBookName
          : accountBookName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as num,
      categoryBreakdown: null == categoryBreakdown
          ? _self._categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdownModel>,
      comparisonWithLastMonth: null == comparisonWithLastMonth
          ? _self.comparisonWithLastMonth
          : comparisonWithLastMonth // ignore: cast_nullable_to_non_nullable
              as ComparisonDataModel,
    ));
  }

  /// Create a copy of MonthlyStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComparisonDataModelCopyWith<$Res> get comparisonWithLastMonth {
    return $ComparisonDataModelCopyWith<$Res>(_self.comparisonWithLastMonth,
        (value) {
      return _then(_self.copyWith(comparisonWithLastMonth: value));
    });
  }
}

// dart format on
