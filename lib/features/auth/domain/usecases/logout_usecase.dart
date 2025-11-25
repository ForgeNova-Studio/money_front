import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 로그아웃 UseCase
///
/// 사용자 로그아웃 처리
/// - 토큰 삭제
/// - 로컬 저장소 정리
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// 로그아웃 실행
  ///
  /// Throws:
  /// - [StorageException] 로컬 저장소 오류
  Future<void> call() async {
    await _repository.logout();
  }
}
