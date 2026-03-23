import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/common/providers/dio_provider.dart';
import 'package:moamoa/features/search/data/datasources/remote/search_remote_datasource.dart';
import 'package:moamoa/features/search/data/repositories/search_repository_impl.dart';
import 'package:moamoa/features/search/domain/repositories/search_repository.dart';

final searchRemoteDataSourceProvider =
    Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl(dio: ref.read(dioProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.watch(searchRemoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource);
});
