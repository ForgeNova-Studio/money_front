import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exception_handler.dart';
import 'package:moamoa/features/assets/data/datasources/remote/asset_remote_datasource.dart';
import 'package:moamoa/features/assets/data/models/asset_models.dart';

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final Dio dio;

  AssetRemoteDataSourceImpl({required this.dio});

  @override
  Future<AssetSummaryResponseModel> getAssetSummary() async {
    try {
      final response = await dio.get(ApiConstants.assetsSummary);
      return AssetSummaryResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[AssetRemoteDataSource] getAssetSummary error: $e');
        debugPrint('[AssetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<AssetResponseModel> createAsset({
    required String name,
    required String category,
    required int amount,
    String? memo,
    String? accountBookId,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'category': category,
        'amount': amount,
      };
      if (memo != null && memo.isNotEmpty) data['memo'] = memo;
      if (accountBookId != null && accountBookId.isNotEmpty) {
        data['accountBookId'] = accountBookId;
      }

      final response = await dio.post(
        ApiConstants.assets,
        data: data,
      );
      return AssetResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[AssetRemoteDataSource] createAsset error: $e');
        debugPrint('[AssetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<AssetResponseModel> updateAsset({
    required String assetId,
    required String name,
    required String category,
    required int amount,
    String? memo,
    String? accountBookId,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'category': category,
        'amount': amount,
      };
      if (memo != null) data['memo'] = memo;
      if (accountBookId != null && accountBookId.isNotEmpty) {
        data['accountBookId'] = accountBookId;
      }

      final response = await dio.put(
        ApiConstants.assetById(assetId),
        data: data,
      );
      return AssetResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[AssetRemoteDataSource] updateAsset error: $e');
        debugPrint('[AssetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteAsset(String assetId) async {
    try {
      await dio.delete(ApiConstants.assetById(assetId));
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[AssetRemoteDataSource] deleteAsset error: $e');
        debugPrint('[AssetRemoteDataSource] Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
}

