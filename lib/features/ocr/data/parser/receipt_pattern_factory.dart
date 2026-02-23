import 'package:moamoa/features/ocr/data/parser/base_receipt_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/bc_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/common_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/hana_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/hyundai_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/kb_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/lotte_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/nh_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/samsung_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/shinhan_pattern.dart';
import 'package:moamoa/features/ocr/data/parser/woori_pattern.dart';
import 'package:moamoa/features/ocr/domain/patterns/receipt_pattern.dart';

/// OCR 영수증 패턴 팩토리
///
/// 카드사별 패턴을 관리하고, 적절한 패턴을 선택하는 역할
///
/// **사용 방법:**
/// ```dart
/// // 카드사 ID로 패턴 가져오기
/// final pattern = ReceiptPatternFactory.getPatternByCardId('shinhan');
///
/// // 텍스트 분석으로 자동 감지
/// final pattern = ReceiptPatternFactory.detectPattern(recognizedText);
///
/// // 모든 패턴 가져오기
/// final patterns = ReceiptPatternFactory.getAllPatterns();
/// ```
class ReceiptPatternFactory {
  /// 싱글톤 인스턴스
  static final ReceiptPatternFactory _instance = ReceiptPatternFactory._();

  /// 등록된 카드사별 패턴
  final Map<String, BaseReceiptPattern> _cardPatterns = {};

  /// 공통 패턴 (Fallback)
  final CommonPattern _commonPattern = CommonPattern();

  ReceiptPatternFactory._() {
    _registerPatterns();
  }

  /// 팩토리 인스턴스
  static ReceiptPatternFactory get instance => _instance;

  /// 패턴 등록
  void _registerPatterns() {
    final patterns = <BaseReceiptPattern>[
      ShinhanPattern(),
      SamsungPattern(),
      KbPattern(),
      HyundaiPattern(),
      HanaPattern(),
      LottePattern(),
      WooriPattern(),
      NhPattern(),
      BcPattern(),
    ];

    for (final pattern in patterns) {
      _cardPatterns[pattern.cardIssuerId] = pattern;
    }
  }

  /// 카드사 ID로 패턴 가져오기
  ///
  /// [cardIssuerId] 카드사 ID (예: 'shinhan', 'samsung')
  /// Returns 해당 카드사 패턴, 없으면 CommonPattern
  ReceiptPattern getPatternByCardId(String? cardIssuerId) {
    if (cardIssuerId == null || cardIssuerId.isEmpty) {
      return _commonPattern;
    }

    return _cardPatterns[cardIssuerId.toLowerCase()] ?? _commonPattern;
  }

  /// 인식된 텍스트에서 카드사 자동 감지
  ///
  /// [text] ML Kit로 인식한 전체 텍스트
  /// Returns 감지된 패턴, 감지 실패 시 CommonPattern
  ReceiptPattern detectPattern(String fullText) {
    for (final pattern in _cardPatterns.values) {
      if (pattern.identifierKeywords.any(
        (keyword) => fullText.contains(keyword),
      )) {
        return pattern;
      }
    }
    return _commonPattern;
  }

  /// 모든 카드사별 패턴 가져오기
  List<BaseReceiptPattern> getAllCardPatterns() {
    return _cardPatterns.values.toList();
  }

  /// 모든 패턴 가져오기 (CommonPattern 포함)
  List<ReceiptPattern> getAllPatterns() {
    return [
      ..._cardPatterns.values,
      _commonPattern,
    ];
  }

  /// 공통 패턴 가져오기
  CommonPattern get commonPattern => _commonPattern;

  /// 지원하는 카드사 ID 목록
  List<String> get supportedCardIds => _cardPatterns.keys.toList();

  /// 카드사 ID로 카드사명 가져오기
  String getCardName(String cardIssuerId) {
    return _cardPatterns[cardIssuerId.toLowerCase()]?.name ?? '기타';
  }
}

/// 카드사 정보
class CardIssuerInfo {
  final String id;
  final String name;
  final List<String> keywords;

  const CardIssuerInfo({
    required this.id,
    required this.name,
    required this.keywords,
  });
}

/// 지원하는 카드사 목록 (UI에서 사용)
const List<CardIssuerInfo> supportedCardIssuers = [
  CardIssuerInfo(
    id: 'shinhan',
    name: '신한카드',
    keywords: ['신한카드', 'SOL페이', '신한'],
  ),
  CardIssuerInfo(
    id: 'samsung',
    name: '삼성카드',
    keywords: ['삼성카드', 'SAMSUNG', '삼성'],
  ),
  CardIssuerInfo(
    id: 'kb',
    name: 'KB국민카드',
    keywords: ['KB국민카드', 'KB카드', 'KB Pay', '국민카드'],
  ),
  CardIssuerInfo(
    id: 'hyundai',
    name: '현대카드',
    keywords: ['현대카드', 'HYUNDAI', '현대'],
  ),
  CardIssuerInfo(
    id: 'hana',
    name: '하나카드',
    keywords: ['하나카드', '하나Pay', '하나'],
  ),
  CardIssuerInfo(
    id: 'lotte',
    name: '롯데카드',
    keywords: ['롯데카드', 'LOTTE', '롯데'],
  ),
  CardIssuerInfo(
    id: 'woori',
    name: '우리카드',
    keywords: ['우리카드', '우리WON', '우리'],
  ),
  CardIssuerInfo(
    id: 'nh',
    name: 'NH농협카드',
    keywords: ['NH농협카드', 'NH카드', '농협카드', '농협'],
  ),
  CardIssuerInfo(
    id: 'bc',
    name: 'BC카드',
    keywords: ['BC카드', '비씨카드', '페이북'],
  ),
];
