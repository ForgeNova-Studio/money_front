# MoneyFlow

생활비를 쉽고 빠르게 기록하고, 월별 흐름을 한눈에 확인할 수 있는 개인 가계부 앱입니다.

## 핵심 기능

- 수입/지출 기록 및 카테고리 관리
- 월별 캘린더 기반 내역 확인
- 영수증 스캔(OCR)로 자동 입력
- 로그인/회원가입 및 계정 관리

## 기술 스택

- Flutter (Material 3)
- Riverpod
- GoRouter

## 개발 환경

- Flutter SDK
- Android Studio 또는 VS Code
- iOS 빌드 시 Xcode

## 실행 방법

```bash
flutter pub get
flutter run
```

## 폴더 구조 (요약)

```
lib/
  core/          # 공통 유틸, 테마, 상수
  features/      # 도메인별 기능 모듈
  router/        # 라우팅
```

## 색상/테마 규칙

- Material 기본 위젯 색상은 `ColorScheme` 사용
- 앱 고유 색상(그라데이션/도메인 색)은 `context.appColors` 사용
- `AppColors`는 팔레트 원천값 전용

자세한 가이드는 `docs/THEME_GUIDE.md` 참고.

## 테스트

```bash
flutter test
```

## 기타 문서

- `docs/THEME_GUIDE.md`: 색상/테마 사용 가이드
