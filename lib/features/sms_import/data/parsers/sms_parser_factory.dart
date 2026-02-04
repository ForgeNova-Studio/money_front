import 'package:moamoa/features/sms_import/data/parsers/base_sms_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/shinhan_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/samsung_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/kb_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/hyundai_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/hana_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/lotte_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/woori_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/nh_parser.dart';
import 'package:moamoa/features/sms_import/data/parsers/bc_parser.dart';

/// 카드사별 SMS 파서 팩토리
class SmsParserFactory {
  static final Map<String, BaseSmsParser> _parsers = {
    'shinhan': ShinhanParser(),
    'samsung': SamsungParser(),
    'kb': KbParser(),
    'hyundai': HyundaiParser(),
    'hana': HanaParser(),
    'lotte': LotteParser(),
    'woori': WooriParser(),
    'nh': NhParser(),
    'bc': BcParser(),
  };

  /// 카드사 ID로 파서 가져오기
  static BaseSmsParser? getParser(String cardCompanyId) {
    return _parsers[cardCompanyId.toLowerCase()];
  }

  /// 지원되는 카드사 ID 목록
  static List<String> get supportedCardIds => _parsers.keys.toList();

  /// 카드사가 지원되는지 확인
  static bool isSupported(String cardCompanyId) {
    return _parsers.containsKey(cardCompanyId.toLowerCase());
  }
}
