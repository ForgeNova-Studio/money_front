import 'package:moamoa/features/couple/domain/entities/couple.dart';
import 'package:moamoa/features/couple/domain/repositories/couple_repository.dart';

class GenerateInviteCodeUseCase {
  final CoupleRepository repository;

  GenerateInviteCodeUseCase(this.repository);

  Future<InviteInfo> call() => repository.generateInviteCode();
}
