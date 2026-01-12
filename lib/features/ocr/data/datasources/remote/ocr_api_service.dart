import 'package:dio/dio.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/ocr/domain/entities/receipt_data.dart';

/// OCR API 서비스
///
/// 기능:
/// - 프론트에서 파싱한 영수증 데이터를 백엔드로 전송
/// - 백엔드에서 카테고리 자동 분류 및 지출 정보 생성
class OcrApiService {
  final Dio dio;

  OcrApiService({required this.dio});

  /// 파싱된 영수증 데이터를 백엔드로 전송
  ///
  /// [receiptData] 프론트에서 ML Kit + 패턴으로 파싱한 영수증 데이터
  /// Returns 백엔드에서 카테고리 분류 및 생성된 지출 정보
  Future<Map<String, dynamic>> createExpenseFromReceipt(
    ReceiptData receiptData,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.expensesOcr,
        data: receiptData.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
