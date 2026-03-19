// packages
import 'package:dio/dio.dart';

// core
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';

// models
import 'package:moamoa/features/terms/data/models/models.dart';

// datasources
import 'package:moamoa/features/terms/data/datasources/remote/terms_remote_datasource.dart';

/// Terms Remote Data Source 구현체
///
/// Dio를 사용한 API 통신 구현
class TermsRemoteDataSourceImpl implements TermsRemoteDataSource {
  final Dio dio;

  TermsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TermsDocumentModel>> getActiveTerms() async {
    try {
      final response = await dio.get(ApiConstants.termsActive);

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) =>
              TermsDocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<List<UserAgreementModel>> getMyAgreements() async {
    try {
      final response = await dio.get(ApiConstants.userAgreements);

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) =>
              UserAgreementModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> consentAgreements(List<AgreementRequestModel> agreements) async {
    try {
      await dio.post(
        ApiConstants.userAgreements,
        data: {
          'agreements': agreements.map((a) => a.toJson()).toList(),
        },
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> updateMarketingConsent(bool agreed) async {
    try {
      await dio.patch(
        ApiConstants.marketingConsent,
        data: {'agreed': agreed},
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
