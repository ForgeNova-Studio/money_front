// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyReportEntity {
  int get year;
  int get month;
  int get totalExpense;
  int get totalIncome;
  int get netIncome;
  int? get previousMonthExpense;
  double? get changePercent;
  List<CategoryBreakdownEntity> get categoryBreakdown;
  List<TopExpenseEntity> get topExpenses;
  TopMerchantEntity? get topMerchant;
  BudgetSummaryEntity? get budget;

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyReportEntityCopyWith<MonthlyReportEntity> get copyWith =>
      _$MonthlyReportEntityCopyWithImpl<MonthlyReportEntity>(
          this as MonthlyReportEntity, _$identity);

  /// Serializes this MonthlyReportEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyReportEntity &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome) &&
            (identical(other.previousMonthExpense, previousMonthExpense) ||
                other.previousMonthExpense == previousMonthExpense) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            const DeepCollectionEquality()
                .equals(other.categoryBreakdown, categoryBreakdown) &&
            const DeepCollectionEquality()
                .equals(other.topExpenses, topExpenses) &&
            (identical(other.topMerchant, topMerchant) ||
                other.topMerchant == topMerchant) &&
            (identical(other.budget, budget) || other.budget == budget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      year,
      month,
      totalExpense,
      totalIncome,
      netIncome,
      previousMonthExpense,
      changePercent,
      const DeepCollectionEquality().hash(categoryBreakdown),
      const DeepCollectionEquality().hash(topExpenses),
      topMerchant,
      budget);

  @override
  String toString() {
    return 'MonthlyReportEntity(year: $year, month: $month, totalExpense: $totalExpense, totalIncome: $totalIncome, netIncome: $netIncome, previousMonthExpense: $previousMonthExpense, changePercent: $changePercent, categoryBreakdown: $categoryBreakdown, topExpenses: $topExpenses, topMerchant: $topMerchant, budget: $budget)';
  }
}

/// @nodoc
abstract mixin class $MonthlyReportEntityCopyWith<$Res> {
  factory $MonthlyReportEntityCopyWith(
          MonthlyReportEntity value, $Res Function(MonthlyReportEntity) _then) =
      _$MonthlyReportEntityCopyWithImpl;
  @useResult
  $Res call(
      {int year,
      int month,
      int totalExpense,
      int totalIncome,
      int netIncome,
      int? previousMonthExpense,
      double? changePercent,
      List<CategoryBreakdownEntity> categoryBreakdown,
      List<TopExpenseEntity> topExpenses,
      TopMerchantEntity? topMerchant,
      BudgetSummaryEntity? budget});

  $TopMerchantEntityCopyWith<$Res>? get topMerchant;
  $BudgetSummaryEntityCopyWith<$Res>? get budget;
}

/// @nodoc
class _$MonthlyReportEntityCopyWithImpl<$Res>
    implements $MonthlyReportEntityCopyWith<$Res> {
  _$MonthlyReportEntityCopyWithImpl(this._self, this._then);

  final MonthlyReportEntity _self;
  final $Res Function(MonthlyReportEntity) _then;

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? totalExpense = null,
    Object? totalIncome = null,
    Object? netIncome = null,
    Object? previousMonthExpense = freezed,
    Object? changePercent = freezed,
    Object? categoryBreakdown = null,
    Object? topExpenses = null,
    Object? topMerchant = freezed,
    Object? budget = freezed,
  }) {
    return _then(_self.copyWith(
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      netIncome: null == netIncome
          ? _self.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as int,
      previousMonthExpense: freezed == previousMonthExpense
          ? _self.previousMonthExpense
          : previousMonthExpense // ignore: cast_nullable_to_non_nullable
              as int?,
      changePercent: freezed == changePercent
          ? _self.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      categoryBreakdown: null == categoryBreakdown
          ? _self.categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdownEntity>,
      topExpenses: null == topExpenses
          ? _self.topExpenses
          : topExpenses // ignore: cast_nullable_to_non_nullable
              as List<TopExpenseEntity>,
      topMerchant: freezed == topMerchant
          ? _self.topMerchant
          : topMerchant // ignore: cast_nullable_to_non_nullable
              as TopMerchantEntity?,
      budget: freezed == budget
          ? _self.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as BudgetSummaryEntity?,
    ));
  }

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopMerchantEntityCopyWith<$Res>? get topMerchant {
    if (_self.topMerchant == null) {
      return null;
    }

    return $TopMerchantEntityCopyWith<$Res>(_self.topMerchant!, (value) {
      return _then(_self.copyWith(topMerchant: value));
    });
  }

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetSummaryEntityCopyWith<$Res>? get budget {
    if (_self.budget == null) {
      return null;
    }

    return $BudgetSummaryEntityCopyWith<$Res>(_self.budget!, (value) {
      return _then(_self.copyWith(budget: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MonthlyReportEntity].
extension MonthlyReportEntityPatterns on MonthlyReportEntity {
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
    TResult Function(_MonthlyReportEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyReportEntity() when $default != null:
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
    TResult Function(_MonthlyReportEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyReportEntity():
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
    TResult? Function(_MonthlyReportEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyReportEntity() when $default != null:
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
            int year,
            int month,
            int totalExpense,
            int totalIncome,
            int netIncome,
            int? previousMonthExpense,
            double? changePercent,
            List<CategoryBreakdownEntity> categoryBreakdown,
            List<TopExpenseEntity> topExpenses,
            TopMerchantEntity? topMerchant,
            BudgetSummaryEntity? budget)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyReportEntity() when $default != null:
        return $default(
            _that.year,
            _that.month,
            _that.totalExpense,
            _that.totalIncome,
            _that.netIncome,
            _that.previousMonthExpense,
            _that.changePercent,
            _that.categoryBreakdown,
            _that.topExpenses,
            _that.topMerchant,
            _that.budget);
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
            int year,
            int month,
            int totalExpense,
            int totalIncome,
            int netIncome,
            int? previousMonthExpense,
            double? changePercent,
            List<CategoryBreakdownEntity> categoryBreakdown,
            List<TopExpenseEntity> topExpenses,
            TopMerchantEntity? topMerchant,
            BudgetSummaryEntity? budget)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyReportEntity():
        return $default(
            _that.year,
            _that.month,
            _that.totalExpense,
            _that.totalIncome,
            _that.netIncome,
            _that.previousMonthExpense,
            _that.changePercent,
            _that.categoryBreakdown,
            _that.topExpenses,
            _that.topMerchant,
            _that.budget);
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
            int year,
            int month,
            int totalExpense,
            int totalIncome,
            int netIncome,
            int? previousMonthExpense,
            double? changePercent,
            List<CategoryBreakdownEntity> categoryBreakdown,
            List<TopExpenseEntity> topExpenses,
            TopMerchantEntity? topMerchant,
            BudgetSummaryEntity? budget)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyReportEntity() when $default != null:
        return $default(
            _that.year,
            _that.month,
            _that.totalExpense,
            _that.totalIncome,
            _that.netIncome,
            _that.previousMonthExpense,
            _that.changePercent,
            _that.categoryBreakdown,
            _that.topExpenses,
            _that.topMerchant,
            _that.budget);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MonthlyReportEntity implements MonthlyReportEntity {
  const _MonthlyReportEntity(
      {required this.year,
      required this.month,
      required this.totalExpense,
      required this.totalIncome,
      required this.netIncome,
      this.previousMonthExpense,
      this.changePercent,
      required final List<CategoryBreakdownEntity> categoryBreakdown,
      required final List<TopExpenseEntity> topExpenses,
      this.topMerchant,
      this.budget})
      : _categoryBreakdown = categoryBreakdown,
        _topExpenses = topExpenses;
  factory _MonthlyReportEntity.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportEntityFromJson(json);

  @override
  final int year;
  @override
  final int month;
  @override
  final int totalExpense;
  @override
  final int totalIncome;
  @override
  final int netIncome;
  @override
  final int? previousMonthExpense;
  @override
  final double? changePercent;
  final List<CategoryBreakdownEntity> _categoryBreakdown;
  @override
  List<CategoryBreakdownEntity> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  final List<TopExpenseEntity> _topExpenses;
  @override
  List<TopExpenseEntity> get topExpenses {
    if (_topExpenses is EqualUnmodifiableListView) return _topExpenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topExpenses);
  }

  @override
  final TopMerchantEntity? topMerchant;
  @override
  final BudgetSummaryEntity? budget;

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyReportEntityCopyWith<_MonthlyReportEntity> get copyWith =>
      __$MonthlyReportEntityCopyWithImpl<_MonthlyReportEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MonthlyReportEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyReportEntity &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome) &&
            (identical(other.previousMonthExpense, previousMonthExpense) ||
                other.previousMonthExpense == previousMonthExpense) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdown, _categoryBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._topExpenses, _topExpenses) &&
            (identical(other.topMerchant, topMerchant) ||
                other.topMerchant == topMerchant) &&
            (identical(other.budget, budget) || other.budget == budget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      year,
      month,
      totalExpense,
      totalIncome,
      netIncome,
      previousMonthExpense,
      changePercent,
      const DeepCollectionEquality().hash(_categoryBreakdown),
      const DeepCollectionEquality().hash(_topExpenses),
      topMerchant,
      budget);

  @override
  String toString() {
    return 'MonthlyReportEntity(year: $year, month: $month, totalExpense: $totalExpense, totalIncome: $totalIncome, netIncome: $netIncome, previousMonthExpense: $previousMonthExpense, changePercent: $changePercent, categoryBreakdown: $categoryBreakdown, topExpenses: $topExpenses, topMerchant: $topMerchant, budget: $budget)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyReportEntityCopyWith<$Res>
    implements $MonthlyReportEntityCopyWith<$Res> {
  factory _$MonthlyReportEntityCopyWith(_MonthlyReportEntity value,
          $Res Function(_MonthlyReportEntity) _then) =
      __$MonthlyReportEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int year,
      int month,
      int totalExpense,
      int totalIncome,
      int netIncome,
      int? previousMonthExpense,
      double? changePercent,
      List<CategoryBreakdownEntity> categoryBreakdown,
      List<TopExpenseEntity> topExpenses,
      TopMerchantEntity? topMerchant,
      BudgetSummaryEntity? budget});

  @override
  $TopMerchantEntityCopyWith<$Res>? get topMerchant;
  @override
  $BudgetSummaryEntityCopyWith<$Res>? get budget;
}

/// @nodoc
class __$MonthlyReportEntityCopyWithImpl<$Res>
    implements _$MonthlyReportEntityCopyWith<$Res> {
  __$MonthlyReportEntityCopyWithImpl(this._self, this._then);

  final _MonthlyReportEntity _self;
  final $Res Function(_MonthlyReportEntity) _then;

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? totalExpense = null,
    Object? totalIncome = null,
    Object? netIncome = null,
    Object? previousMonthExpense = freezed,
    Object? changePercent = freezed,
    Object? categoryBreakdown = null,
    Object? topExpenses = null,
    Object? topMerchant = freezed,
    Object? budget = freezed,
  }) {
    return _then(_MonthlyReportEntity(
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      netIncome: null == netIncome
          ? _self.netIncome
          : netIncome // ignore: cast_nullable_to_non_nullable
              as int,
      previousMonthExpense: freezed == previousMonthExpense
          ? _self.previousMonthExpense
          : previousMonthExpense // ignore: cast_nullable_to_non_nullable
              as int?,
      changePercent: freezed == changePercent
          ? _self.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      categoryBreakdown: null == categoryBreakdown
          ? _self._categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdownEntity>,
      topExpenses: null == topExpenses
          ? _self._topExpenses
          : topExpenses // ignore: cast_nullable_to_non_nullable
              as List<TopExpenseEntity>,
      topMerchant: freezed == topMerchant
          ? _self.topMerchant
          : topMerchant // ignore: cast_nullable_to_non_nullable
              as TopMerchantEntity?,
      budget: freezed == budget
          ? _self.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as BudgetSummaryEntity?,
    ));
  }

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TopMerchantEntityCopyWith<$Res>? get topMerchant {
    if (_self.topMerchant == null) {
      return null;
    }

    return $TopMerchantEntityCopyWith<$Res>(_self.topMerchant!, (value) {
      return _then(_self.copyWith(topMerchant: value));
    });
  }

  /// Create a copy of MonthlyReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetSummaryEntityCopyWith<$Res>? get budget {
    if (_self.budget == null) {
      return null;
    }

    return $BudgetSummaryEntityCopyWith<$Res>(_self.budget!, (value) {
      return _then(_self.copyWith(budget: value));
    });
  }
}

/// @nodoc
mixin _$CategoryBreakdownEntity {
  String get category;
  int get amount;
  int get percentage;

  /// Create a copy of CategoryBreakdownEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryBreakdownEntityCopyWith<CategoryBreakdownEntity> get copyWith =>
      _$CategoryBreakdownEntityCopyWithImpl<CategoryBreakdownEntity>(
          this as CategoryBreakdownEntity, _$identity);

  /// Serializes this CategoryBreakdownEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryBreakdownEntity &&
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
    return 'CategoryBreakdownEntity(category: $category, amount: $amount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $CategoryBreakdownEntityCopyWith<$Res> {
  factory $CategoryBreakdownEntityCopyWith(CategoryBreakdownEntity value,
          $Res Function(CategoryBreakdownEntity) _then) =
      _$CategoryBreakdownEntityCopyWithImpl;
  @useResult
  $Res call({String category, int amount, int percentage});
}

/// @nodoc
class _$CategoryBreakdownEntityCopyWithImpl<$Res>
    implements $CategoryBreakdownEntityCopyWith<$Res> {
  _$CategoryBreakdownEntityCopyWithImpl(this._self, this._then);

  final CategoryBreakdownEntity _self;
  final $Res Function(CategoryBreakdownEntity) _then;

  /// Create a copy of CategoryBreakdownEntity
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
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryBreakdownEntity].
extension CategoryBreakdownEntityPatterns on CategoryBreakdownEntity {
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
    TResult Function(_CategoryBreakdownEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownEntity() when $default != null:
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
    TResult Function(_CategoryBreakdownEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownEntity():
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
    TResult? Function(_CategoryBreakdownEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownEntity() when $default != null:
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
    TResult Function(String category, int amount, int percentage)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownEntity() when $default != null:
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
    TResult Function(String category, int amount, int percentage) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownEntity():
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
    TResult? Function(String category, int amount, int percentage)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryBreakdownEntity() when $default != null:
        return $default(_that.category, _that.amount, _that.percentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryBreakdownEntity implements CategoryBreakdownEntity {
  const _CategoryBreakdownEntity(
      {required this.category, required this.amount, required this.percentage});
  factory _CategoryBreakdownEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownEntityFromJson(json);

  @override
  final String category;
  @override
  final int amount;
  @override
  final int percentage;

  /// Create a copy of CategoryBreakdownEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryBreakdownEntityCopyWith<_CategoryBreakdownEntity> get copyWith =>
      __$CategoryBreakdownEntityCopyWithImpl<_CategoryBreakdownEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryBreakdownEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryBreakdownEntity &&
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
    return 'CategoryBreakdownEntity(category: $category, amount: $amount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$CategoryBreakdownEntityCopyWith<$Res>
    implements $CategoryBreakdownEntityCopyWith<$Res> {
  factory _$CategoryBreakdownEntityCopyWith(_CategoryBreakdownEntity value,
          $Res Function(_CategoryBreakdownEntity) _then) =
      __$CategoryBreakdownEntityCopyWithImpl;
  @override
  @useResult
  $Res call({String category, int amount, int percentage});
}

/// @nodoc
class __$CategoryBreakdownEntityCopyWithImpl<$Res>
    implements _$CategoryBreakdownEntityCopyWith<$Res> {
  __$CategoryBreakdownEntityCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownEntity _self;
  final $Res Function(_CategoryBreakdownEntity) _then;

  /// Create a copy of CategoryBreakdownEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
  }) {
    return _then(_CategoryBreakdownEntity(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$TopExpenseEntity {
  String? get merchant;
  int get amount;
  DateTime get date;
  String? get category;

  /// Create a copy of TopExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopExpenseEntityCopyWith<TopExpenseEntity> get copyWith =>
      _$TopExpenseEntityCopyWithImpl<TopExpenseEntity>(
          this as TopExpenseEntity, _$identity);

  /// Serializes this TopExpenseEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TopExpenseEntity &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, merchant, amount, date, category);

  @override
  String toString() {
    return 'TopExpenseEntity(merchant: $merchant, amount: $amount, date: $date, category: $category)';
  }
}

/// @nodoc
abstract mixin class $TopExpenseEntityCopyWith<$Res> {
  factory $TopExpenseEntityCopyWith(
          TopExpenseEntity value, $Res Function(TopExpenseEntity) _then) =
      _$TopExpenseEntityCopyWithImpl;
  @useResult
  $Res call({String? merchant, int amount, DateTime date, String? category});
}

/// @nodoc
class _$TopExpenseEntityCopyWithImpl<$Res>
    implements $TopExpenseEntityCopyWith<$Res> {
  _$TopExpenseEntityCopyWithImpl(this._self, this._then);

  final TopExpenseEntity _self;
  final $Res Function(TopExpenseEntity) _then;

  /// Create a copy of TopExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchant = freezed,
    Object? amount = null,
    Object? date = null,
    Object? category = freezed,
  }) {
    return _then(_self.copyWith(
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TopExpenseEntity].
extension TopExpenseEntityPatterns on TopExpenseEntity {
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
    TResult Function(_TopExpenseEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TopExpenseEntity() when $default != null:
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
    TResult Function(_TopExpenseEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopExpenseEntity():
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
    TResult? Function(_TopExpenseEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopExpenseEntity() when $default != null:
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
            String? merchant, int amount, DateTime date, String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TopExpenseEntity() when $default != null:
        return $default(
            _that.merchant, _that.amount, _that.date, _that.category);
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
            String? merchant, int amount, DateTime date, String? category)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopExpenseEntity():
        return $default(
            _that.merchant, _that.amount, _that.date, _that.category);
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
            String? merchant, int amount, DateTime date, String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopExpenseEntity() when $default != null:
        return $default(
            _that.merchant, _that.amount, _that.date, _that.category);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TopExpenseEntity implements TopExpenseEntity {
  const _TopExpenseEntity(
      {this.merchant, required this.amount, required this.date, this.category});
  factory _TopExpenseEntity.fromJson(Map<String, dynamic> json) =>
      _$TopExpenseEntityFromJson(json);

  @override
  final String? merchant;
  @override
  final int amount;
  @override
  final DateTime date;
  @override
  final String? category;

  /// Create a copy of TopExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopExpenseEntityCopyWith<_TopExpenseEntity> get copyWith =>
      __$TopExpenseEntityCopyWithImpl<_TopExpenseEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopExpenseEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopExpenseEntity &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, merchant, amount, date, category);

  @override
  String toString() {
    return 'TopExpenseEntity(merchant: $merchant, amount: $amount, date: $date, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$TopExpenseEntityCopyWith<$Res>
    implements $TopExpenseEntityCopyWith<$Res> {
  factory _$TopExpenseEntityCopyWith(
          _TopExpenseEntity value, $Res Function(_TopExpenseEntity) _then) =
      __$TopExpenseEntityCopyWithImpl;
  @override
  @useResult
  $Res call({String? merchant, int amount, DateTime date, String? category});
}

/// @nodoc
class __$TopExpenseEntityCopyWithImpl<$Res>
    implements _$TopExpenseEntityCopyWith<$Res> {
  __$TopExpenseEntityCopyWithImpl(this._self, this._then);

  final _TopExpenseEntity _self;
  final $Res Function(_TopExpenseEntity) _then;

  /// Create a copy of TopExpenseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? merchant = freezed,
    Object? amount = null,
    Object? date = null,
    Object? category = freezed,
  }) {
    return _then(_TopExpenseEntity(
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TopMerchantEntity {
  String get name;
  int get visitCount;

  /// Create a copy of TopMerchantEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopMerchantEntityCopyWith<TopMerchantEntity> get copyWith =>
      _$TopMerchantEntityCopyWithImpl<TopMerchantEntity>(
          this as TopMerchantEntity, _$identity);

  /// Serializes this TopMerchantEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TopMerchantEntity &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.visitCount, visitCount) ||
                other.visitCount == visitCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, visitCount);

  @override
  String toString() {
    return 'TopMerchantEntity(name: $name, visitCount: $visitCount)';
  }
}

/// @nodoc
abstract mixin class $TopMerchantEntityCopyWith<$Res> {
  factory $TopMerchantEntityCopyWith(
          TopMerchantEntity value, $Res Function(TopMerchantEntity) _then) =
      _$TopMerchantEntityCopyWithImpl;
  @useResult
  $Res call({String name, int visitCount});
}

/// @nodoc
class _$TopMerchantEntityCopyWithImpl<$Res>
    implements $TopMerchantEntityCopyWith<$Res> {
  _$TopMerchantEntityCopyWithImpl(this._self, this._then);

  final TopMerchantEntity _self;
  final $Res Function(TopMerchantEntity) _then;

  /// Create a copy of TopMerchantEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? visitCount = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      visitCount: null == visitCount
          ? _self.visitCount
          : visitCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TopMerchantEntity].
extension TopMerchantEntityPatterns on TopMerchantEntity {
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
    TResult Function(_TopMerchantEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TopMerchantEntity() when $default != null:
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
    TResult Function(_TopMerchantEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopMerchantEntity():
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
    TResult? Function(_TopMerchantEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopMerchantEntity() when $default != null:
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
    TResult Function(String name, int visitCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TopMerchantEntity() when $default != null:
        return $default(_that.name, _that.visitCount);
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
    TResult Function(String name, int visitCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopMerchantEntity():
        return $default(_that.name, _that.visitCount);
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
    TResult? Function(String name, int visitCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopMerchantEntity() when $default != null:
        return $default(_that.name, _that.visitCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TopMerchantEntity implements TopMerchantEntity {
  const _TopMerchantEntity({required this.name, required this.visitCount});
  factory _TopMerchantEntity.fromJson(Map<String, dynamic> json) =>
      _$TopMerchantEntityFromJson(json);

  @override
  final String name;
  @override
  final int visitCount;

  /// Create a copy of TopMerchantEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopMerchantEntityCopyWith<_TopMerchantEntity> get copyWith =>
      __$TopMerchantEntityCopyWithImpl<_TopMerchantEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopMerchantEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopMerchantEntity &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.visitCount, visitCount) ||
                other.visitCount == visitCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, visitCount);

  @override
  String toString() {
    return 'TopMerchantEntity(name: $name, visitCount: $visitCount)';
  }
}

/// @nodoc
abstract mixin class _$TopMerchantEntityCopyWith<$Res>
    implements $TopMerchantEntityCopyWith<$Res> {
  factory _$TopMerchantEntityCopyWith(
          _TopMerchantEntity value, $Res Function(_TopMerchantEntity) _then) =
      __$TopMerchantEntityCopyWithImpl;
  @override
  @useResult
  $Res call({String name, int visitCount});
}

/// @nodoc
class __$TopMerchantEntityCopyWithImpl<$Res>
    implements _$TopMerchantEntityCopyWith<$Res> {
  __$TopMerchantEntityCopyWithImpl(this._self, this._then);

  final _TopMerchantEntity _self;
  final $Res Function(_TopMerchantEntity) _then;

  /// Create a copy of TopMerchantEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? visitCount = null,
  }) {
    return _then(_TopMerchantEntity(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      visitCount: null == visitCount
          ? _self.visitCount
          : visitCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$BudgetSummaryEntity {
  int get targetAmount;
  int get currentSpending;
  int get usagePercentage;

  /// Create a copy of BudgetSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetSummaryEntityCopyWith<BudgetSummaryEntity> get copyWith =>
      _$BudgetSummaryEntityCopyWithImpl<BudgetSummaryEntity>(
          this as BudgetSummaryEntity, _$identity);

  /// Serializes this BudgetSummaryEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetSummaryEntity &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentSpending, currentSpending) ||
                other.currentSpending == currentSpending) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetAmount, currentSpending, usagePercentage);

  @override
  String toString() {
    return 'BudgetSummaryEntity(targetAmount: $targetAmount, currentSpending: $currentSpending, usagePercentage: $usagePercentage)';
  }
}

/// @nodoc
abstract mixin class $BudgetSummaryEntityCopyWith<$Res> {
  factory $BudgetSummaryEntityCopyWith(
          BudgetSummaryEntity value, $Res Function(BudgetSummaryEntity) _then) =
      _$BudgetSummaryEntityCopyWithImpl;
  @useResult
  $Res call({int targetAmount, int currentSpending, int usagePercentage});
}

/// @nodoc
class _$BudgetSummaryEntityCopyWithImpl<$Res>
    implements $BudgetSummaryEntityCopyWith<$Res> {
  _$BudgetSummaryEntityCopyWithImpl(this._self, this._then);

  final BudgetSummaryEntity _self;
  final $Res Function(BudgetSummaryEntity) _then;

  /// Create a copy of BudgetSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetAmount = null,
    Object? currentSpending = null,
    Object? usagePercentage = null,
  }) {
    return _then(_self.copyWith(
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as int,
      currentSpending: null == currentSpending
          ? _self.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as int,
      usagePercentage: null == usagePercentage
          ? _self.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [BudgetSummaryEntity].
extension BudgetSummaryEntityPatterns on BudgetSummaryEntity {
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
    TResult Function(_BudgetSummaryEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetSummaryEntity() when $default != null:
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
    TResult Function(_BudgetSummaryEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSummaryEntity():
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
    TResult? Function(_BudgetSummaryEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSummaryEntity() when $default != null:
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
            int targetAmount, int currentSpending, int usagePercentage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetSummaryEntity() when $default != null:
        return $default(
            _that.targetAmount, _that.currentSpending, _that.usagePercentage);
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
    TResult Function(int targetAmount, int currentSpending, int usagePercentage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSummaryEntity():
        return $default(
            _that.targetAmount, _that.currentSpending, _that.usagePercentage);
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
            int targetAmount, int currentSpending, int usagePercentage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetSummaryEntity() when $default != null:
        return $default(
            _that.targetAmount, _that.currentSpending, _that.usagePercentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetSummaryEntity implements BudgetSummaryEntity {
  const _BudgetSummaryEntity(
      {required this.targetAmount,
      required this.currentSpending,
      required this.usagePercentage});
  factory _BudgetSummaryEntity.fromJson(Map<String, dynamic> json) =>
      _$BudgetSummaryEntityFromJson(json);

  @override
  final int targetAmount;
  @override
  final int currentSpending;
  @override
  final int usagePercentage;

  /// Create a copy of BudgetSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetSummaryEntityCopyWith<_BudgetSummaryEntity> get copyWith =>
      __$BudgetSummaryEntityCopyWithImpl<_BudgetSummaryEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetSummaryEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetSummaryEntity &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentSpending, currentSpending) ||
                other.currentSpending == currentSpending) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetAmount, currentSpending, usagePercentage);

  @override
  String toString() {
    return 'BudgetSummaryEntity(targetAmount: $targetAmount, currentSpending: $currentSpending, usagePercentage: $usagePercentage)';
  }
}

/// @nodoc
abstract mixin class _$BudgetSummaryEntityCopyWith<$Res>
    implements $BudgetSummaryEntityCopyWith<$Res> {
  factory _$BudgetSummaryEntityCopyWith(_BudgetSummaryEntity value,
          $Res Function(_BudgetSummaryEntity) _then) =
      __$BudgetSummaryEntityCopyWithImpl;
  @override
  @useResult
  $Res call({int targetAmount, int currentSpending, int usagePercentage});
}

/// @nodoc
class __$BudgetSummaryEntityCopyWithImpl<$Res>
    implements _$BudgetSummaryEntityCopyWith<$Res> {
  __$BudgetSummaryEntityCopyWithImpl(this._self, this._then);

  final _BudgetSummaryEntity _self;
  final $Res Function(_BudgetSummaryEntity) _then;

  /// Create a copy of BudgetSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? targetAmount = null,
    Object? currentSpending = null,
    Object? usagePercentage = null,
  }) {
    return _then(_BudgetSummaryEntity(
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as int,
      currentSpending: null == currentSpending
          ? _self.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as int,
      usagePercentage: null == usagePercentage
          ? _self.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
