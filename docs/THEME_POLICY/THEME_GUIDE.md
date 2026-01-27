# 테마/색상 사용 가이드

이 프로젝트의 색상 사용은 두 레이어로 나눕니다.

- Material3 ColorScheme: Material 위젯 기본 색상 체계
- AppThemeColors (ThemeExtension): ColorScheme에 없는 앱 전용 색상

UI 코드에서 어떤 것을 써야 할지 이 가이드를 참고하세요.

## ColorScheme를 써야 할 때

표준 Material 위젯을 스타일링하거나, Material 의미 체계에 잘 맞는 경우
`Theme.of(context).colorScheme`를 사용합니다.

예시:
- 버튼, AppBar, 내비게이션의 기본 색
- 카드, 바텀시트, 스캐폴드 배경 등 표준 Surface
- 에러/검증 상태
- Material 위젯의 보더/디바이더

자주 쓰는 키:
- `colorScheme.primary`
- `colorScheme.onPrimary`
- `colorScheme.surface`
- `colorScheme.onSurface`
- `colorScheme.error`
- `colorScheme.outline`

## AppThemeColors를 써야 할 때

ColorScheme에 없는 앱 고유 색상이 필요할 때
`context.appColors`를 사용합니다.

예시:
- 그라데이션 (ColorScheme에 없음)
- 브랜드 전용 톤/섀도우/틴트
- 도메인 의미 색상 (수입/지출)
- 커스텀 UI에 쓰이는 세부 텍스트/배경 컬러

자주 쓰는 키:
- `context.appColors.primaryGradient`
- `context.appColors.backgroundAccentTint`
- `context.appColors.textSecondary`
- `context.appColors.income`
- `context.appColors.expense`

## 금지 사항

- UI 위젯에서 `AppColors` 직접 사용 금지
- `AppColors`는 팔레트 원천값 전용 (ColorScheme/AppThemeColors에서만 사용)

## 빠른 선택 체크리스트

1) 표준 Material 위젯 색 or 의미 체계에 맞는 색인가? -> ColorScheme
2) 브랜드 톤/그라데이션/앱 전용 토큰인가? -> AppThemeColors
3) AppColors를 직접 쓰고 싶다면? -> 위 두 가지 중 하나로 치환
