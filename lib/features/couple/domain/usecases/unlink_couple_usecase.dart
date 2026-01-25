import 'package:moamoa/features/couple/domain/repositories/couple_repository.dart';

class UnlinkCoupleUseCase {
  final CoupleRepository repository;

  UnlinkCoupleUseCase(this.repository);

  Future<void> call() => repository.unlinkCouple();
}
