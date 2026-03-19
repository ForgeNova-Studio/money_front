// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moamoa/features/terms/data/models/models.dart';

part 'terms_reconsent_state.freezed.dart';

/// 재동의가 필요한 약관 정보
@freezed
sealed class TermsReconsentItem with _$TermsReconsentItem {
  const TermsReconsentItem._();

  const factory TermsReconsentItem({
    /// 약관 문서
    required TermsDocumentModel document,

    /// 동의 여부
    @Default(false) bool agreed,
  }) = _TermsReconsentItem;
}

/// 약관 재동의 화면 상태
@freezed
sealed class TermsReconsentState with _$TermsReconsentState {
  const TermsReconsentState._();

  const factory TermsReconsentState({
    /// 재동의가 필요한 약관 목록
    @Default([]) List<TermsReconsentItem> items,

    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 제출 중 상태
    @Default(false) bool isSubmitting,

    /// 에러 메시지
    String? errorMessage,
  }) = _TermsReconsentState;

  /// 필수 약관 모두 동의 여부
  bool get allRequiredAgreed {
    final requiredItems = items.where((item) => item.document.isRequired);
    if (requiredItems.isEmpty) return true;
    return requiredItems.every((item) => item.agreed);
  }

  /// 전체 동의 여부
  bool get allAgreed {
    if (items.isEmpty) return false;
    return items.every((item) => item.agreed);
  }

  /// 재동의가 필요한 약관이 있는지 여부
  bool get hasItemsToConsent => items.isNotEmpty;
}

/// 약관 재동의 체크 결과
@freezed
sealed class TermsReconsentCheckResult with _$TermsReconsentCheckResult {
  /// 재동의 필요
  const factory TermsReconsentCheckResult.required(
    List<TermsReconsentItem> items,
  ) = TermsReconsentCheckResultRequired;

  /// 재동의 불필요
  const factory TermsReconsentCheckResult.notRequired() =
      TermsReconsentCheckResultNotRequired;

  /// 체크 실패 (에러 시 앱 진행 허용)
  const factory TermsReconsentCheckResult.error(Object error) =
      TermsReconsentCheckResultError;
}
