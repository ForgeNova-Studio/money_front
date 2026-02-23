/// 카드사 정보 모델
/// OCR 영수증 스캔, SMS 파싱, 단축어 가이드 등에서 공통 사용
class CardCompany {
  final String id;
  final String name;
  final String iconPath;
  final String shortcutUrl; // iCloud 단축어 템플릿 URL

  const CardCompany({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.shortcutUrl,
  });
}

/// 지원하는 카드사 목록
const List<CardCompany> supportedCardCompanies = [
  CardCompany(
    id: 'shinhan',
    name: '신한카드',
    iconPath: 'assets/icons/cards/shinhan.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/e094e29ec62e4320982c973ef1ebd61a',
  ),
  CardCompany(
    id: 'samsung',
    name: '삼성카드',
    iconPath: 'assets/icons/cards/samsung.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/2fd8644e5fbe4819bf8ceeba1f8ffd35',
  ),
  CardCompany(
    id: 'kb',
    name: 'KB국민카드',
    iconPath: 'assets/icons/cards/kb.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/28912120df70440ba36e5e7e6b9fc2c9',
  ),
  CardCompany(
    id: 'hyundai',
    name: '현대카드',
    iconPath: 'assets/icons/cards/hyundai.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/290d437b58984c27b14b283fe44343ee',
  ),
  CardCompany(
    id: 'lotte',
    name: '롯데카드',
    iconPath: 'assets/icons/cards/lotte.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/3a0003ba5dac4aa5bbbbde17ac94a667',
  ),
  CardCompany(
    id: 'woori',
    name: '우리카드',
    iconPath: 'assets/icons/cards/woori.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/e23bc39b8a7540b5abd3f7d5eae5a53d',
  ),
  CardCompany(
    id: 'hana',
    name: '하나카드',
    iconPath: 'assets/icons/cards/hana.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/eb4f4a1e03824140a5a3637037094f55',
  ),
  CardCompany(
    id: 'nh',
    name: 'NH농협카드',
    iconPath: 'assets/icons/cards/nh.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/e1bbb9850cf04c35a638ecacb0768692',
  ),
  CardCompany(
    id: 'bc',
    name: 'BC카드',
    iconPath: 'assets/icons/cards/bc.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/baeac43af8a34c1fb91dff2d6d125894',
  ),
];
