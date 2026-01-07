import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ImagePreprocessor {
  final _logger = Logger(level: kDebugMode ? Level.debug : Level.nothing);

  /// OCR용 이미지 전처리 (비동기 + 격리 스레드 실행)
  ///
  /// [imageFile] 원본 이미지 (은행앱 화면 캡처)
  /// Returns 전처리된 이미지 파일
  Future<File> preprocessForOcr(File imageFile) async {
    try {
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('🔧 이미지 전처리 시작 (Isolate 위임)');
      _logger.d('📂 파일 경로: ${imageFile.path}');

      // ⚠️ 핵심 변경 1: 메인 스레드 차단 방지를 위해 `compute` 사용
      // 무거운 이미지 연산 작업을 백그라운드로 보냄
      final String? processedPath = await compute(_processInIsolate, imageFile.path);

      if (processedPath == null) {
        throw Exception('전처리 과정에서 오류 발생 (null 반환)');
      }

      final resultFile = File(processedPath);
      _logger.i('✅ 전처리 완료: ${resultFile.path}');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return resultFile;

    } catch (e, stackTrace) {
      _logger.e('이미지 전처리 실패 - 원본을 그대로 반환합니다.', error: e, stackTrace: stackTrace);
      return imageFile; // 실패 시 안전하게 원본 반환
    }
  }

  /// 🔒 Isolate(별도 스레드) 내부에서 실행되는 함수
  /// 메인 스레드의 메모리와 분리되어 있으며, static이어야 함.
  static Future<String?> _processInIsolate(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      // ---------------------------------------------------------
      // ⚠️ 핵심 변경 2: 스크롤 캡처(Long Screenshot) 방어 로직
      // 무조건 2배 확대는 위험함 (세로 10,000px 넘어가면 메모리 터짐)
      // ---------------------------------------------------------

      const int targetWidth = 1440;       // OCR이 인식하기 좋은 가로 폭
      const int maxTotalPixels = 1440 * 6000; // 메모리 보호를 위한 픽셀 총량 제한 (약 8.6 MP)

      double scale = 1.0;
      int currentPixels = image.width * image.height;

      if (currentPixels > maxTotalPixels) {
        // 1. 이미지가 너무 거대한 경우 (스크롤 캡처) -> 확대 금지 & 필요시 축소
        // 메모리 폭발 방지가 최우선
        if (image.width > targetWidth) {
          scale = targetWidth / image.width; // 가로를 targetWidth로 맞춤
        } else {
          scale = 1.0; // 가로는 작은데 세로가 엄청 긴 경우 (그대로 둠)
        }
      } else {
        // 2. 적당한 크기거나 작은 경우 -> 가로 폭을 기준으로 확대
        if (image.width < targetWidth) {
          scale = targetWidth / image.width;
        }
      }

      // 리사이징 수행 (변화가 있을 때만)
      if (scale != 1.0) {
        image = img.copyResize(
          image,
          width: (image.width * scale).toInt(),
          // height는 비율에 맞춰 자동 조절되거나 명시
          height: (image.height * scale).toInt(),
          interpolation: img.Interpolation.linear, // 속도와 화질의 타협점
        );
      }

      // ---------------------------------------------------------
      // 3. 다크 모드 감지 (기존 로직 유지하되 최적화)
      // ---------------------------------------------------------
      final thumb = img.copyResize(image, width: 50);
      double totalLum = 0;
      for (var p in thumb) {
        totalLum += p.luminanceNormalized;
      }

      // 평균 밝기가 0.5 미만이면 다크 모드
      bool isDarkMode = (thumb.isNotEmpty) && (totalLum / thumb.length < 0.5);

      if (isDarkMode) {
        img.invert(image); // 반전
      }

      // ---------------------------------------------------------
      // 4. 그레이스케일 & 대비 보정
      // ---------------------------------------------------------
      img.grayscale(image);

      // 은행 앱 폰트가 얇은 경우가 많으므로 대비를 살짝 높임 (1.1배)
      img.adjustColor(image, contrast: 1.1);

      // ---------------------------------------------------------
      // 5. 저장
      // Isolate 내에서는 path_provider 등 플러그인 사용이 불안정할 수 있음
      // 원본 경로를 기반으로 접미사를 붙여 저장
      // ---------------------------------------------------------
      final newPath = filePath.replaceAll(RegExp(r'\.\w+$'), '_processed.jpg');

      // JPG 품질 90 (속도 및 용량 최적화)
      await File(newPath).writeAsBytes(img.encodeJpg(image, quality: 90));

      return newPath;

    } catch (e) {
      // Isolate 내부 에러는 콘솔에만 찍고 null 반환
      debugPrint('Isolate Processing Error: $e');
      return null;
    }
  }
}
