import 'package:moamoa/features/couple/data/models/couple_model.dart';

/// 커플 Remote DataSource 인터페이스
abstract class CoupleRemoteDataSource {
  /// 현재 커플 정보 조회
  Future<CoupleModel?> getCurrentCouple();

  /// 초대 코드 생성
  Future<InviteModel> generateInviteCode();

  /// 초대 코드로 커플 가입
  Future<CoupleModel> joinCouple({required String inviteCode});

  /// 커플 연동 해제
  Future<void> unlinkCouple();
}
