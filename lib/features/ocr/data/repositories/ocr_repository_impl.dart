import 'dart:io';
import 'package:logger/logger.dart';
import 'package:moamoa/features/ocr/domain/entities/receipt_data.dart';
import 'package:moamoa/features/ocr/domain/entities/category.dart';
import 'package:moamoa/features/ocr/domain/repositories/ocr_repository.dart';
import 'package:moamoa/features/ocr/domain/patterns/receipt_pattern.dart';
import 'package:moamoa/features/ocr/domain/strategies/brand_match_strategy.dart';
import 'package:moamoa/features/ocr/data/datasources/local/image_preprocessor.dart';
import 'package:moamoa/features/ocr/data/datasources/local/mlkit_text_recognizer.dart';
import 'package:moamoa/features/ocr/data/parser/receipt_pattern_factory.dart';
import 'package:moamoa/features/ocr/data/utils/date_corrector.dart';
import 'package:moamoa/features/ocr/data/datasources/remote/ocr_api_service.dart';

/// OCR Repository 구현체
///
/// 책임:
/// - 이미지 전처리 조율
/// - ML Kit OCR 실행 조율
/// - 패턴 파서 관리 및 실행
/// - 브랜드 매칭 및 카테고리 자동 분류 (Strategy Pattern)
/// - 결제 내역 리스트용 중복 제거 (Deduplication)
/// - 서버 API 호출
class OcrRepositoryImpl implements OcrRepository {
  final ImagePreprocessor _preprocessor;
  final MlkitTextRecognizer _textRecognizer;
  final BrandMatchStrategy _brandStrategy;
  final OcrApiService _apiService;
  final _logger = Logger();
  final _dateCorrector = DateCorrector();

  /// 패턴 팩토리 인스턴스
  final ReceiptPatternFactory _patternFactory = ReceiptPatternFactory.instance;

  OcrRepositoryImpl({
    ImagePreprocessor? preprocessor,
    MlkitTextRecognizer? textRecognizer,
    required BrandMatchStrategy brandStrategy,
    required OcrApiService apiService,
  })  : _preprocessor = preprocessor ?? ImagePreprocessor(),
        _textRecognizer = textRecognizer ?? MlkitTextRecognizer(),
        _brandStrategy = brandStrategy,
        _apiService = apiService;

  @override
  Future<List<ReceiptData>> extractReceiptData(
    File imageFile, {
    String? cardIssuerId,
  }) async {
    try {
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('📸 OCR 처리 시작');
      _logger.d('   파일: ${imageFile.path}');
      if (cardIssuerId != null) {
        _logger.d('   카드사: $cardIssuerId');
      }
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // 1. 이미지 전처리 (다크모드 반전, 2배 확대 등)
      final preprocessedFile = await _preprocessor.preprocessForOcr(imageFile);

      // 2. ML Kit으로 텍스트 인식
      final recognizedText =
          await _textRecognizer.recognizeText(preprocessedFile);

      // 전처리된 이미지 정리
      if (preprocessedFile.path != imageFile.path) {
        try {
          await preprocessedFile.delete();
        } catch (e) {
          _logger.w('전처리 이미지 삭제 실패: $e');
        }
      }

      if (recognizedText.blocks.isEmpty) {
        _logger.w('⚠️ 인식된 텍스트가 없습니다');
        return [];
      }

      // 3. 패턴 선택
      ReceiptPattern selectedPattern;

      if (cardIssuerId != null && cardIssuerId.isNotEmpty) {
        // 카드사 ID가 지정된 경우 해당 패턴 사용
        selectedPattern = _patternFactory.getPatternByCardId(cardIssuerId);
        _logger.i('✅ 카드사 패턴 사용: ${selectedPattern.name}');
      } else {
        // 카드사 ID가 없으면 텍스트에서 자동 감지
        final fullText = recognizedText.blocks.map((b) => b.text).join(' ');
        selectedPattern = _patternFactory.detectPattern(fullText);
        _logger.i('✅ 자동 감지 패턴: ${selectedPattern.name}');
      }

      // 4. 패턴으로 파싱
      final rawResults = selectedPattern.parse(recognizedText);

      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i('✅ 1차 파싱 완료: ${rawResults.length}건 추출');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // 5. ⭐ 날짜 보정 (OCR 인식 오류 자동 수정)
      final dateCorrectedResults = _dateCorrector.correctDates(rawResults);

      // 6. ⭐ 브랜드 매칭 & 중복 제거 & 지점명 추출
      // 중복 제거를 위한 Map (Key: "상호명_금액_날짜")
      final uniqueMap = <String, ReceiptData>{};

      for (var i = 0; i < dateCorrectedResults.length; i++) {
        final rawData = dateCorrectedResults[i];
        final rawMerchant = rawData.merchant ?? '';

        _logger
            .d('   [${i + 1}] 원본 분석 중: "$rawMerchant" (날짜: ${rawData.date})');

        // 전략 패턴 실행 (브랜드 찾기 - 항상 결과 반환)
        final brandInfo = await _brandStrategy.findBrand(rawMerchant);

        // brandInfo는 항상 반환됨 (없으면 uncategorized로)
        final finalDisplayName = brandInfo?.name ?? rawMerchant;
        final finalCategory = brandInfo?.category ?? Category.uncategorized;
        String finalBranchName = ''; // 지점명 (예: 강남점)

        // ✂️ 지점명 추출 로직
        if (brandInfo != null && rawMerchant.contains(brandInfo.name)) {
          finalBranchName = rawMerchant.replaceAll(brandInfo.name, '').trim();
        }

        // 데이터 정제 및 병합
        final enrichedData = ReceiptData(
          rawText: rawData.rawText,
          date: rawData.date,
          amount: rawData.amount,
          merchant: rawMerchant, // 원본 보존
          displayName: finalDisplayName, // UI용 이름
          // branch: finalBranchName, // (선택사항)
          category: finalCategory,
          status: rawData.status,
        );

        // OCR 중복 제거 로직 (실제 중복 구매는 유지)
        // OCR이 정확히 같은 텍스트를 2번 인식한 경우만 제거
        // 살짝이라도 다르면 별도 거래로 판단 (날짜/지점명 차이 등)
        final dateStr = enrichedData.date?.toIso8601String() ?? 'no_date';

        // 키 생성: "원본텍스트_금액_날짜" (정규화 없이 원본 그대로!!)
        final rawTextTrimmed = rawData.rawText.trim();
        final uniqueKey = "${rawTextTrimmed}_${enrichedData.amount}_$dateStr";

        _logger.d('      🔑 키: "$uniqueKey"');

        if (!uniqueMap.containsKey(uniqueKey)) {
          uniqueMap[uniqueKey] = enrichedData;

          if (brandInfo != null) {
            _logger.i(
                '   ✨ 추출 성공: $finalDisplayName ($finalBranchName) - ${enrichedData.amount}원');
          } else {
            // 브랜드 미확인도 결과에 포함 (사용자가 수정 후 학습 가능)
            _logger.i(
                '   ⚠️ 추출 (브랜드 미확인): $finalDisplayName - ${enrichedData.amount}원');
          }
        } else {
          // 기존에 있던 건과 비교
          final existingData = uniqueMap[uniqueKey]!;
          _logger.w('   🗑️ OCR 중복 제거됨: ${enrichedData.amount}원');
          _logger.d(
              '      충돌 rawText: "$rawTextTrimmed" vs 기존: "${existingData.rawText}"');
        }
      }

      // Map의 값들만 리스트로 변환
      final finalResults = uniqueMap.values.toList();

      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _logger.i(
          '✅ 최종 완료: ${finalResults.length}건 (중복 ${rawResults.length - finalResults.length}건 제거)');
      _logger.i('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return finalResults;
    } catch (e, stackTrace) {
      _logger.e('OCR 처리 실패', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> submitReceiptData(
      ReceiptData receiptData) async {
    try {
      _logger.i('서버로 영수증 데이터 전송 중...');
      final response = await _apiService.createExpenseFromReceipt(receiptData);
      _logger.i('✅ 서버 전송 완료');
      return response;
    } catch (e, stackTrace) {
      _logger.e('서버 전송 실패', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 지원하는 카드사 ID 목록 가져오기
  List<String> get supportedCardIds => _patternFactory.supportedCardIds;

  /// 카드사 ID로 카드사명 가져오기
  String getCardName(String cardIssuerId) {
    return _patternFactory.getCardName(cardIssuerId);
  }

  /// 리소스 정리
  void dispose() {
    _textRecognizer.dispose();
    _logger.d('OCR Repository 종료');
  }
}
