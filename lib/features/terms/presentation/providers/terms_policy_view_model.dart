// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// datasources
import 'package:moamoa/features/terms/presentation/providers/terms_provider.dart';

part 'terms_policy_view_model.g.dart';

/// 약관 및 정책 화면 상태
class TermsPolicyState {
  final bool isMarketingAgreed;
  final bool isUpdating;
  final bool isInitialized;
  final String? errorMessage;

  const TermsPolicyState({
    this.isMarketingAgreed = false,
    this.isUpdating = false,
    this.isInitialized = false,
    this.errorMessage,
  });

  TermsPolicyState copyWith({
    bool? isMarketingAgreed,
    bool? isUpdating,
    bool? isInitialized,
    String? errorMessage,
  }) {
    return TermsPolicyState(
      isMarketingAgreed: isMarketingAgreed ?? this.isMarketingAgreed,
      isUpdating: isUpdating ?? this.isUpdating,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage,
    );
  }
}

/// 약관 및 정책 ViewModel
@riverpod
class TermsPolicyViewModel extends _$TermsPolicyViewModel {
  @override
  TermsPolicyState build() {
    return const TermsPolicyState();
  }

  /// 초기 상태 설정
  void initialize(bool isMarketingAgreed) {
    if (state.isInitialized) return;

    state = state.copyWith(
      isMarketingAgreed: isMarketingAgreed,
      isInitialized: true,
    );
  }

  /// 마케팅 수신 동의 변경
  Future<void> updateMarketingConsent(bool agreed) async {
    if (state.isUpdating) return;

    state = state.copyWith(isUpdating: true, errorMessage: null);

    try {
      final dataSource = ref.read(termsRemoteDataSourceProvider);
      await dataSource.updateMarketingConsent(agreed);

      state = state.copyWith(
        isMarketingAgreed: agreed,
        isUpdating: false,
      );

      // 동의 이력 캐시 무효화
      ref.invalidate(getMyAgreementsProvider);
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}
