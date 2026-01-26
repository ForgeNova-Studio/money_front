// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetEntity {
  String get budgetId;
  int get year;
  int get month;
  double get targetAmount;
  double get currentSpending;
  double get remainingAmount;
  double get usagePercentage;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetEntityCopyWith<BudgetEntity> get copyWith =>
      _$BudgetEntityCopyWithImpl<BudgetEntity>(
          this as BudgetEntity, _$identity);

  /// Serializes this BudgetEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetEntity &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentSpending, currentSpending) ||
                other.currentSpending == currentSpending) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, budgetId, year, month,
      targetAmount, currentSpending, remainingAmount, usagePercentage);

  @override
  String toString() {
    return 'BudgetEntity(budgetId: $budgetId, year: $year, month: $month, targetAmount: $targetAmount, currentSpending: $currentSpending, remainingAmount: $remainingAmount, usagePercentage: $usagePercentage)';
  }
}

/// @nodoc
abstract mixin class $BudgetEntityCopyWith<$Res> {
  factory $BudgetEntityCopyWith(
          BudgetEntity value, $Res Function(BudgetEntity) _then) =
      _$BudgetEntityCopyWithImpl;
  @useResult
  $Res call(
      {String budgetId,
      int year,
      int month,
      double targetAmount,
      double currentSpending,
      double remainingAmount,
      double usagePercentage});
}

/// @nodoc
class _$BudgetEntityCopyWithImpl<$Res> implements $BudgetEntityCopyWith<$Res> {
  _$BudgetEntityCopyWithImpl(this._self, this._then);

  final BudgetEntity _self;
  final $Res Function(BudgetEntity) _then;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? year = null,
    Object? month = null,
    Object? targetAmount = null,
    Object? currentSpending = null,
    Object? remainingAmount = null,
    Object? usagePercentage = null,
  }) {
    return _then(_self.copyWith(
      budgetId: null == budgetId
          ? _self.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentSpending: null == currentSpending
          ? _self.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _self.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      usagePercentage: null == usagePercentage
          ? _self.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [BudgetEntity].
extension BudgetEntityPatterns on BudgetEntity {
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
    TResult Function(_BudgetEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetEntity() when $default != null:
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
    TResult Function(_BudgetEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetEntity():
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
    TResult? Function(_BudgetEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetEntity() when $default != null:
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
            String budgetId,
            int year,
            int month,
            double targetAmount,
            double currentSpending,
            double remainingAmount,
            double usagePercentage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetEntity() when $default != null:
        return $default(
            _that.budgetId,
            _that.year,
            _that.month,
            _that.targetAmount,
            _that.currentSpending,
            _that.remainingAmount,
            _that.usagePercentage);
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
            String budgetId,
            int year,
            int month,
            double targetAmount,
            double currentSpending,
            double remainingAmount,
            double usagePercentage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetEntity():
        return $default(
            _that.budgetId,
            _that.year,
            _that.month,
            _that.targetAmount,
            _that.currentSpending,
            _that.remainingAmount,
            _that.usagePercentage);
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
            String budgetId,
            int year,
            int month,
            double targetAmount,
            double currentSpending,
            double remainingAmount,
            double usagePercentage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetEntity() when $default != null:
        return $default(
            _that.budgetId,
            _that.year,
            _that.month,
            _that.targetAmount,
            _that.currentSpending,
            _that.remainingAmount,
            _that.usagePercentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetEntity implements BudgetEntity {
  const _BudgetEntity(
      {required this.budgetId,
      required this.year,
      required this.month,
      required this.targetAmount,
      required this.currentSpending,
      required this.remainingAmount,
      required this.usagePercentage});
  factory _BudgetEntity.fromJson(Map<String, dynamic> json) =>
      _$BudgetEntityFromJson(json);

  @override
  final String budgetId;
  @override
  final int year;
  @override
  final int month;
  @override
  final double targetAmount;
  @override
  final double currentSpending;
  @override
  final double remainingAmount;
  @override
  final double usagePercentage;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetEntityCopyWith<_BudgetEntity> get copyWith =>
      __$BudgetEntityCopyWithImpl<_BudgetEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetEntity &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentSpending, currentSpending) ||
                other.currentSpending == currentSpending) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, budgetId, year, month,
      targetAmount, currentSpending, remainingAmount, usagePercentage);

  @override
  String toString() {
    return 'BudgetEntity(budgetId: $budgetId, year: $year, month: $month, targetAmount: $targetAmount, currentSpending: $currentSpending, remainingAmount: $remainingAmount, usagePercentage: $usagePercentage)';
  }
}

/// @nodoc
abstract mixin class _$BudgetEntityCopyWith<$Res>
    implements $BudgetEntityCopyWith<$Res> {
  factory _$BudgetEntityCopyWith(
          _BudgetEntity value, $Res Function(_BudgetEntity) _then) =
      __$BudgetEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String budgetId,
      int year,
      int month,
      double targetAmount,
      double currentSpending,
      double remainingAmount,
      double usagePercentage});
}

/// @nodoc
class __$BudgetEntityCopyWithImpl<$Res>
    implements _$BudgetEntityCopyWith<$Res> {
  __$BudgetEntityCopyWithImpl(this._self, this._then);

  final _BudgetEntity _self;
  final $Res Function(_BudgetEntity) _then;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? budgetId = null,
    Object? year = null,
    Object? month = null,
    Object? targetAmount = null,
    Object? currentSpending = null,
    Object? remainingAmount = null,
    Object? usagePercentage = null,
  }) {
    return _then(_BudgetEntity(
      budgetId: null == budgetId
          ? _self.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentSpending: null == currentSpending
          ? _self.currentSpending
          : currentSpending // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _self.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      usagePercentage: null == usagePercentage
          ? _self.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$AssetEntity {
  String get accountBookId;
  String get accountBookName;
  double get currentTotalAssets;
  double get initialBalance;
  double get totalIncome;
  double get totalExpense;

  /// 이번 달 수입
  double get periodIncome;

  /// 이번 달 지출
  double get periodExpense;

  /// 이번 달 순수익
  double get periodNetIncome;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetEntityCopyWith<AssetEntity> get copyWith =>
      _$AssetEntityCopyWithImpl<AssetEntity>(this as AssetEntity, _$identity);

  /// Serializes this AssetEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetEntity &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.accountBookName, accountBookName) ||
                other.accountBookName == accountBookName) &&
            (identical(other.currentTotalAssets, currentTotalAssets) ||
                other.currentTotalAssets == currentTotalAssets) &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.periodIncome, periodIncome) ||
                other.periodIncome == periodIncome) &&
            (identical(other.periodExpense, periodExpense) ||
                other.periodExpense == periodExpense) &&
            (identical(other.periodNetIncome, periodNetIncome) ||
                other.periodNetIncome == periodNetIncome));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      accountBookName,
      currentTotalAssets,
      initialBalance,
      totalIncome,
      totalExpense,
      periodIncome,
      periodExpense,
      periodNetIncome);

  @override
  String toString() {
    return 'AssetEntity(accountBookId: $accountBookId, accountBookName: $accountBookName, currentTotalAssets: $currentTotalAssets, initialBalance: $initialBalance, totalIncome: $totalIncome, totalExpense: $totalExpense, periodIncome: $periodIncome, periodExpense: $periodExpense, periodNetIncome: $periodNetIncome)';
  }
}

/// @nodoc
abstract mixin class $AssetEntityCopyWith<$Res> {
  factory $AssetEntityCopyWith(
          AssetEntity value, $Res Function(AssetEntity) _then) =
      _$AssetEntityCopyWithImpl;
  @useResult
  $Res call(
      {String accountBookId,
      String accountBookName,
      double currentTotalAssets,
      double initialBalance,
      double totalIncome,
      double totalExpense,
      double periodIncome,
      double periodExpense,
      double periodNetIncome});
}

/// @nodoc
class _$AssetEntityCopyWithImpl<$Res> implements $AssetEntityCopyWith<$Res> {
  _$AssetEntityCopyWithImpl(this._self, this._then);

  final AssetEntity _self;
  final $Res Function(AssetEntity) _then;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountBookId = null,
    Object? accountBookName = null,
    Object? currentTotalAssets = null,
    Object? initialBalance = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? periodIncome = null,
    Object? periodExpense = null,
    Object? periodNetIncome = null,
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
      currentTotalAssets: null == currentTotalAssets
          ? _self.currentTotalAssets
          : currentTotalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      initialBalance: null == initialBalance
          ? _self.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      periodIncome: null == periodIncome
          ? _self.periodIncome
          : periodIncome // ignore: cast_nullable_to_non_nullable
              as double,
      periodExpense: null == periodExpense
          ? _self.periodExpense
          : periodExpense // ignore: cast_nullable_to_non_nullable
              as double,
      periodNetIncome: null == periodNetIncome
          ? _self.periodNetIncome
          : periodNetIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetEntity].
extension AssetEntityPatterns on AssetEntity {
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
    TResult Function(_AssetEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
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
    TResult Function(_AssetEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity():
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
    TResult? Function(_AssetEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
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
            double currentTotalAssets,
            double initialBalance,
            double totalIncome,
            double totalExpense,
            double periodIncome,
            double periodExpense,
            double periodNetIncome)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.currentTotalAssets,
            _that.initialBalance,
            _that.totalIncome,
            _that.totalExpense,
            _that.periodIncome,
            _that.periodExpense,
            _that.periodNetIncome);
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
            double currentTotalAssets,
            double initialBalance,
            double totalIncome,
            double totalExpense,
            double periodIncome,
            double periodExpense,
            double periodNetIncome)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity():
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.currentTotalAssets,
            _that.initialBalance,
            _that.totalIncome,
            _that.totalExpense,
            _that.periodIncome,
            _that.periodExpense,
            _that.periodNetIncome);
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
            double currentTotalAssets,
            double initialBalance,
            double totalIncome,
            double totalExpense,
            double periodIncome,
            double periodExpense,
            double periodNetIncome)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetEntity() when $default != null:
        return $default(
            _that.accountBookId,
            _that.accountBookName,
            _that.currentTotalAssets,
            _that.initialBalance,
            _that.totalIncome,
            _that.totalExpense,
            _that.periodIncome,
            _that.periodExpense,
            _that.periodNetIncome);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetEntity implements AssetEntity {
  const _AssetEntity(
      {required this.accountBookId,
      required this.accountBookName,
      required this.currentTotalAssets,
      required this.initialBalance,
      required this.totalIncome,
      required this.totalExpense,
      required this.periodIncome,
      required this.periodExpense,
      required this.periodNetIncome});
  factory _AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);

  @override
  final String accountBookId;
  @override
  final String accountBookName;
  @override
  final double currentTotalAssets;
  @override
  final double initialBalance;
  @override
  final double totalIncome;
  @override
  final double totalExpense;

  /// 이번 달 수입
  @override
  final double periodIncome;

  /// 이번 달 지출
  @override
  final double periodExpense;

  /// 이번 달 순수익
  @override
  final double periodNetIncome;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetEntityCopyWith<_AssetEntity> get copyWith =>
      __$AssetEntityCopyWithImpl<_AssetEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetEntity &&
            (identical(other.accountBookId, accountBookId) ||
                other.accountBookId == accountBookId) &&
            (identical(other.accountBookName, accountBookName) ||
                other.accountBookName == accountBookName) &&
            (identical(other.currentTotalAssets, currentTotalAssets) ||
                other.currentTotalAssets == currentTotalAssets) &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.periodIncome, periodIncome) ||
                other.periodIncome == periodIncome) &&
            (identical(other.periodExpense, periodExpense) ||
                other.periodExpense == periodExpense) &&
            (identical(other.periodNetIncome, periodNetIncome) ||
                other.periodNetIncome == periodNetIncome));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountBookId,
      accountBookName,
      currentTotalAssets,
      initialBalance,
      totalIncome,
      totalExpense,
      periodIncome,
      periodExpense,
      periodNetIncome);

  @override
  String toString() {
    return 'AssetEntity(accountBookId: $accountBookId, accountBookName: $accountBookName, currentTotalAssets: $currentTotalAssets, initialBalance: $initialBalance, totalIncome: $totalIncome, totalExpense: $totalExpense, periodIncome: $periodIncome, periodExpense: $periodExpense, periodNetIncome: $periodNetIncome)';
  }
}

/// @nodoc
abstract mixin class _$AssetEntityCopyWith<$Res>
    implements $AssetEntityCopyWith<$Res> {
  factory _$AssetEntityCopyWith(
          _AssetEntity value, $Res Function(_AssetEntity) _then) =
      __$AssetEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accountBookId,
      String accountBookName,
      double currentTotalAssets,
      double initialBalance,
      double totalIncome,
      double totalExpense,
      double periodIncome,
      double periodExpense,
      double periodNetIncome});
}

/// @nodoc
class __$AssetEntityCopyWithImpl<$Res> implements _$AssetEntityCopyWith<$Res> {
  __$AssetEntityCopyWithImpl(this._self, this._then);

  final _AssetEntity _self;
  final $Res Function(_AssetEntity) _then;

  /// Create a copy of AssetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountBookId = null,
    Object? accountBookName = null,
    Object? currentTotalAssets = null,
    Object? initialBalance = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? periodIncome = null,
    Object? periodExpense = null,
    Object? periodNetIncome = null,
  }) {
    return _then(_AssetEntity(
      accountBookId: null == accountBookId
          ? _self.accountBookId
          : accountBookId // ignore: cast_nullable_to_non_nullable
              as String,
      accountBookName: null == accountBookName
          ? _self.accountBookName
          : accountBookName // ignore: cast_nullable_to_non_nullable
              as String,
      currentTotalAssets: null == currentTotalAssets
          ? _self.currentTotalAssets
          : currentTotalAssets // ignore: cast_nullable_to_non_nullable
              as double,
      initialBalance: null == initialBalance
          ? _self.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      periodIncome: null == periodIncome
          ? _self.periodIncome
          : periodIncome // ignore: cast_nullable_to_non_nullable
              as double,
      periodExpense: null == periodExpense
          ? _self.periodExpense
          : periodExpense // ignore: cast_nullable_to_non_nullable
              as double,
      periodNetIncome: null == periodNetIncome
          ? _self.periodNetIncome
          : periodNetIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
