import 'package:moamoa/features/couple/domain/entities/couple.dart';
import 'package:moamoa/features/couple/domain/repositories/couple_repository.dart';

class JoinCoupleUseCase {
  final CoupleRepository repository;

  JoinCoupleUseCase(this.repository);

  Future<Couple> call({required String inviteCode}) =>
      repository.joinCouple(inviteCode: inviteCode);
}
