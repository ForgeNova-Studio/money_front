// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortcuts_guide_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShortcutsGuideState {
  /// 현재 단계 (0-indexed)
  int get currentStep;

  /// 총 단계 수
  int get totalSteps;

  /// 선택된 카드사 목록
  List<String> get selectedCardCompanyIds;

  /// 설정 완료 여부
  bool get isSetupComplete;

  /// 로딩 상태
  bool get isLoading;

  /// 에러 메시지
  String? get errorMessage;

  /// Create a copy of ShortcutsGuideState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShortcutsGuideStateCopyWith<ShortcutsGuideState> get copyWith =>
      _$ShortcutsGuideStateCopyWithImpl<ShortcutsGuideState>(
          this as ShortcutsGuideState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShortcutsGuideState &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            const DeepCollectionEquality()
                .equals(other.selectedCardCompanyIds, selectedCardCompanyIds) &&
            (identical(other.isSetupComplete, isSetupComplete) ||
                other.isSetupComplete == isSetupComplete) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentStep,
      totalSteps,
      const DeepCollectionEquality().hash(selectedCardCompanyIds),
      isSetupComplete,
      isLoading,
      errorMessage);

  @override
  String toString() {
    return 'ShortcutsGuideState(currentStep: $currentStep, totalSteps: $totalSteps, selectedCardCompanyIds: $selectedCardCompanyIds, isSetupComplete: $isSetupComplete, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ShortcutsGuideStateCopyWith<$Res> {
  factory $ShortcutsGuideStateCopyWith(
          ShortcutsGuideState value, $Res Function(ShortcutsGuideState) _then) =
      _$ShortcutsGuideStateCopyWithImpl;
  @useResult
  $Res call(
      {int currentStep,
      int totalSteps,
      List<String> selectedCardCompanyIds,
      bool isSetupComplete,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$ShortcutsGuideStateCopyWithImpl<$Res>
    implements $ShortcutsGuideStateCopyWith<$Res> {
  _$ShortcutsGuideStateCopyWithImpl(this._self, this._then);

  final ShortcutsGuideState _self;
  final $Res Function(ShortcutsGuideState) _then;

  /// Create a copy of ShortcutsGuideState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? totalSteps = null,
    Object? selectedCardCompanyIds = null,
    Object? isSetupComplete = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      currentStep: null == currentStep
          ? _self.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _self.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      selectedCardCompanyIds: null == selectedCardCompanyIds
          ? _self.selectedCardCompanyIds
          : selectedCardCompanyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSetupComplete: null == isSetupComplete
          ? _self.isSetupComplete
          : isSetupComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShortcutsGuideState].
extension ShortcutsGuideStatePatterns on ShortcutsGuideState {
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
    TResult Function(_ShortcutsGuideState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShortcutsGuideState() when $default != null:
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
    TResult Function(_ShortcutsGuideState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortcutsGuideState():
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
    TResult? Function(_ShortcutsGuideState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortcutsGuideState() when $default != null:
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
            int currentStep,
            int totalSteps,
            List<String> selectedCardCompanyIds,
            bool isSetupComplete,
            bool isLoading,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShortcutsGuideState() when $default != null:
        return $default(
            _that.currentStep,
            _that.totalSteps,
            _that.selectedCardCompanyIds,
            _that.isSetupComplete,
            _that.isLoading,
            _that.errorMessage);
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
            int currentStep,
            int totalSteps,
            List<String> selectedCardCompanyIds,
            bool isSetupComplete,
            bool isLoading,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortcutsGuideState():
        return $default(
            _that.currentStep,
            _that.totalSteps,
            _that.selectedCardCompanyIds,
            _that.isSetupComplete,
            _that.isLoading,
            _that.errorMessage);
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
            int currentStep,
            int totalSteps,
            List<String> selectedCardCompanyIds,
            bool isSetupComplete,
            bool isLoading,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortcutsGuideState() when $default != null:
        return $default(
            _that.currentStep,
            _that.totalSteps,
            _that.selectedCardCompanyIds,
            _that.isSetupComplete,
            _that.isLoading,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ShortcutsGuideState extends ShortcutsGuideState {
  const _ShortcutsGuideState(
      {this.currentStep = 0,
      this.totalSteps = 4,
      final List<String> selectedCardCompanyIds = const [],
      this.isSetupComplete = false,
      this.isLoading = false,
      this.errorMessage})
      : _selectedCardCompanyIds = selectedCardCompanyIds,
        super._();

  /// 현재 단계 (0-indexed)
  @override
  @JsonKey()
  final int currentStep;

  /// 총 단계 수
  @override
  @JsonKey()
  final int totalSteps;

  /// 선택된 카드사 목록
  final List<String> _selectedCardCompanyIds;

  /// 선택된 카드사 목록
  @override
  @JsonKey()
  List<String> get selectedCardCompanyIds {
    if (_selectedCardCompanyIds is EqualUnmodifiableListView)
      return _selectedCardCompanyIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCardCompanyIds);
  }

  /// 설정 완료 여부
  @override
  @JsonKey()
  final bool isSetupComplete;

  /// 로딩 상태
  @override
  @JsonKey()
  final bool isLoading;

  /// 에러 메시지
  @override
  final String? errorMessage;

  /// Create a copy of ShortcutsGuideState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShortcutsGuideStateCopyWith<_ShortcutsGuideState> get copyWith =>
      __$ShortcutsGuideStateCopyWithImpl<_ShortcutsGuideState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShortcutsGuideState &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            const DeepCollectionEquality().equals(
                other._selectedCardCompanyIds, _selectedCardCompanyIds) &&
            (identical(other.isSetupComplete, isSetupComplete) ||
                other.isSetupComplete == isSetupComplete) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentStep,
      totalSteps,
      const DeepCollectionEquality().hash(_selectedCardCompanyIds),
      isSetupComplete,
      isLoading,
      errorMessage);

  @override
  String toString() {
    return 'ShortcutsGuideState(currentStep: $currentStep, totalSteps: $totalSteps, selectedCardCompanyIds: $selectedCardCompanyIds, isSetupComplete: $isSetupComplete, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ShortcutsGuideStateCopyWith<$Res>
    implements $ShortcutsGuideStateCopyWith<$Res> {
  factory _$ShortcutsGuideStateCopyWith(_ShortcutsGuideState value,
          $Res Function(_ShortcutsGuideState) _then) =
      __$ShortcutsGuideStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int currentStep,
      int totalSteps,
      List<String> selectedCardCompanyIds,
      bool isSetupComplete,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$ShortcutsGuideStateCopyWithImpl<$Res>
    implements _$ShortcutsGuideStateCopyWith<$Res> {
  __$ShortcutsGuideStateCopyWithImpl(this._self, this._then);

  final _ShortcutsGuideState _self;
  final $Res Function(_ShortcutsGuideState) _then;

  /// Create a copy of ShortcutsGuideState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentStep = null,
    Object? totalSteps = null,
    Object? selectedCardCompanyIds = null,
    Object? isSetupComplete = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_ShortcutsGuideState(
      currentStep: null == currentStep
          ? _self.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _self.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      selectedCardCompanyIds: null == selectedCardCompanyIds
          ? _self._selectedCardCompanyIds
          : selectedCardCompanyIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSetupComplete: null == isSetupComplete
          ? _self.isSetupComplete
          : isSetupComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
