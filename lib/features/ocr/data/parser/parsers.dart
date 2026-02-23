/// OCR 패턴 파서 모듈
///
/// 카드사별 패턴과 공통 패턴을 제공합니다.
///
/// **사용 방법:**
/// ```dart
/// import 'package:moamoa/features/ocr/data/parser/parsers.dart';
///
/// // 팩토리로 패턴 가져오기
/// final pattern = ReceiptPatternFactory.instance.getPatternByCardId('shinhan');
///
/// // 지원 카드사 목록
/// final cardIssuers = supportedCardIssuers;
/// ```

// Base
export 'base_receipt_pattern.dart';

// Factory
export 'receipt_pattern_factory.dart';

// Common (Fallback)
export 'common_pattern.dart';

// Card-specific patterns
export 'shinhan_pattern.dart';
export 'samsung_pattern.dart';
export 'kb_pattern.dart';
export 'hyundai_pattern.dart';
export 'hana_pattern.dart';
export 'lotte_pattern.dart';
export 'woori_pattern.dart';
export 'nh_pattern.dart';
export 'bc_pattern.dart';
