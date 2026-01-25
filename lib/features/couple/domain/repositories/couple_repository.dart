import 'package:moamoa/features/couple/domain/entities/couple.dart';

/// 커플 Repository 인터페이스
abstract class CoupleRepository {
  /// 현재 커플 정보 조회
  Future<Couple?> getCurrentCouple();

  /// 초대 코드 생성
  Future<InviteInfo> generateInviteCode();

  /// 초대 코드로 커플 가입
  Future<Couple> joinCouple({required String inviteCode});

  /// 커플 연동 해제
  Future<void> unlinkCouple();
}
