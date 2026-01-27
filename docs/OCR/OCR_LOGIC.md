# OCR 전체 처리 로직 상세 설명

## 개요

MoneyFlow OCR 시스템은 은행 앱 화면 캡처 이미지에서 결제 내역을 추출하는 시스템입니다.

**핵심 철학**: 디지털 화면은 이미 깨끗하므로 최소한의 처리만 수행하고, 정확도는 스마트한 파싱 로직으로 확보합니다.

---

## 전체 처리 파이프라인

```
1. 이미지 선택/촬영 (ImagePicker)
   ↓
2. 이미지 전처리 (ImagePreprocessor)
   ↓
3. ML Kit OCR 텍스트 인식 (MlkitTextRecognizer)
   ↓
4. 패턴 파싱 (CommonPattern)
   ↓
5. 날짜 보정 (DateCorrector)
   ↓
6. 브랜드 매칭 & 중복 제거 (OcrRepositoryImpl + BrandMatchStrategy)
   ↓
7. 결과 반환 (List<ReceiptData>)
```

---

## 1. 이미지 전처리 (ImagePreprocessor)

**위치**: `lib/features/ocr/data/datasources/local/image_preprocessor.dart`

### 목적
은행 앱 화면 캡처 이미지를 OCR에 최적화된 상태로 변환합니다.

### 처리 단계

#### Step 1: 이미지 로드 및 분석
```dart
final imageBytes = await imageFile.readAsBytes();
final image = img.decodeImage(imageBytes);
```

#### Step 2: 해상도 최적화
**목표 해상도**: 1080px - 1440px (긴 쪽 기준)

```dart
if (longerSide > 1440) {
  // 1440px로 축소
  resized = img.copyResize(image, width: newWidth, height: newHeight);
} else if (longerSide < 1080) {
  // 1080px로 확대
  resized = img.copyResize(image, width: newWidth, height: newHeight);
}
```

**중요**: 0.7배 미만 축소 금지 (텍스트 가독성 손실 방지)

#### Step 3: 밝기 보정 (선택적)
평균 밝기가 너무 어두운 경우에만 보정합니다.

```dart
final avgBrightness = _calculateAverageBrightness(image);

if (avgBrightness < 100) {
  // 어두운 이미지 → 밝기 +30
  brightened = img.brightness(image, brightness: 30);
}
```

#### Step 4: PNG 저장
JPEG 압축 손실을 피하기 위해 PNG 포맷으로 저장합니다.

```dart
final png = img.encodePng(processed);
await outputFile.writeAsBytes(png);
```

### 금지 사항 (디지털 화면 특성)
- 그레이스케일 변환 (컬러 정보 손실)
- 대비 강화 (노이즈 증폭)
- 샤프닝 (아티팩트 발생)
- 이진화 (디테일 손실)

---

## 2. ML Kit OCR 텍스트 인식 (MlkitTextRecognizer)

**위치**: `lib/features/ocr/data/datasources/local/mlkit_text_recognizer.dart`

### 처리 과정

#### Step 1: InputImage 생성
```dart
final inputImage = InputImage.fromFile(imageFile);
```

#### Step 2: 텍스트 인식 (한 번만 실행)
```dart
final recognizedText = await _textRecognizer.processImage(inputImage);
```

**중요**: ML Kit은 한 번만 실행합니다. Multiple recognizer 사용 안 함.

#### Step 3: 결과 구조
```dart
RecognizedText
├── blocks (List<TextBlock>)
│   ├── lines (List<TextLine>)
│   │   ├── text: String
│   │   ├── boundingBox: Rect
│   │   └── elements (List<TextElement>)
```

### 언어 모델
ML Kit이 자동으로 한글/영어를 감지하고 처리합니다. 코드로 제어하지 않습니다.

---

## 3. 패턴 파싱 (CommonPattern)

**위치**: `lib/features/ocr/data/parser/common_pattern.dart`

### 핵심 아이디어
금액을 "앵커(anchor)"로 사용하여 주변 텍스트(날짜, 가맹점)를 수집합니다.

### 정규식 패턴

#### 금액 Regex
```dart
RegExp _moneyRegex = RegExp(
  r'([+\-]?\s?[\d]{1,3}(,[\d]{3})+)(\s?원)?|([+\-]?\s?[\d]{3,}\s?원?)'
);
```
**매칭 예시**:
- "1,500원" ✓
- "15,000" ✓
- "-3,000원" ✓ (취소)
- "1500" ✓

#### 날짜 Regex 1 (연도 포함)
```dart
RegExp _dateFullRegex = RegExp(
  r'(\d{1,4})[\s\.\-/년]+(\d{1,2})[\s\.\-/월]+(\d{1,2})[일]?'
);
```
**매칭 예시**:
- "2025-11-20" ✓
- "25.11.20" ✓
- "5.11.24" ✓ (1자리 연도도 허용)

#### 날짜 Regex 2 (월/일만)
```dart
RegExp _dateShortRegex = RegExp(
  r'(\d{1,2})[\s\.\-/월]+(\d{1,2})[일]?'
);
```
**매칭 예시**:
- "11 24" ✓
- "11/24" ✓
- "11월 24일" ✓

### 파싱 알고리즘

#### Step 1: 금액 라인 찾기
```dart
var moneyLines = allLines.where((line) {
  return _moneyRegex.hasMatch(line.text) && !_dateRegex.hasMatch(line.text);
}).toList();

moneyLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
```

#### Step 2: 각 금액에 대해 주변 정보 수집
금액 라인을 기준으로 3개 영역을 탐색합니다:

**영역 1: 같은 줄 (금액 왼쪽)**
```dart
for (var line in allLines) {
  double dy = (anchor.center.dy - line.boundingBox.center.dy).abs();
  if (dy < anchor.height * 0.8) { // 같은 줄
    if (line.boundingBox.right < anchor.left + 50) {
      if (_dateRegex.hasMatch(line.text)) {
        dateStr = line.text;
      } else if (!_isNoise(line.text)) {
        merchantParts.add(line);
      }
    }
  }
}
```

**영역 2: 바로 윗줄**
```dart
double upperLimit = anchor.top - (anchor.height * 2.5); // 최대 2.5줄 위까지

for (var line in allLines) {
  if (line.boundingBox.bottom < anchor.top && line.boundingBox.top > upperLimit) {
    if (line.boundingBox.left < anchor.right) {
      if (_dateRegex.hasMatch(line.text)) {
        dateStr ??= line.text;
      } else if (!_isNoise(line.text)) {
        merchantParts.add(line);
      }
    }
  }
}
```

**영역 3: 아랫줄 (날짜 Fallback)**
```dart
if (dateStr == null) {
  for (var line in allLines) {
    if (!_dateRegex.hasMatch(line.text)) continue;
    double gap = line.boundingBox.top - anchor.bottom;
    if (gap >= -15 && gap < anchor.height * 4.0) {
      if ((line.boundingBox.left - anchor.left).abs() < 600) {
        dateStr = line.text;
        break;
      }
    }
  }
}
```

#### Step 3: 가맹점명 조립
수집한 텍스트 조각들을 Y축(위→아래), X축(왼→오) 순으로 정렬하여 조립합니다.

```dart
merchantParts.sort((a, b) {
  double dy = (a.boundingBox.top - b.boundingBox.top).abs();
  if (dy < anchor.height * 0.5) {
    return a.boundingBox.left.compareTo(b.boundingBox.left); // 같은 줄이면 X축
  }
  return a.boundingBox.top.compareTo(b.boundingBox.top); // 다른 줄이면 Y축
});

String storeName = merchantParts.map((e) => e.text).join(' ').trim();
```

#### Step 4: 노이즈 필터링
```dart
bool _isNoise(String text) {
  if (_timeRegex.hasMatch(text)) return true;          // "14:30"
  if (text.contains('%')) return true;                 // "0.5%"
  if (text.contains('일시불')) return true;             // "일시불"
  if (text.contains('적립')) return true;              // "적립"
  if (_isTotalLine(text)) return true;                 // "합계"
  return false;
}
```

#### Step 5: 합계 라인 스킵
```dart
static const List<String> _totalKeywords = [
  '합계', '총액', '결제금액', '청구금액', '출금예정', '누적', '잔액'
];

bool _isTotalLine(String text) {
  final clean = text.replaceAll(RegExp(r'\s'), '');
  return _totalKeywords.any((k) => clean.contains(k));
}
```

#### Step 6: 취소 상태 판단
```dart
bool isCancel = moneyLine.text.contains('-') ||
                moneyLine.text.contains('취소') ||
                storeName.contains('취소');
```

---

## 4. 날짜 보정 (DateCorrector)

**위치**: `lib/features/ocr/data/utils/date_corrector.dart`

### 문제 정의
OCR이 11월을 1월로, 12월을 2월로 인식하는 전형적인 오류를 자동으로 보정합니다.

### 알고리즘

#### Step 1: 월별 클러스터 분석
```dart
예시 입력: [11/20, 11/24, 01/27, 11/28, 12/03]

월별 분포:
{11: 3, 12: 1, 1: 1}
```

#### Step 2: OCR 오류 패턴 인식
10, 11, 12월이 0, 1, 2월로 인식되는 패턴을 감지합니다.

```dart
bool _isTypicalOcrError(int detected, int expected) {
  // 10, 11, 12월이 0, 1, 2월로 인식되는 패턴
  if (expected >= 10 && expected <= 12) {
    final lastDigit = expected % 10;
    if (detected == lastDigit || detected == lastDigit + 1) {
      return true; // 11 → 1, 12 → 2
    }
  }
  return false;
}
```

#### Step 3: 가상 클러스터 병합
```dart
원본: {11: 3, 12: 1, 1: 1}
↓
가상 클러스터: {11: 4, 12: 1}  // 1월 → 11월 그룹으로 병합
```

#### Step 4: 다수 월(Dominant Month) 결정
전체의 35% 이상을 차지하는 월을 다수 월로 선정합니다.

```dart
11월: 4건 / 5건 = 80% → 다수 월로 결정
```

#### Step 5: 보정 신뢰도 계산
각 날짜에 대해 보정 필요 여부를 신뢰도 점수로 판단합니다.

**신뢰도 계산 요소** (최대 1.0):
1. **다수 월 비율** (0.4): 클러스터에서 가장 많은 월의 비중
   ```dart
   final dominantRatio = dominantCount / totalCount;
   confidence += dominantRatio * 0.4;
   ```

2. **원본 월이 소수** (0.3): 1개뿐인 월은 OCR 오류 가능성 높음
   ```dart
   if (originalCount == 1) {
     confidence += 0.3;
   } else if (originalCount == 2) {
     confidence += 0.15;
   }
   ```

3. **OCR 오류 패턴 일치** (0.45): 11→1 패턴 등
   ```dart
   if (_isTypicalOcrError(originalMonth, dominantMonth)) {
     confidence += 0.45;
   }
   ```

4. **기준일과의 거리** (0.1): 60일 이내면 보너스
   ```dart
   final daysDiff = (originalDate.difference(referenceDate).inDays).abs();
   if (daysDiff <= 60) {
     confidence += 0.1;
   }
   ```

5. **미래 날짜 보너스** (0.1): 과거 영수증이 미래 날짜면 오류
   ```dart
   if (originalDate.isAfter(referenceDate)) {
     confidence += 0.1;
   }
   ```

**예시 계산**:
```dart
01/27의 신뢰도:
- 다수 월 비율 (80%): +0.32
- 소수 월 (1개): +0.3
- OCR 패턴 일치 (1→11): +0.45
- 60일 이내: +0.1
- 총합: 1.17 → 1.0 (클램핑)
```

#### Step 6: 보정 실행
```dart
if (confidence >= 0.8) {
  // 고신뢰도: 즉시 보정
} else if (confidence >= 0.35) {
  // 중신뢰도: 보정
} else {
  // 저신뢰도: 원본 유지
}
```

#### Step 7: 보정 검증
```dart
bool _isValidCorrectedDate(DateTime corrected, DateTime referenceDate) {
  final oneYearAgo = referenceDate.subtract(const Duration(days: 365));
  if (corrected.isBefore(oneYearAgo)) return false; // 1년 이전 거부

  final oneMonthLater = referenceDate.add(const Duration(days: 30));
  if (corrected.isAfter(oneMonthLater)) return false; // 1개월 이후 거부

  return true;
}
```

---

## 5. 브랜드 매칭 (GlobalBrandSource)

**위치**: `lib/features/ocr/data/datasources/memory/global_brand_source.dart`

### 브랜드 데이터 구조
```dart
// assets/data/brands.json
{
  "brands": [
    {
      "keywords": ["컴포즈", "compose"],
      "name": "컴포즈커피",
      "category": "CAFE"
    }
  ]
}
```

### 초기화
```dart
Future<void> initialize() async {
  final jsonString = await rootBundle.loadString('assets/data/brands.json');
  final json = jsonDecode(jsonString);

  for (var brandData in json['brands']) {
    final keywords = List<String>.from(brandData['keywords']);
    final name = brandData['name'];
    final category = Category.values.firstWhere(
      (e) => e.name.toUpperCase() == brandData['category'].toUpperCase()
    );

    for (var keyword in keywords) {
      final key = StringSimilarity.normalize(keyword); // 공백 제거, 소문자
      _brandMap[key] = _BrandData(name: name, category: category);
    }
  }
}
```

### 2단계 매칭

#### 1단계: 정확 일치 (Exact Match)
```dart
final normalized = StringSimilarity.normalize(rawText);

for (var entry in _brandMap.entries) {
  if (normalized.contains(entry.key)) {
    return BrandInfo(
      name: entry.value.name,
      category: entry.value.category,
      confidence: 1.0,
    );
  }
}
```

**예시**:
```dart
rawText: "컴포즈커피용인흥덕IT밸리점"
normalized: "컴포즈커피용인흥덕it밸리점"
keyword: "컴포즈"

normalized.contains("컴포즈") → true
→ BrandInfo(name: "컴포즈커피", confidence: 1.0)
```

#### 2단계: Fuzzy 매칭 (오타 보정)
```dart
for (var entry in _brandMap.entries) {
  // 키워드 길이 차이가 3 이상이면 스킵
  if ((normalized.length - entry.key.length).abs() > 3) continue;

  if (StringSimilarity.isSimilar(normalized, entry.key)) {
    final similarity = StringSimilarity.similarity(normalized, entry.key);

    if (bestMatch == null || similarity > bestMatch.similarity) {
      bestMatch = _FuzzyMatch(
        brandData: entry.value,
        keyword: entry.key,
        similarity: similarity,
      );
    }
  }
}
```

**유사도 → 신뢰도 변환**:
```dart
final confidence = 0.7 + (similarity * 0.2);
// similarity 0.85 → confidence 0.87
```

### 지점명 추출
```dart
rawMerchant: "컴포즈커피용인흥덕IT밸리점"
brandName: "컴포즈커피"

branchName = rawMerchant.replaceAll(brandName, '').trim()
          = "용인흥덕IT밸리점"
```

---

## 6. 중복 제거 로직 (OcrRepositoryImpl)

**위치**: `lib/features/ocr/data/repositories/ocr_repository_impl.dart`

### 문제 정의

**잘못된 접근**:
```dart
uniqueKey = "${displayName}_${amount}_${date}"
// 문제: "컴포즈커피_1500_2025-12-30"가 6번 나오면 1건만 남음
```

**올바른 접근**:
```dart
uniqueKey = "${rawText}_${amount}_${date}"
// 해결: 각 거래의 원본 텍스트가 다르므로 모두 별도 거래로 인식
```

### 핵심 아이디어

**rawText를 사용하는 이유**:
- OCR이 인식한 원본 텍스트는 거래마다 약간씩 다릅니다
- 같은 가게, 같은 금액이어도 화면 위치가 다르면 rawText가 다름
- OCR이 정확히 같은 텍스트 블록을 2번 읽었을 때만 rawText가 동일함

### 구현 코드

```dart
final uniqueMap = <String, ReceiptData>{};

for (var i = 0; i < dateCorrectedResults.length; i++) {
  final rawData = dateCorrectedResults[i];

  // 브랜드 매칭
  final brandInfo = await _brandStrategy.findBrand(rawData.merchant);

  String finalDisplayName = rawData.merchant;
  String finalBranchName = '';
  Category finalCategory = Category.etc;

  if (brandInfo != null) {
    finalDisplayName = brandInfo.name;
    finalCategory = brandInfo.category;

    if (rawData.merchant.contains(brandInfo.name)) {
      finalBranchName = rawData.merchant.replaceAll(brandInfo.name, '').trim();
    }
  }

  final enrichedData = ReceiptData(
    rawText: rawData.rawText,
    date: rawData.date,
    amount: rawData.amount,
    merchant: rawData.merchant,      // 원본 보존
    displayName: finalDisplayName,   // UI용 이름
    category: finalCategory,
    status: rawData.status,
  );

  // Unique Key 생성
  final rawTextTrimmed = rawData.rawText.trim();
  final dateStr = enrichedData.date?.toIso8601String() ?? 'no_date';
  final uniqueKey = "${rawTextTrimmed}_${enrichedData.amount}_$dateStr";

  if (!uniqueMap.containsKey(uniqueKey)) {
    uniqueMap[uniqueKey] = enrichedData;

    if (brandInfo != null) {
      _logger.i('추출 성공: $finalDisplayName ($finalBranchName) - ${enrichedData.amount}원');
    } else {
      _logger.i('추출 (브랜드 미확인): $finalDisplayName - ${enrichedData.amount}원');
    }
  } else {
    _logger.w('OCR 중복 제거됨: ${enrichedData.amount}원');
  }
}

final finalResults = uniqueMap.values.toList();
```

### 예시

#### 시나리오 1: 같은 가게 6번 방문 (정상)
```
rawText들:
1. "1,500 컴포즈커피용인흥덕IT밸리점"
2. "1,500 T 컴포즈커피용인흥덕IT밸리점"
3. "1,500컴포즈커피 용인흥덕IT밸리점"
4. "1,500 컴포즈커피 용인흥덕 IT밸리점"
5. "1,500 컴포즈커피용인흥덕IT밸리점 "
6. "1,500컴포즈커피용인흥덕IT밸리점"

→ rawText가 모두 다름 → 6건 모두 유지
```

#### 시나리오 2: OCR 중복 인식
```
rawText들:
1. "1,500 컴포즈커피용인흥덕IT밸리점"
2. "1,500 컴포즈커피용인흥덕IT밸리점"  (완전히 동일!)

→ rawText가 정확히 같음 → 1건만 유지, 1건 제거
```

---

## 7. 실제 동작 예시

### 입력 (현대카드 앱 캡처)
```
거래 내역:
1. 12/20 컴포즈커피용인흥덕IT밸리점 1,500원
2. 12/24 컴포즈커피용인흥덕IT밸리점 1,500원
3. 01/27 컴포즈커피용인흥덕IT밸리점 1,500원  ← OCR 오류 (실제 11/27)
4. 12/28 컴포즈커피용인흥덕IT밸리점 1,500원
5. 12/03 컴포즈커피용인흥덕IT밸리점 1,500원
6. 12/05 컴포즈커피용인흥덕IT밸리점 1,500원
7. 11/15 모빌리언스 - 삼성전자(주) 1,200원
8. 11/18 모빌리언스 - 삼성전자(주) 600원
9. 11/22 모빌리언스 - 삼성전자(주) 500원
```

### 처리 과정

#### 1단계: 전처리
```
원본: 1920×1080 → 1440×810 (축소)
밝기: 120 (충분) → 보정 안 함
포맷: PNG 저장
```

#### 2단계: OCR
```
10개 텍스트 블록 인식
(rawText들이 약간씩 다름)
```

#### 3단계: 패턴 파싱
```
10건 추출:
- 컴포즈커피: 6건 (날짜 다름)
- 모빌리언스: 3건 (금액 다름)
```

#### 4단계: 날짜 보정
```
월별 클러스터: {12: 4, 11: 3, 1: 1}
가상 클러스터: {12: 4, 11: 4} (1월 → 11월 병합)
다수 월: 12월 (4건)

01/27 분석:
- 신뢰도: 0.9
- 보정: 01/27 → 11/27
```

#### 5단계: 브랜드 매칭
```
컴포즈커피: 6건
- "컴포즈" 키워드 매칭 성공
- displayName: "컴포즈커피"
- category: CAFE
- confidence: 1.0

모빌리언스: 3건
- 브랜드 DB에 없음
- displayName: "모빌리언스 - 삼성전자(주)" (원본 유지)
- category: ETC
```

#### 6단계: 중복 제거
```
컴포즈커피 6건:
- rawText가 모두 다름 → 6건 유지

모빌리언스 3건:
- rawText가 모두 다름 (금액이 다르므로) → 3건 유지

중복 제거: 0건
```

### 최종 출력
```
9건 추출 (중복 0건 제거)
- 컴포즈커피: 6건
- 모빌리언스 - 삼성전자(주): 3건
```

---

## 8. 설계 결정 사항

### Q1: 왜 컬러를 유지하나?
**A**: 디지털 화면 특성
- 은행 앱 화면은 이미 고대비 디자인
- 그레이스케일 변환 시 색상 정보 손실
- ML Kit은 컬러 이미지도 잘 처리

### Q2: 왜 대비/샤프닝을 안 하나?
**A**: 오히려 역효과
- 디지털 화면은 이미 선명함
- 대비 강화 → 노이즈 증폭
- 샤프닝 → 아티팩트 발생

### Q3: 날짜 보정 신뢰도 35%가 낮지 않나?
**A**: OCR 특성상 적극적 보정 필요
- 10, 11, 12월 → 0, 1, 2월 오류 매우 흔함
- 클러스터 분석으로 오탐 최소화
- 1년 전/1개월 후 제약으로 안전장치

### Q4: rawText trim()만 하고 정규화 안 하는 이유?
**A**: 미세한 차이도 별도 거래로 인식
- "컴포즈커피" vs "컴포즈 커피" (공백) → 별도 거래일 가능성
- 과도한 정규화 → 실제 거래를 중복으로 오판

### Q5: 브랜드 미확인도 결과에 포함하는 이유?
**A**: 사용자 경험 및 학습 데이터
- 사용자가 나중에 수정 가능
- 향후 brands.json 업데이트 참고
- "모빌리언스" 같은 결제대행사도 의미 있는 데이터

---

## 9. 테스트 케이스

### Case 1: 정상 (6번 방문)
```
입력: 같은 가게, 같은 금액, 다른 날짜 6건
예상: 6건 모두 추출
결과: PASS
```

### Case 2: OCR 중복
```
입력: 완전히 동일한 rawText 2건
예상: 1건만 추출
결과: PASS
```

### Case 3: 날짜 오류
```
입력: [11/20, 11/24, 01/27, 11/28]
예상: 01/27 → 11/27 보정
결과: PASS
```

### Case 4: 브랜드 미확인
```
입력: "모빌리언스 - 삼성전자(주)"
예상: 브랜드 미확인으로 표시, 결과에 포함
결과: PASS
```

---

## 10. 향후 개선 방향

### 1. 브랜드 DB 확장
- 결제대행사: 모빌리언스, 나이스페이먼츠
- 통신사: KT, SKT, LG유플러스
- 보험사: 삼성화재, 현대해상

### 2. 날짜 보정 고도화
- 요일 정보 활용
- 연도 추론 개선 (연말 넘어가는 케이스)

### 3. rawText 유사도 검사
- Levenshtein Distance
- 95% 이상 유사 → 중복 판단
- 현재는 100% 일치만 중복 인식

### 4. 사용자 피드백 학습
- 사용자 수정 정보 서버 전송
- brands.json 자동 업데이트

---

**작성일**: 2025-12-30
**작성자**: Claude Code
**버전**: 1.0
