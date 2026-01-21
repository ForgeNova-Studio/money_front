import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:moamoa/features/ocr/domain/entities/receipt_data.dart';

/// 영수증 패턴 파서 인터페이스
///
/// 각 카드사별 또는 공통 패턴을 정의하여 영수증 데이터를 추출하는 역할
abstract class ReceiptPattern {
  /// 패턴 이름 (예: "삼성카드", "현대카드", "공통패턴")
  String get name;

  /// 이 패턴이 적용 가능한지 확인
  ///
  /// [text] ML Kit로 인식한 원본 데이터 (위치 정보 포함)
  /// Returns true면 이 패턴으로 파싱 시도
  bool canParse(RecognizedText text);

  /// 텍스트에서 영수증 데이터 리스트 파싱
  ///
  /// [text] ML Kit로 인식한 원본 데이터
  /// Returns 파싱된 영수증 데이터 목록 (한 이미지에 여러 건이 있을 수 있음)
  List<ReceiptData> parse(RecognizedText text);
}
