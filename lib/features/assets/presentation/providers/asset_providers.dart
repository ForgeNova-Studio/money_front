import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/assets/data/datasources/remote/asset_remote_datasource.dart';
import 'package:moamoa/features/assets/data/datasources/remote/asset_remote_datasource_impl.dart';
import 'package:moamoa/features/assets/data/repositories/asset_repository_impl.dart';
import 'package:moamoa/features/assets/domain/repositories/asset_repository.dart';
import 'package:moamoa/features/common/providers/dio_provider.dart';

final assetRemoteDataSourceProvider = Provider<AssetRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AssetRemoteDataSourceImpl(dio: dio);
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  final remoteDataSource = ref.watch(assetRemoteDataSourceProvider);
  return AssetRepositoryImpl(remoteDataSource: remoteDataSource);
});

