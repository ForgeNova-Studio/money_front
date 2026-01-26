// datasources
import 'package:moamoa/features/couple/data/datasources/couple_remote_datasource.dart';
import 'package:moamoa/features/couple/data/datasources/couple_remote_datasource_impl.dart';

// repositories
import 'package:moamoa/features/couple/data/repositories/couple_repository_impl.dart';
import 'package:moamoa/features/couple/domain/repositories/couple_repository.dart';

// entities
import 'package:moamoa/features/couple/domain/entities/couple.dart';

// usecases
import 'package:moamoa/features/couple/domain/usecases/generate_invite_code_usecase.dart';
import 'package:moamoa/features/couple/domain/usecases/get_current_couple_usecase.dart';
import 'package:moamoa/features/couple/domain/usecases/join_couple_usecase.dart';
import 'package:moamoa/features/couple/domain/usecases/unlink_couple_usecase.dart';

// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// providers
import 'package:moamoa/features/common/providers/core_providers.dart';

part 'couple_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================
@riverpod
CoupleRemoteDataSource coupleRemoteDataSource(Ref ref) {
  return CoupleRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================
@riverpod
CoupleRepository coupleRepository(Ref ref) {
  return CoupleRepositoryImpl(ref.read(coupleRemoteDataSourceProvider));
}

// ============================================================================
// UseCase Providers
// ============================================================================
@riverpod
GetCurrentCoupleUseCase getCurrentCoupleUseCase(Ref ref) {
  return GetCurrentCoupleUseCase(ref.read(coupleRepositoryProvider));
}

@riverpod
GenerateInviteCodeUseCase generateInviteCodeUseCase(Ref ref) {
  return GenerateInviteCodeUseCase(ref.read(coupleRepositoryProvider));
}

@riverpod
JoinCoupleUseCase joinCoupleUseCase(Ref ref) {
  return JoinCoupleUseCase(ref.read(coupleRepositoryProvider));
}

@riverpod
UnlinkCoupleUseCase unlinkCoupleUseCase(Ref ref) {
  return UnlinkCoupleUseCase(ref.read(coupleRepositoryProvider));
}

// ============================================================================
// State Providers
// ============================================================================

/// 현재 커플 정보 (캐싱 가능)
@riverpod
Future<Couple?> currentCouple(Ref ref) async {
  return ref.read(getCurrentCoupleUseCaseProvider).call();
}
