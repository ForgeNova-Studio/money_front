import 'dart:io';
import 'package:moneyflow/features/ocr/domain/entities/receipt_data.dart';

/// OCR Repository 인터페이스
///
/// Clean Architecture 원칙:
/// - domain 레이어는 외부 의존성이 없어야 함
/// - 구현체는 data 레이어에 위치
abstract class OcrRepository {
  /// 이미지에서 영수증 정보 추출
  ///
  /// [imageFile] 영수증 이미지 파일
  /// Returns 파싱된 영수증 데이터 리스트
  Future<List<ReceiptData>> extractReceiptData(File imageFile);

  /// 영수증 데이터를 서버로 전송하여 지출 등록
  ///
  /// [receiptData] 파싱된 영수증 데이터
  /// Returns 서버 응답 (지출 ID 등)
  Future<Map<String, dynamic>> submitReceiptData(ReceiptData receiptData);
}
