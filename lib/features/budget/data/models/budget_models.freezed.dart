// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetResponseModel {
  String get budgetId;
  String get userId;
  int get year;
  int get month;
  double get targetAmount;
  double get currentSpending;
  double get remainingAmount;
  double get usagePercentage;

  /// Create a copy of BudgetResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetResponseModelCopyWith<BudgetResponseModel> get copyWith =>
      _$BudgetResponseModelCopyWithImpl<BudgetResponseModel>(
          this as BudgetResponseModel, _$identity);

  /// Serializes this BudgetResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetResponseModel &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
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
  int get hashCode => Object.hash(runtimeType, budgetId, userId, year, month,
      targetAmount, currentSpending, remainingAmount, usagePercentage);

  @override
  String toString() {
    return 'BudgetResponseModel(budgetId: $budgetId, userId: $userId, year: $year, month: $month, targetAmount: $targetAmount, currentSpending: $currentSpending, remainingAmount: $remainingAmount, usagePercentage: $usagePercentage)';
  }
}

/// @nodoc
abstract mixin class $BudgetResponseModelCopyWith<$Res> {
  factory $BudgetResponseModelCopyWith(
          BudgetResponseModel value, $Res Function(BudgetResponseModel) _then) =
      _$BudgetResponseModelCopyWithImpl;
  @useResult
  $Res call(
      {String budgetId,
      String userId,
      int year,
      int month,
      double targetAmount,
      double currentSpending,
      double remainingAmount,
      double usagePercentage});
}

/// @nodoc
class _$BudgetResponseModelCopyWithImpl<$Res>
    implements $BudgetResponseModelCopyWith<$Res> {
  _$BudgetResponseModelCopyWithImpl(this._self, this._then);

  final BudgetResponseModel _self;
  final $Res Function(BudgetResponseModel) _then;

  /// Create a copy of BudgetResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? userId = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [BudgetResponseModel].
extension BudgetResponseModelPatterns on BudgetResponseModel {
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
    TResult Function(_BudgetResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetResponseModel() when $default != null:
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
    TResult Function(_BudgetResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetResponseModel():
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
    TResult? Function(_BudgetResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetResponseModel() when $default != null:
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
            String userId,
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
      case _BudgetResponseModel() when $default != null:
        return $default(
            _that.budgetId,
            _that.userId,
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
            String userId,
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
      case _BudgetResponseModel():
        return $default(
            _that.budgetId,
            _that.userId,
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
            String userId,
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
      case _BudgetResponseModel() when $default != null:
        return $default(
            _that.budgetId,
            _that.userId,
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
class _BudgetResponseModel extends BudgetResponseModel {
  const _BudgetResponseModel(
      {required this.budgetId,
      required this.userId,
      required this.year,
      required this.month,
      required this.targetAmount,
      required this.currentSpending,
      required this.remainingAmount,
      required this.usagePercentage})
      : super._();
  factory _BudgetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetResponseModelFromJson(json);

  @override
  final String budgetId;
  @override
  final String userId;
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

  /// Create a copy of BudgetResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetResponseModelCopyWith<_BudgetResponseModel> get copyWith =>
      __$BudgetResponseModelCopyWithImpl<_BudgetResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetResponseModel &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
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
  int get hashCode => Object.hash(runtimeType, budgetId, userId, year, month,
      targetAmount, currentSpending, remainingAmount, usagePercentage);

  @override
  String toString() {
    return 'BudgetResponseModel(budgetId: $budgetId, userId: $userId, year: $year, month: $month, targetAmount: $targetAmount, currentSpending: $currentSpending, remainingAmount: $remainingAmount, usagePercentage: $usagePercentage)';
  }
}

/// @nodoc
abstract mixin class _$BudgetResponseModelCopyWith<$Res>
    implements $BudgetResponseModelCopyWith<$Res> {
  factory _$BudgetResponseModelCopyWith(_BudgetResponseModel value,
          $Res Function(_BudgetResponseModel) _then) =
      __$BudgetResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String budgetId,
      String userId,
      int year,
      int month,
      double targetAmount,
      double currentSpending,
      double remainingAmount,
      double usagePercentage});
}

/// @nodoc
class __$BudgetResponseModelCopyWithImpl<$Res>
    implements _$BudgetResponseModelCopyWith<$Res> {
  __$BudgetResponseModelCopyWithImpl(this._self, this._then);

  final _BudgetResponseModel _self;
  final $Res Function(_BudgetResponseModel) _then;

  /// Create a copy of BudgetResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? budgetId = null,
    Object? userId = null,
    Object? year = null,
    Object? month = null,
    Object? targetAmount = null,
    Object? currentSpending = null,
    Object? remainingAmount = null,
    Object? usagePercentage = null,
  }) {
    return _then(_BudgetResponseModel(
      budgetId: null == budgetId
          ? _self.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
mixin _$AssetResponseModel {
  String get accountBookId;
  String get accountBookName;
  double get currentTotalAssets;
  double get initialBalance;
  double get totalIncome;
  double get totalExpense;
  double get periodIncome;
  double get periodExpense;
  double get periodNetIncome;

  /// Create a copy of AssetResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetResponseModelCopyWith<AssetResponseModel> get copyWith =>
      _$AssetResponseModelCopyWithImpl<AssetResponseModel>(
          this as AssetResponseModel, _$identity);

  /// Serializes this AssetResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetResponseModel &&
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
    return 'AssetResponseModel(accountBookId: $accountBookId, accountBookName: $accountBookName, currentTotalAssets: $currentTotalAssets, initialBalance: $initialBalance, totalIncome: $totalIncome, totalExpense: $totalExpense, periodIncome: $periodIncome, periodExpense: $periodExpense, periodNetIncome: $periodNetIncome)';
  }
}

/// @nodoc
abstract mixin class $AssetResponseModelCopyWith<$Res> {
  factory $AssetResponseModelCopyWith(
          AssetResponseModel value, $Res Function(AssetResponseModel) _then) =
      _$AssetResponseModelCopyWithImpl;
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
class _$AssetResponseModelCopyWithImpl<$Res>
    implements $AssetResponseModelCopyWith<$Res> {
  _$AssetResponseModelCopyWithImpl(this._self, this._then);

  final AssetResponseModel _self;
  final $Res Function(AssetResponseModel) _then;

  /// Create a copy of AssetResponseModel
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

/// Adds pattern-matching-related methods to [AssetResponseModel].
extension AssetResponseModelPatterns on AssetResponseModel {
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
    TResult Function(_AssetResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetResponseModel() when $default != null:
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
    TResult Function(_AssetResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetResponseModel():
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
    TResult? Function(_AssetResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetResponseModel() when $default != null:
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
      case _AssetResponseModel() when $default != null:
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
      case _AssetResponseModel():
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
      case _AssetResponseModel() when $default != null:
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
class _AssetResponseModel extends AssetResponseModel {
  const _AssetResponseModel(
      {required this.accountBookId,
      required this.accountBookName,
      required this.currentTotalAssets,
      required this.initialBalance,
      required this.totalIncome,
      required this.totalExpense,
      required this.periodIncome,
      required this.periodExpense,
      required this.periodNetIncome})
      : super._();
  factory _AssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseModelFromJson(json);

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
  @override
  final double periodIncome;
  @override
  final double periodExpense;
  @override
  final double periodNetIncome;

  /// Create a copy of AssetResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetResponseModelCopyWith<_AssetResponseModel> get copyWith =>
      __$AssetResponseModelCopyWithImpl<_AssetResponseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetResponseModel &&
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
    return 'AssetResponseModel(accountBookId: $accountBookId, accountBookName: $accountBookName, currentTotalAssets: $currentTotalAssets, initialBalance: $initialBalance, totalIncome: $totalIncome, totalExpense: $totalExpense, periodIncome: $periodIncome, periodExpense: $periodExpense, periodNetIncome: $periodNetIncome)';
  }
}

/// @nodoc
abstract mixin class _$AssetResponseModelCopyWith<$Res>
    implements $AssetResponseModelCopyWith<$Res> {
  factory _$AssetResponseModelCopyWith(
          _AssetResponseModel value, $Res Function(_AssetResponseModel) _then) =
      __$AssetResponseModelCopyWithImpl;
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
class __$AssetResponseModelCopyWithImpl<$Res>
    implements _$AssetResponseModelCopyWith<$Res> {
  __$AssetResponseModelCopyWithImpl(this._self, this._then);

  final _AssetResponseModel _self;
  final $Res Function(_AssetResponseModel) _then;

  /// Create a copy of AssetResponseModel
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
    return _then(_AssetResponseModel(
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
