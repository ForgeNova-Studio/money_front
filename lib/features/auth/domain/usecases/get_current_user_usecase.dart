import 'package:moneyflow/features/auth/domain/entities/user.dart';
import 'package:moneyflow/features/auth/domain/repositories/auth_repository.dart';

/// 현재 사용자 조회 UseCase
///
/// 현재 로그인한 사용자 정보 조회
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// 현재 사용자 조회 실행
  ///
  /// Returns: [User] 또는 null (로그인하지 않은 경우)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<User?> call() async {
    return await _repository.getCurrentUser();
  }
}
