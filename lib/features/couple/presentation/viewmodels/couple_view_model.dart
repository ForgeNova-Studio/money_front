import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/couple/domain/entities/couple.dart';
import 'package:moamoa/features/couple/presentation/providers/couple_providers.dart';

part 'couple_view_model.g.dart';

/// 커플 상태
class CoupleState {
  final Couple? couple;
  final InviteInfo? inviteInfo;
  final bool isLoading;
  final String? errorMessage;

  const CoupleState({
    this.couple,
    this.inviteInfo,
    this.isLoading = false,
    this.errorMessage,
  });

  CoupleState copyWith({
    Couple? couple,
    InviteInfo? inviteInfo,
    bool? isLoading,
    String? errorMessage,
    bool clearCouple = false,
    bool clearInviteInfo = false,
    bool clearError = false,
  }) {
    return CoupleState(
      couple: clearCouple ? null : (couple ?? this.couple),
      inviteInfo: clearInviteInfo ? null : (inviteInfo ?? this.inviteInfo),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// 커플 연동 여부
  bool get isLinked => couple?.linked ?? false;

  /// 초대 코드 유효 여부
  bool get hasValidInviteCode {
    if (inviteInfo == null) return false;
    return inviteInfo!.expiresAt.isAfter(DateTime.now());
  }
}

@riverpod
class CoupleViewModel extends _$CoupleViewModel {
  @override
  CoupleState build() {
    _loadCurrentCouple();
    return const CoupleState(isLoading: true);
  }

  /// 현재 커플 정보 로드
  Future<void> _loadCurrentCouple() async {
    try {
      final couple = await ref.read(getCurrentCoupleUseCaseProvider).call();
      if (!ref.mounted) return;
      state = state.copyWith(
        couple: couple,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 커플 정보 새로고침
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadCurrentCouple();
  }

  /// 초대 코드 생성
  Future<void> generateInviteCode() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final inviteInfo =
          await ref.read(generateInviteCodeUseCaseProvider).call();
      if (!ref.mounted) return;
      state = state.copyWith(
        inviteInfo: inviteInfo,
        isLoading: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseErrorMessage(e),
      );
    }
  }

  /// 초대 코드로 커플 가입
  Future<bool> joinCouple(String inviteCode) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final couple = await ref
          .read(joinCoupleUseCaseProvider)
          .call(inviteCode: inviteCode);
      if (!ref.mounted) return false;
      state = state.copyWith(
        couple: couple,
        isLoading: false,
        clearInviteInfo: true,
      );
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseErrorMessage(e),
      );
      return false;
    }
  }

  /// 커플 연동 해제
  Future<bool> unlinkCouple() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(unlinkCoupleUseCaseProvider).call();
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        clearCouple: true,
        clearInviteInfo: true,
      );
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseErrorMessage(e),
      );
      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 에러 메시지 파싱
  String _parseErrorMessage(dynamic error) {
    final message = error.toString();
    if (message.contains('이미 커플')) {
      return '이미 커플로 연동되어 있습니다.';
    }
    if (message.contains('초대 코드')) {
      return '유효하지 않은 초대 코드입니다.';
    }
    if (message.contains('만료')) {
      return '초대 코드가 만료되었습니다.';
    }
    return '오류가 발생했습니다. 다시 시도해주세요.';
  }
}
