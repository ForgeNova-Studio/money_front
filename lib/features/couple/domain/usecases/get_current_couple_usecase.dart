import 'package:moamoa/features/couple/domain/entities/couple.dart';
import 'package:moamoa/features/couple/domain/repositories/couple_repository.dart';

class GetCurrentCoupleUseCase {
  final CoupleRepository repository;

  GetCurrentCoupleUseCase(this.repository);

  Future<Couple?> call() => repository.getCurrentCouple();
}
