import 'package:moamoa/features/couple/data/datasources/couple_remote_datasource.dart';
import 'package:moamoa/features/couple/domain/entities/couple.dart';
import 'package:moamoa/features/couple/domain/repositories/couple_repository.dart';

class CoupleRepositoryImpl implements CoupleRepository {
  final CoupleRemoteDataSource remoteDataSource;

  CoupleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Couple?> getCurrentCouple() async {
    final model = await remoteDataSource.getCurrentCouple();
    return model?.toEntity();
  }

  @override
  Future<InviteInfo> generateInviteCode() async {
    final model = await remoteDataSource.generateInviteCode();
    return model.toEntity();
  }

  @override
  Future<Couple> joinCouple({required String inviteCode}) async {
    final model = await remoteDataSource.joinCouple(inviteCode: inviteCode);
    return model.toEntity();
  }

  @override
  Future<void> unlinkCouple() async {
    await remoteDataSource.unlinkCouple();
  }
}
