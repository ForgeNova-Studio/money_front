// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:moamoa/features/common/providers/dio_provider.dart';

// models
import 'package:moamoa/features/terms/data/models/models.dart';

// datasources
import 'package:moamoa/features/terms/data/datasources/remote/terms_remote_datasource.dart';
import 'package:moamoa/features/terms/data/datasources/remote/terms_remote_datasource_impl.dart';

part 'terms_provider.g.dart';

/// Terms Remote Data Source Provider
@riverpod
TermsRemoteDataSource termsRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return TermsRemoteDataSourceImpl(dio: dio);
}

/// 현재 유효한 약관 목록 조회 Provider
@riverpod
Future<List<TermsDocumentModel>> getActiveTerms(Ref ref) async {
  final dataSource = ref.watch(termsRemoteDataSourceProvider);
  return dataSource.getActiveTerms();
}

/// 내 약관 동의 이력 조회 Provider
@riverpod
Future<List<UserAgreementModel>> getMyAgreements(Ref ref) async {
  final dataSource = ref.watch(termsRemoteDataSourceProvider);
  return dataSource.getMyAgreements();
}
