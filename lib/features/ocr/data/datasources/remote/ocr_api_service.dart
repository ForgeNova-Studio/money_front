import 'package:dio/dio.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/exceptions/exceptions.dart';
import 'package:moamoa/features/ocr/domain/entities/receipt_data.dart';

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
        data: _receiptDataToJson(receiptData),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  /// ReceiptData를 JSON으로 변환 (Data Layer 책임)
  Map<String, dynamic> _receiptDataToJson(ReceiptData data) {
    return {
      'amount': data.amount,
      'date': data.date?.toIso8601String().split('T')[0],
      'merchant': data.displayName ?? data.merchant, // 정규화된 이름 우선
      'category': data.category?.code, // 백엔드 코드 전송
      'status': data.status?.name,
      'rawText': data.rawText,
      'cardIssuer': data.cardIssuer,
    };
  }
}
