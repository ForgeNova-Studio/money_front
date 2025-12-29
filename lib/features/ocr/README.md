# OCR 기능 - Clean Architecture

> **영수증 OCR 인식 및 지출 등록 기능**

## 📁 폴더 구조

```
lib/features/ocr/
├── domain/                          # 비즈니스 로직 (외부 의존성 없음)
│   ├── entities/
│   │   ├── brand_info.dart          # 브랜드 정보 DTO
│   │   ├── category.dart            # 카테고리 Enum (9개)
│   │   └── receipt_data.dart        # 영수증 데이터 모델
│   ├── patterns/
│   │   └── receipt_pattern.dart     # 패턴 파서 인터페이스
│   ├── repositories/
│   │   └── ocr_repository.dart      # Repository 인터페이스
│   └── strategies/
│       └── brand_match_strategy.dart # 브랜드 매칭 전략 인터페이스
│
├── data/                            # 구현체 (외부 라이브러리 의존)
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── image_preprocessor.dart        # 이미지 전처리 (다크모드 반전, 2배 확대)
│   │   │   ├── mlkit_text_recognizer.dart     # ML Kit OCR 실행
│   │   │   └── user_brand_source.dart         # 사용자 학습 데이터 (Hive)
│   │   ├── memory/
│   │   │   └── global_brand_source.dart       # 글로벌 브랜드 데이터 (JSON)
│   │   └── remote/
│   │       └── ocr_api_service.dart           # 백엔드 API 통신
│   ├── parser/
│   │   ├── common_pattern.dart                # 공통 패턴 파서 (앵커링 방식)
│   │   └── samsung_card_pattern.dart          # 삼성카드 전용 패턴 (예정)
│   ├── repositories/
│   │   └── ocr_repository_impl.dart           # Repository 구현체
│   ├── strategies/
│   │   └── fallback_brand_strategy.dart       # Fallback 브랜드 전략 (User → Global)
│   └── utils/
│       └── string_similarity.dart             # Levenshtein Distance 유틸
│
└── presentation/                    # UI 레이어
    ├── providers/
    │   └── ocr_providers.dart       # Riverpod Provider 체인 (DI)
    ├── viewmodels/
    │   └── ocr_view_model.dart      # OCR ViewModel (NotifierProvider)
    └── screens/
        └── ocr_test_screen.dart     # OCR 테스트 화면
```

---

## 🏗️ Clean Architecture 레이어

### 1️⃣ Domain (비즈니스 로직)

**원칙**: 외부 의존성 없음 (순수 Dart 코드)

#### Entities
- `ReceiptData`: 영수증 데이터 모델
  - `amount`: 금액
  - `date`: 날짜
  - `merchant`: 가맹점
  - `status`: 승인/취소 상태

#### Repositories (인터페이스)
- `OcrRepository`: OCR 기능 인터페이스
  - `extractReceiptData()`: 이미지 → 영수증 데이터 추출
  - `submitReceiptData()`: 영수증 데이터 → 서버 전송

#### Patterns (인터페이스)
- `ReceiptPattern`: 영수증 파싱 패턴 인터페이스
  - `canParse()`: 이 패턴으로 파싱 가능한지 판단
  - `parse()`: RecognizedText → ReceiptData 변환

---

### 2️⃣ Data (구현체)

**원칙**: 외부 라이브러리(ML Kit, Dio 등) 사용 가능

#### DataSources

**Local (ML Kit)**
- `ImagePreprocessor`: 이미지 전처리
  - 다크모드 반전 (어두운 배경 → 밝은 배경)
  - 2배 확대 (1080-1440px 유지)
  - PNG 포맷 저장
  - Isolate에서 실행 (메인 스레드 차단 방지)

- `MlkitTextRecognizer`: ML Kit OCR 실행
  - TextRecognizer(korean script) 사용
  - RecognizedText 반환 (위치 정보 포함)

**Remote (API)**
- `OcrApiService`: 백엔드 API 통신
  - `POST /api/expenses/ocr`: 영수증 데이터 전송
  - 백엔드에서 카테고리 자동 분류

#### Parsers (패턴 구현체)
- `CommonPattern`: 공통 패턴 (앵커링 방식)
  - 금액 기준으로 앵커 설정
  - 주변 텍스트에서 날짜/가맹점 추출
  - 점수 기반 후보 선정

- `SamsungCardPattern`: 삼성카드 전용 (예정)

#### Repositories (구현체)
- `OcrRepositoryImpl`: Repository 구현
  - 전처리 → OCR → 파싱 → API 전송 조율
  - 패턴 등록 및 선택 로직
  - 리소스 정리 (dispose)

---

### 3️⃣ Presentation (UI)

**원칙**: UI와 상태 관리만 담당

#### Providers (Riverpod)
- `ocr_providers.dart`: 의존성 주입 체인
  - `globalBrandSourceProvider`: 글로벌 브랜드 데이터
  - `userBrandSourceProvider`: 사용자 학습 데이터
  - `brandMatchStrategyProvider`: Fallback 전략
  - `ocrRepositoryProvider`: OCR Repository

#### ViewModels
- `OcrViewModel` (NotifierProvider):
  - 상태: `OcrState` (isLoading, data, error)
  - 액션: `processImage()`, `submitReceiptData()`, `reset()`
  - Repository에 의존 (DI)

#### Screens
- `OcrTestScreen`: OCR 테스트 화면
  - 이미지 선택 (갤러리/카메라)
  - OCR 결과 표시
  - 서버 전송

---

## 🔄 OCR 처리 흐름

```
1. 사용자가 이미지 선택 (갤러리 또는 카메라)
   ↓
2. OcrProvider.extractReceiptFromImage() 호출
   ↓
3. OcrRepositoryImpl.extractReceiptData()
   ↓
4. ImagePreprocessor.preprocessForOcr()
   - 다크모드 반전, 2배 확대, PNG 저장 (Isolate에서 실행)
   ↓
5. MlkitTextRecognizer.recognizeText()
   - ML Kit OCR 실행 (한 번만)
   - RecognizedText 반환
   ↓
6. 패턴 선택
   - canParse()로 적합한 패턴 찾기
   - 없으면 CommonPattern 사용
   ↓
7. Pattern.parse()
   - 금액/날짜/가맹점 추출
   - ReceiptData 생성
   ↓
8. OcrProvider에 결과 반환
   ↓
9. 사용자가 결과 확인 후 "저장" 클릭
   ↓
10. OcrProvider.submitReceiptData() 호출
    ↓
11. OcrRepositoryImpl.submitReceiptData()
    ↓
12. OcrApiService.createExpenseFromReceipt()
    - POST /api/expenses/ocr
    - 백엔드에서 카테고리 분류
    ↓
13. 지출 등록 완료
```

---

## 🎯 설계 원칙

### OCR 정확도 개선 원칙 (은행앱 화면 특화)
1. **최소한의 전처리**: 디지털 화면은 이미 깨끗하므로 과도한 처리 금지
2. **원본 컬러 유지**: 그레이스케일 변환 금지
3. **단일 OCR 실행**: ML Kit은 한 번만 실행 (multiple recognizer 사용 안 함)
4. **ML Kit 내부 동작 제어 안 함**: 언어 모델은 자동으로 관리됨
5. **정확도 향상 = 전처리 + 후처리 + 패턴 설계**

### Clean Architecture 원칙
1. **Domain은 외부 의존성 없음**: 순수 Dart 코드만
2. **Data는 구현체**: ML Kit, Dio 등 외부 라이브러리 사용
3. **Presentation은 UI만**: Repository에 의존 (DI)
4. **의존성 방향**: Presentation → Domain ← Data

---

## 📝 사용 예시

### Provider 등록 (main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Hive 초기화
  await Hive.initFlutter();

  // 2. GlobalBrandSource 초기화 (JSON 로딩)
  final globalBrandSource = GlobalBrandSource();
  await globalBrandSource.init();

  // 3. UserBrandSource 초기화 (Hive Box 열기)
  final userBrandSource = UserBrandSource();
  await userBrandSource.init();

  runApp(
    ProviderScope(
      overrides: [
        globalBrandSourceProvider.overrideWithValue(globalBrandSource),
        userBrandSourceProvider.overrideWithValue(userBrandSource),
      ],
      child: MyApp(),
    ),
  );
}
```

### 화면에서 사용 (Riverpod)
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 읽기
    final state = ref.watch(ocrViewModelProvider);
    final viewModel = ref.read(ocrViewModelProvider.notifier);

    // 이미지 선택 후 OCR 실행
    await viewModel.processImage(imageFile);

    // 결과 확인
    if (state.hasData) {
      final receipt = state.data.first;
      print('금액: ${receipt.amount}');
      print('날짜: ${receipt.date}');
      print('가맹점: ${receipt.displayName}'); // 정규화된 브랜드명
      print('카테고리: ${receipt.category?.displayName}');
    }

    // 서버 전송
    final success = await viewModel.submitReceiptData(receipt);
  }
}
```

---

## 🧪 테스트

### 단위 테스트
- [ ] `MlkitTextRecognizer` 테스트
- [ ] `CommonPattern` 파싱 로직 테스트
- [ ] `OcrRepositoryImpl` 통합 테스트

### 통합 테스트
- [ ] 실제 영수증 이미지로 E2E 테스트
- [ ] 다크모드 이미지 테스트
- [ ] 다양한 카드사 이미지 테스트

---

## 🧠 Fuzzy Matching (Levenshtein Distance)

### 개요
OCR 오타를 자동 보정하기 위해 Levenshtein Distance 알고리즘 적용:
- **GlobalBrandSource**: 메이저 브랜드 오타 허용 ("서타벅스" → "스타벅스")
- **UserBrandSource**: 개인 가게명 변형 허용 ("철수네미용슬" → "철수네미용실")

### 매칭 우선순위
1. **정확 일치** (Exact Match)
   - GlobalBrand: confidence 1.0
   - UserBrand: confidence 0.95
2. **Fuzzy 일치** (Levenshtein)
   - GlobalBrand: confidence 0.7-0.9
   - UserBrand: confidence 0.8-0.9

### 자동 전처리 (StringSimilarity)
비교 전에 자동으로 정규화:
1. **공백 제거**: "스타 벅스" → "스타벅스"
2. **소문자 변환**: "Starbucks" → "starbucks"
3. **특수문자 제거**: "(주)스타벅스" → "스타벅스"

### 동적 Threshold
문자열 길이에 따라 자동 조절:
- **1-2글자**: threshold = 0 (정확 일치만, 예: "CU", "GS25")
- **3-4글자**: threshold = 1
- **5-8글자**: threshold = 2
- **9+ 글자**: threshold = 3

⚠️ **짧은 단어 방어 로직**: "CU" → "GU"는 완전히 다른 브랜드이므로 오타 허용 안 함

### 예시
```dart
// GlobalBrandSource
"스타벅스 강남점" → 정확 일치 (confidence: 1.0)
"서타벅스 강남점" → Fuzzy 일치 (confidence: 0.75)
"소타벅스" → Fuzzy 일치 (confidence: 0.75)

// UserBrandSource
"철수네미용실" → 정확 일치 (confidence: 0.95)
"철수네미용슬" → Fuzzy 일치 (confidence: 0.85)
"철수네미용싀" → Fuzzy 일치 (confidence: 0.85)
```

---

## 🚀 향후 개선 사항

### 1. 자소 분리 (Jamo Decomposition) - Phase 2
**상황**: OCR이 미세하게 긁혀서 "미용실"을 "미용싈"로 인식

**현재 방식**:
- '실' vs '싈' → 완전 다른 글자 취급 (Distance +1)
- dynamicThreshold로 충분히 잡아냄 (거리 1)

**고도화 방안** (배포 후):
```dart
// 한글을 자소 단위로 분해
'실' → [ㅅ, ㅣ, ㄹ]
'싈' → [ㅅ, ㅟ, ㄹ]
// 모음 하나만 다름 → 더 정밀한 유사도 계산
```

**결론**: 현재 MVP 단계에서는 불필요, 실사용 데이터 수집 후 필요 시 적용

### 2. 카드사별 패턴 추가
   - `SamsungCardPattern`
   - `ShinhanCardPattern`
   - `KBCardPattern`
   - 등...

### 3. 이미지 크롭 기능
   - `image_cropper` 패키지 통합
   - 사용자가 영수증 영역만 선택

### 4. 배치 처리
   - 여러 영수증을 한 번에 처리
   - 리스트 형태 UI 개선

### 5. 캐싱
   - 파싱 결과 로컬 저장
   - 오프라인 모드 지원

---

**최종 업데이트**: 2025-12-24
**작성자**: Claude Code
