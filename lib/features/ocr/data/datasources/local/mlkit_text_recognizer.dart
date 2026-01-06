import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// ML Kit Text Recognition DataSource
///
/// 책임: ML Kit을 사용한 텍스트 인식만 담당
/// - 이미지 → RecognizedText 변환
/// - ML Kit 리소스 관리
class MlkitTextRecognizer {
  // TextRecognizer - ML Kit이 모든 언어를 자동 감지 (한글 포함)
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
  final _logger = Logger(level: kDebugMode ? Level.debug : Level.nothing);

  /// 이미지 파일에서 텍스트 인식
  ///
  /// [imageFile] 인식할 이미지 파일 (전처리 완료된 상태)
  /// Returns ML Kit RecognizedText 객체 (위치 정보 포함)
  Future<RecognizedText> recognizeText(File imageFile) async {
    try {
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('🔍 ML Kit 텍스트 인식 시작...');
      _logger.d('📂 파일: ${imageFile.path}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      _logger.i('✅ 텍스트 인식 완료');
      _logger.d('   블록 수: ${recognizedText.blocks.length}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      if (recognizedText.blocks.isEmpty) {
        _logger.w('⚠️ 인식된 텍스트 블록이 없습니다');
      }

      return recognizedText;
    } catch (e, stackTrace) {
      _logger.e('ML Kit 텍스트 인식 실패', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 리소스 정리
  void dispose() {
    _textRecognizer.close();
    _logger.d('ML Kit TextRecognizer 종료');
  }
}
