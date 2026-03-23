// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResponseModel {
  List<SearchTransactionModel> get transactions;
  int get totalCount;
  bool get hasNext;

  /// Create a copy of SearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchResponseModelCopyWith<SearchResponseModel> get copyWith =>
      _$SearchResponseModelCopyWithImpl<SearchResponseModel>(
          this as SearchResponseModel, _$identity);

  /// Serializes this SearchResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchResponseModel &&
            const DeepCollectionEquality()
                .equals(other.transactions, transactions) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(transactions), totalCount, hasNext);

  @override
  String toString() {
    return 'SearchResponseModel(transactions: $transactions, totalCount: $totalCount, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class $SearchResponseModelCopyWith<$Res> {
  factory $SearchResponseModelCopyWith(
          SearchResponseModel value, $Res Function(SearchResponseModel) _then) =
      _$SearchResponseModelCopyWithImpl;
  @useResult
  $Res call(
      {List<SearchTransactionModel> transactions,
      int totalCount,
      bool hasNext});
}

/// @nodoc
class _$SearchResponseModelCopyWithImpl<$Res>
    implements $SearchResponseModelCopyWith<$Res> {
  _$SearchResponseModelCopyWithImpl(this._self, this._then);

  final SearchResponseModel _self;
  final $Res Function(SearchResponseModel) _then;

  /// Create a copy of SearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? totalCount = null,
    Object? hasNext = null,
  }) {
    return _then(_self.copyWith(
      transactions: null == transactions
          ? _self.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<SearchTransactionModel>,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SearchResponseModel].
extension SearchResponseModelPatterns on SearchResponseModel {
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
    TResult Function(_SearchResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchResponseModel() when $default != null:
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
    TResult Function(_SearchResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResponseModel():
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
    TResult? Function(_SearchResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResponseModel() when $default != null:
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
    TResult Function(List<SearchTransactionModel> transactions, int totalCount,
            bool hasNext)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchResponseModel() when $default != null:
        return $default(_that.transactions, _that.totalCount, _that.hasNext);
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
    TResult Function(List<SearchTransactionModel> transactions, int totalCount,
            bool hasNext)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResponseModel():
        return $default(_that.transactions, _that.totalCount, _that.hasNext);
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
    TResult? Function(List<SearchTransactionModel> transactions, int totalCount,
            bool hasNext)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResponseModel() when $default != null:
        return $default(_that.transactions, _that.totalCount, _that.hasNext);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SearchResponseModel extends SearchResponseModel {
  const _SearchResponseModel(
      {required final List<SearchTransactionModel> transactions,
      required this.totalCount,
      required this.hasNext})
      : _transactions = transactions,
        super._();
  factory _SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  final List<SearchTransactionModel> _transactions;
  @override
  List<SearchTransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final int totalCount;
  @override
  final bool hasNext;

  /// Create a copy of SearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchResponseModelCopyWith<_SearchResponseModel> get copyWith =>
      __$SearchResponseModelCopyWithImpl<_SearchResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchResponseModel &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_transactions), totalCount, hasNext);

  @override
  String toString() {
    return 'SearchResponseModel(transactions: $transactions, totalCount: $totalCount, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class _$SearchResponseModelCopyWith<$Res>
    implements $SearchResponseModelCopyWith<$Res> {
  factory _$SearchResponseModelCopyWith(_SearchResponseModel value,
          $Res Function(_SearchResponseModel) _then) =
      __$SearchResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<SearchTransactionModel> transactions,
      int totalCount,
      bool hasNext});
}

/// @nodoc
class __$SearchResponseModelCopyWithImpl<$Res>
    implements _$SearchResponseModelCopyWith<$Res> {
  __$SearchResponseModelCopyWithImpl(this._self, this._then);

  final _SearchResponseModel _self;
  final $Res Function(_SearchResponseModel) _then;

  /// Create a copy of SearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? transactions = null,
    Object? totalCount = null,
    Object? hasNext = null,
  }) {
    return _then(_SearchResponseModel(
      transactions: null == transactions
          ? _self._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<SearchTransactionModel>,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$SearchTransactionModel {
  String get id;
  String get type; // "INCOME" | "EXPENSE"
  int get amount;
  String get title;
  String get category;
  String? get memo;
  String get date; // "yyyy-MM-dd"
  String get time;

  /// Create a copy of SearchTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchTransactionModelCopyWith<SearchTransactionModel> get copyWith =>
      _$SearchTransactionModelCopyWithImpl<SearchTransactionModel>(
          this as SearchTransactionModel, _$identity);

  /// Serializes this SearchTransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, amount, title, category, memo, date, time);

  @override
  String toString() {
    return 'SearchTransactionModel(id: $id, type: $type, amount: $amount, title: $title, category: $category, memo: $memo, date: $date, time: $time)';
  }
}

/// @nodoc
abstract mixin class $SearchTransactionModelCopyWith<$Res> {
  factory $SearchTransactionModelCopyWith(SearchTransactionModel value,
          $Res Function(SearchTransactionModel) _then) =
      _$SearchTransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String type,
      int amount,
      String title,
      String category,
      String? memo,
      String date,
      String time});
}

/// @nodoc
class _$SearchTransactionModelCopyWithImpl<$Res>
    implements $SearchTransactionModelCopyWith<$Res> {
  _$SearchTransactionModelCopyWithImpl(this._self, this._then);

  final SearchTransactionModel _self;
  final $Res Function(SearchTransactionModel) _then;

  /// Create a copy of SearchTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? title = null,
    Object? category = null,
    Object? memo = freezed,
    Object? date = null,
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
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SearchTransactionModel].
extension SearchTransactionModelPatterns on SearchTransactionModel {
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
    TResult Function(_SearchTransactionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchTransactionModel() when $default != null:
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
    TResult Function(_SearchTransactionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchTransactionModel():
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
    TResult? Function(_SearchTransactionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchTransactionModel() when $default != null:
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
            String category, String? memo, String date, String time)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchTransactionModel() when $default != null:
        return $default(_that.id, _that.type, _that.amount, _that.title,
            _that.category, _that.memo, _that.date, _that.time);
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
            String category, String? memo, String date, String time)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchTransactionModel():
        return $default(_that.id, _that.type, _that.amount, _that.title,
            _that.category, _that.memo, _that.date, _that.time);
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
            String category, String? memo, String date, String time)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchTransactionModel() when $default != null:
        return $default(_that.id, _that.type, _that.amount, _that.title,
            _that.category, _that.memo, _that.date, _that.time);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SearchTransactionModel extends SearchTransactionModel {
  const _SearchTransactionModel(
      {required this.id,
      required this.type,
      required this.amount,
      required this.title,
      required this.category,
      this.memo,
      required this.date,
      required this.time})
      : super._();
  factory _SearchTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchTransactionModelFromJson(json);

  @override
  final String id;
  @override
  final String type;
// "INCOME" | "EXPENSE"
  @override
  final int amount;
  @override
  final String title;
  @override
  final String category;
  @override
  final String? memo;
  @override
  final String date;
// "yyyy-MM-dd"
  @override
  final String time;

  /// Create a copy of SearchTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchTransactionModelCopyWith<_SearchTransactionModel> get copyWith =>
      __$SearchTransactionModelCopyWithImpl<_SearchTransactionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchTransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, amount, title, category, memo, date, time);

  @override
  String toString() {
    return 'SearchTransactionModel(id: $id, type: $type, amount: $amount, title: $title, category: $category, memo: $memo, date: $date, time: $time)';
  }
}

/// @nodoc
abstract mixin class _$SearchTransactionModelCopyWith<$Res>
    implements $SearchTransactionModelCopyWith<$Res> {
  factory _$SearchTransactionModelCopyWith(_SearchTransactionModel value,
          $Res Function(_SearchTransactionModel) _then) =
      __$SearchTransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      int amount,
      String title,
      String category,
      String? memo,
      String date,
      String time});
}

/// @nodoc
class __$SearchTransactionModelCopyWithImpl<$Res>
    implements _$SearchTransactionModelCopyWith<$Res> {
  __$SearchTransactionModelCopyWithImpl(this._self, this._then);

  final _SearchTransactionModel _self;
  final $Res Function(_SearchTransactionModel) _then;

  /// Create a copy of SearchTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? title = null,
    Object? category = null,
    Object? memo = freezed,
    Object? date = null,
    Object? time = null,
  }) {
    return _then(_SearchTransactionModel(
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
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
