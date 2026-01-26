import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/couple/presentation/providers/couple_providers.dart';
import 'package:moamoa/features/couple/presentation/states/couple_state.dart';

// CoupleState를 외부에서 접근할 수 있도록 re-export
export 'package:moamoa/features/couple/presentation/states/couple_state.dart';

part 'couple_view_model.g.dart';

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
        errorMessage: null,
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
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _loadCurrentCouple();
  }

  /// 초대 코드 생성
  Future<void> generateInviteCode() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
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
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final couple = await ref
          .read(joinCoupleUseCaseProvider)
          .call(inviteCode: inviteCode);
      if (!ref.mounted) return false;
      state = state.copyWith(
        couple: couple,
        isLoading: false,
        inviteInfo: null,
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
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(unlinkCoupleUseCaseProvider).call();
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        couple: null,
        inviteInfo: null,
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
    state = state.copyWith(errorMessage: null);
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
