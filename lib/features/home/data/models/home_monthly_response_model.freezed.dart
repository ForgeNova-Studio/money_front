// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_monthly_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeTransactionModel {
  String get id; // UUID String (예: "123e4567-e89b-12d3-a456-426614174000")
  String get type; // "INCOME" or "EXPENSE"
  int get amount;
  String get title;
  String get category;
  String get time;

  /// Create a copy of HomeTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeTransactionModelCopyWith<HomeTransactionModel> get copyWith =>
      _$HomeTransactionModelCopyWithImpl<HomeTransactionModel>(
          this as HomeTransactionModel, _$identity);

  /// Serializes this HomeTransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, amount, title, category, time);

  @override
  String toString() {
    return 'HomeTransactionModel(id: $id, type: $type, amount: $amount, title: $title, category: $category, time: $time)';
  }
}

/// @nodoc
abstract mixin class $HomeTransactionModelCopyWith<$Res> {
  factory $HomeTransactionModelCopyWith(HomeTransactionModel value,
          $Res Function(HomeTransactionModel) _then) =
      _$HomeTransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String type,
      int amount,
      String title,
      String category,
      String time});
}

/// @nodoc
class _$HomeTransactionModelCopyWithImpl<$Res>
    implements $HomeTransactionModelCopyWith<$Res> {
  _$HomeTransactionModelCopyWithImpl(this._self, this._then);

  final HomeTransactionModel _self;
  final $Res Function(HomeTransactionModel) _then;

  /// Create a copy of HomeTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? title = null,
    Object? category = null,
    Object? time = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeTransactionModel].
extension HomeTransactionModelPatterns on HomeTransactionModel {
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
    TResult Function(_HomeTransactionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeTransactionModel() when $default != null:
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
    TResult Function(_HomeTransactionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeTransactionModel():
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
    TResult? Function(_HomeTransactionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeTransactionModel() when $default != null:
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
    TResult Function(String id, String type, int amount, String title,
            String category, String time)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeTransactionModel() when $default != null:
        return $default(_that.id, _that.type, _that.amount, _that.title,
            _that.category, _that.time);
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
    TResult Function(String id, String type, int amount, String title,
            String category, String time)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeTransactionModel():
        return $default(_that.id, _that.type, _that.amount, _that.title,
            _that.category, _that.time);
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
    TResult? Function(String id, String type, int amount, String title,
            String category, String time)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeTransactionModel() when $default != null:
        return $default(_that.id, _that.type, _that.amount, _that.title,
            _that.category, _that.time);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HomeTransactionModel extends HomeTransactionModel {
  const _HomeTransactionModel(
      {required this.id,
      required this.type,
      required this.amount,
      required this.title,
      required this.category,
      required this.time})
      : super._();
  factory _HomeTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$HomeTransactionModelFromJson(json);

  @override
  final String id;
// UUID String (예: "123e4567-e89b-12d3-a456-426614174000")
  @override
  final String type;
// "INCOME" or "EXPENSE"
  @override
  final int amount;
  @override
  final String title;
  @override
  final String category;
  @override
  final String time;

  /// Create a copy of HomeTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeTransactionModelCopyWith<_HomeTransactionModel> get copyWith =>
      __$HomeTransactionModelCopyWithImpl<_HomeTransactionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HomeTransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, amount, title, category, time);

  @override
  String toString() {
    return 'HomeTransactionModel(id: $id, type: $type, amount: $amount, title: $title, category: $category, time: $time)';
  }
}

/// @nodoc
abstract mixin class _$HomeTransactionModelCopyWith<$Res>
    implements $HomeTransactionModelCopyWith<$Res> {
  factory _$HomeTransactionModelCopyWith(_HomeTransactionModel value,
          $Res Function(_HomeTransactionModel) _then) =
      __$HomeTransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      int amount,
      String title,
      String category,
      String time});
}

/// @nodoc
class __$HomeTransactionModelCopyWithImpl<$Res>
    implements _$HomeTransactionModelCopyWith<$Res> {
  __$HomeTransactionModelCopyWithImpl(this._self, this._then);

  final _HomeTransactionModel _self;
  final $Res Function(_HomeTransactionModel) _then;

  /// Create a copy of HomeTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? title = null,
    Object? category = null,
    Object? time = null,
  }) {
    return _then(_HomeTransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$DailyTransactionSummaryModel {
  String get date; // "2025-12-24"
  int get totalIncome;
  int get totalExpense;
  List<HomeTransactionModel> get transactions;

  /// Create a copy of DailyTransactionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailyTransactionSummaryModelCopyWith<DailyTransactionSummaryModel>
      get copyWith => _$DailyTransactionSummaryModelCopyWithImpl<
              DailyTransactionSummaryModel>(
          this as DailyTransactionSummaryModel, _$identity);

  /// Serializes this DailyTransactionSummaryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailyTransactionSummaryModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            const DeepCollectionEquality()
                .equals(other.transactions, transactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalIncome, totalExpense,
      const DeepCollectionEquality().hash(transactions));

  @override
  String toString() {
    return 'DailyTransactionSummaryModel(date: $date, totalIncome: $totalIncome, totalExpense: $totalExpense, transactions: $transactions)';
  }
}

/// @nodoc
abstract mixin class $DailyTransactionSummaryModelCopyWith<$Res> {
  factory $DailyTransactionSummaryModelCopyWith(
          DailyTransactionSummaryModel value,
          $Res Function(DailyTransactionSummaryModel) _then) =
      _$DailyTransactionSummaryModelCopyWithImpl;
  @useResult
  $Res call(
      {String date,
      int totalIncome,
      int totalExpense,
      List<HomeTransactionModel> transactions});
}

/// @nodoc
class _$DailyTransactionSummaryModelCopyWithImpl<$Res>
    implements $DailyTransactionSummaryModelCopyWith<$Res> {
  _$DailyTransactionSummaryModelCopyWithImpl(this._self, this._then);

  final DailyTransactionSummaryModel _self;
  final $Res Function(DailyTransactionSummaryModel) _then;

  /// Create a copy of DailyTransactionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? transactions = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      transactions: null == transactions
          ? _self.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<HomeTransactionModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailyTransactionSummaryModel].
extension DailyTransactionSummaryModelPatterns on DailyTransactionSummaryModel {
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
    TResult Function(_DailyTransactionSummaryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyTransactionSummaryModel() when $default != null:
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
    TResult Function(_DailyTransactionSummaryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyTransactionSummaryModel():
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
    TResult? Function(_DailyTransactionSummaryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyTransactionSummaryModel() when $default != null:
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
    TResult Function(String date, int totalIncome, int totalExpense,
            List<HomeTransactionModel> transactions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyTransactionSummaryModel() when $default != null:
        return $default(_that.date, _that.totalIncome, _that.totalExpense,
            _that.transactions);
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
    TResult Function(String date, int totalIncome, int totalExpense,
            List<HomeTransactionModel> transactions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyTransactionSummaryModel():
        return $default(_that.date, _that.totalIncome, _that.totalExpense,
            _that.transactions);
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
    TResult? Function(String date, int totalIncome, int totalExpense,
            List<HomeTransactionModel> transactions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyTransactionSummaryModel() when $default != null:
        return $default(_that.date, _that.totalIncome, _that.totalExpense,
            _that.transactions);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DailyTransactionSummaryModel extends DailyTransactionSummaryModel {
  const _DailyTransactionSummaryModel(
      {required this.date,
      required this.totalIncome,
      required this.totalExpense,
      required final List<HomeTransactionModel> transactions})
      : _transactions = transactions,
        super._();
  factory _DailyTransactionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTransactionSummaryModelFromJson(json);

  @override
  final String date;
// "2025-12-24"
  @override
  final int totalIncome;
  @override
  final int totalExpense;
  final List<HomeTransactionModel> _transactions;
  @override
  List<HomeTransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  /// Create a copy of DailyTransactionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailyTransactionSummaryModelCopyWith<_DailyTransactionSummaryModel>
      get copyWith => __$DailyTransactionSummaryModelCopyWithImpl<
          _DailyTransactionSummaryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DailyTransactionSummaryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailyTransactionSummaryModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalIncome, totalExpense,
      const DeepCollectionEquality().hash(_transactions));

  @override
  String toString() {
    return 'DailyTransactionSummaryModel(date: $date, totalIncome: $totalIncome, totalExpense: $totalExpense, transactions: $transactions)';
  }
}

/// @nodoc
abstract mixin class _$DailyTransactionSummaryModelCopyWith<$Res>
    implements $DailyTransactionSummaryModelCopyWith<$Res> {
  factory _$DailyTransactionSummaryModelCopyWith(
          _DailyTransactionSummaryModel value,
          $Res Function(_DailyTransactionSummaryModel) _then) =
      __$DailyTransactionSummaryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String date,
      int totalIncome,
      int totalExpense,
      List<HomeTransactionModel> transactions});
}

/// @nodoc
class __$DailyTransactionSummaryModelCopyWithImpl<$Res>
    implements _$DailyTransactionSummaryModelCopyWith<$Res> {
  __$DailyTransactionSummaryModelCopyWithImpl(this._self, this._then);

  final _DailyTransactionSummaryModel _self;
  final $Res Function(_DailyTransactionSummaryModel) _then;

  /// Create a copy of DailyTransactionSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? transactions = null,
  }) {
    return _then(_DailyTransactionSummaryModel(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      transactions: null == transactions
          ? _self._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<HomeTransactionModel>,
    ));
  }
}

// dart format on
