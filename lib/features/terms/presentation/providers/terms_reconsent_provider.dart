// packages
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:moamoa/features/common/providers/app_init_provider.dart';

// models
import 'package:moamoa/features/terms/data/models/models.dart';

// providers
import 'package:moamoa/features/terms/presentation/providers/terms_provider.dart';

// states
import 'package:moamoa/features/terms/presentation/states/terms_reconsent_state.dart';

part 'terms_reconsent_provider.g.dart';

/// 약관 재동의 ViewModel Provider
@Riverpod(keepAlive: true)
class TermsReconsentViewModel extends _$TermsReconsentViewModel {
  @override
  TermsReconsentState build() {
    return const TermsReconsentState();
  }

  /// 재동의 필요 여부 체크
  ///
  /// 앱 초기화 시 호출되어 재동의가 필요한 약관이 있는지 확인
  Future<TermsReconsentCheckResult> checkReconsentRequired() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final dataSource = ref.read(termsRemoteDataSourceProvider);

      // 활성 약관과 사용자 동의 이력 병렬 조회
      final results = await Future.wait([
        dataSource.getActiveTerms(),
        dataSource.getMyAgreements(),
      ]);

      final activeTerms = results[0] as List<TermsDocumentModel>;
      final userAgreements = results[1] as List<UserAgreementModel>;

      if (!ref.mounted) {
        return TermsReconsentCheckResult.error(
          StateError('TermsReconsentViewModel disposed'),
        );
      }

      // 재동의가 필요한 약관 필터링
      final itemsNeedingReconsent = _filterTermsNeedingReconsent(
        activeTerms,
        userAgreements,
      );

      state = state.copyWith(
        isLoading: false,
        items: itemsNeedingReconsent,
      );

      if (itemsNeedingReconsent.isEmpty) {
        if (kDebugMode) {
          debugPrint('[TermsReconsent] 재동의 불필요');
        }
        return const TermsReconsentCheckResult.notRequired();
      }

      if (kDebugMode) {
        debugPrint('[TermsReconsent] 재동의 필요: ${itemsNeedingReconsent.length}건');
        for (final item in itemsNeedingReconsent) {
          debugPrint(
              '  - ${item.document.type.displayName} v${item.document.version}');
        }
      }

      return TermsReconsentCheckResult.required(itemsNeedingReconsent);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[TermsReconsent] 체크 실패: $e');
        debugPrint(st.toString());
      }
      logStartupDebug('terms_reconsent_check_failed: $e');

      if (!ref.mounted) {
        return TermsReconsentCheckResult.error(e);
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: '약관 정보를 확인할 수 없습니다.',
      );

      // 에러 시 앱 진행 허용
      return TermsReconsentCheckResult.error(e);
    }
  }

  /// 동의가 필요한 약관 필터링
  ///
  /// 두 가지 케이스를 처리:
  /// 1. 신규 사용자: 필수 약관에 동의 이력이 전혀 없음 → 동의 필요
  /// 2. 기존 사용자: requiresReconsent == true이고 현재 버전에 동의 안 함 → 재동의 필요
  List<TermsReconsentItem> _filterTermsNeedingReconsent(
    List<TermsDocumentModel> activeTerms,
    List<UserAgreementModel> userAgreements,
  ) {
    final items = <TermsReconsentItem>[];

    for (final term in activeTerms) {
      // 필수 약관만 차단 대상 (선택 약관은 스킵)
      if (!term.isRequired) continue;

      // 해당 약관 타입에 동의한 이력이 있는지 확인 (버전 무관)
      final hasAnyAgreement = userAgreements.any(
        (agreement) => agreement.documentType == term.type && agreement.agreed,
      );

      // Case 1: 동의 이력이 전혀 없음 → 신규 사용자 (SNS 로그인 등)
      if (!hasAnyAgreement) {
        items.add(TermsReconsentItem(document: term));
        continue;
      }

      // Case 2: 동의 이력은 있지만 재동의가 필요한 약관
      if (term.requiresReconsent) {
        // 현재 버전에 동의했는지 확인
        final hasAgreedToCurrentVersion = userAgreements.any(
          (agreement) =>
              agreement.documentType == term.type &&
              agreement.documentVersion == term.version &&
              agreement.agreed,
        );

        // 현재 버전에 동의하지 않았으면 재동의 필요
        if (!hasAgreedToCurrentVersion) {
          items.add(TermsReconsentItem(document: term));
        }
      }
    }

    // 필수 약관을 먼저 정렬 (이미 필수만 추가했지만, 향후 선택 약관 추가 시 대비)
    items.sort((a, b) {
      if (a.document.isRequired && !b.document.isRequired) return -1;
      if (!a.document.isRequired && b.document.isRequired) return 1;
      return 0;
    });

    return items;
  }

  /// 개별 약관 동의 토글
  void toggleAgreement(int index) {
    if (index < 0 || index >= state.items.length) return;

    final updatedItems = List<TermsReconsentItem>.from(state.items);
    final currentItem = updatedItems[index];
    updatedItems[index] = currentItem.copyWith(agreed: !currentItem.agreed);

    state = state.copyWith(items: updatedItems);
  }

  /// 전체 동의 토글
  void toggleAllAgreements() {
    final newAgreedState = !state.allAgreed;

    final updatedItems = state.items
        .map((item) => item.copyWith(agreed: newAgreedState))
        .toList();

    state = state.copyWith(items: updatedItems);
  }

  /// 재동의 제출
  ///
  /// Returns: 성공 여부
  Future<bool> submitReconsent() async {
    if (!state.allRequiredAgreed) {
      state = state.copyWith(
        errorMessage: '필수 약관에 모두 동의해주세요.',
      );
      return false;
    }

    try {
      state = state.copyWith(isSubmitting: true, errorMessage: null);

      final dataSource = ref.read(termsRemoteDataSourceProvider);

      // 동의 요청 생성 (동의한 항목만)
      final agreements = state.items
          .where((item) => item.agreed)
          .map(
            (item) => AgreementRequestModel(
              type: item.document.type,
              version: item.document.version,
              agreed: true,
            ),
          )
          .toList();

      await dataSource.consentAgreements(agreements);

      state = state.copyWith(
        isSubmitting: false,
        items: [], // 제출 완료 후 목록 초기화
      );

      if (kDebugMode) {
        debugPrint('[TermsReconsent] 재동의 제출 완료');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[TermsReconsent] 재동의 제출 실패: $e');
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: '약관 동의 처리 중 오류가 발생했습니다. 다시 시도해주세요.',
      );

      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// 약관 재동의 필요 여부 Provider
///
/// AppInitialization에서 설정된 값을 참조
/// 재동의 완료 시 false로 변경
@Riverpod(keepAlive: true)
class TermsReconsentRequired extends _$TermsReconsentRequired {
  @override
  bool build() {
    return false;
  }

  /// 재동의 필요 여부 설정
  void setRequired(bool required) {
    state = required;
  }

  /// 재동의 완료 처리
  void markCompleted() {
    state = false;
  }
}
