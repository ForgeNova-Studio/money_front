# DefaultLayout 사용 가이드

## 개요

`DefaultLayout`은 앱의 모든 화면에서 일관된 레이아웃을 적용하기 위한 래퍼 위젯입니다. `Scaffold`, `AppBar`, `PopScope` 등의 공통 설정을 중앙에서 관리하여 코드 중복을 줄이고 UI 일관성을 보장합니다.

## 파일 위치

```
lib/features/common/widgets/default_layout.dart
```

## 기본 사용법

### 1. Import

```dart
import 'package:moamoa/features/common/widgets/default_layout.dart';
```

### 2. 기본 구조

```dart
@override
Widget build(BuildContext context) {
  return DefaultLayout(
    title: '화면 제목',
    child: YourContentWidget(),
  );
}
```

## 파라미터 설명

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|---------|------|------|--------|------|
| `child` | `Widget` | ✅ | - | 화면의 메인 컨텐츠 |
| `title` | `String?` | ❌ | `null` | AppBar 제목 (문자열) |
| `titleWidget` | `Widget?` | ❌ | `null` | 커스텀 타이틀 위젯 (title보다 우선순위 높음) |
| `backgroundColor` | `Color?` | ❌ | `colorScheme.surface` | 화면 및 AppBar 배경색 |
| `actions` | `List<Widget>?` | ❌ | `null` | AppBar 우측 액션 버튼들 |
| `leading` | `Widget?` | ❌ | `null` | AppBar 좌측 버튼 (뒤로가기, 닫기 등) |
| `centerTitle` | `bool?` | ❌ | `null` | 제목 중앙 정렬 여부 |
| `titleSpacing` | `double?` | ❌ | `null` | 타이틀 좌측 여백 |
| `automaticallyImplyLeading` | `bool` | ❌ | `true` | 자동 뒤로가기 버튼 표시 여부 |
| `bottomNavigationBar` | `Widget?` | ❌ | `null` | 하단 네비게이션 바 |
| `floatingActionButton` | `Widget?` | ❌ | `null` | FAB 버튼 |
| `canPop` | `bool` | ❌ | `true` | 뒤로가기 허용 여부 (PopScope) |
| `onPopInvokedWithResult` | `Function?` | ❌ | `null` | 뒤로가기 시 콜백 |

## 사용 예시

### 1️⃣ 기본 화면 (제목만)

```dart
return DefaultLayout(
  title: '설정',
  child: SettingsContent(),
);
```

### 2️⃣ 메인 탭 화면 (뒤로가기 버튼 없음)

```dart
return DefaultLayout(
  title: '통계',
  automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
  child: StatisticsContent(),
);
```

### 3️⃣ 상세 화면 (액션 버튼 포함)

```dart
return DefaultLayout(
  title: '가계부 상세',
  actions: [
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () => _editAccountBook(),
    ),
  ],
  bottomNavigationBar: BottomNavBar(),
  child: AccountBookDetailContent(),
);
```

### 4️⃣ 폼 화면 (닫기 버튼 + 중앙 제목)

```dart
return DefaultLayout(
  title: '수입 등록',
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.close),
    onPressed: () => Navigator.of(context).pop(),
  ),
  child: IncomeFormContent(),
);
```

### 5️⃣ 폼 화면 (뒤로가기 차단)

스와이프 뒤로가기를 차단하고 닫기 버튼으로만 닫을 수 있도록:

```dart
return DefaultLayout(
  title: '지출 등록',
  centerTitle: true,
  canPop: false, // 스와이프/뒤로가기 버튼 차단
  leading: IconButton(
    icon: Icon(Icons.close),
    onPressed: () => Navigator.of(context).pop(),
  ),
  child: ExpenseFormContent(),
);
```

### 6️⃣ 뒤로가기 시 키보드 닫기

```dart
return DefaultLayout(
  title: '가계부 만들기',
  centerTitle: true,
  canPop: true,
  onPopInvokedWithResult: (_, __) {
    FocusManager.instance.primaryFocus?.unfocus();
  },
  leading: IconButton(
    icon: Icon(Icons.close),
    onPressed: () {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pop();
    },
  ),
  child: CreateFormContent(),
);
```

### 7️⃣ 커스텀 배경색

```dart
return DefaultLayout(
  title: '예산 설정',
  backgroundColor: context.appColors.backgroundLight,
  child: BudgetContent(),
);
```

### 8️⃣ 커스텀 타이틀 위젯

드롭다운이나 복잡한 타이틀이 필요한 경우:

```dart
return DefaultLayout(
  titleWidget: Row(
    children: [
      Text('가계부 선택'),
      Icon(Icons.arrow_drop_down),
    ],
  ),
  child: HomeContent(),
);
```

## 적용된 화면 목록

| 화면 | 파일 | 주요 설정 |
|------|------|----------|
| 가계부 목록 | `account_book_list_screen.dart` | 기본 |
| 가계부 상세 | `account_book_detail_screen.dart` | `actions`, `bottomNavigationBar` |
| 가계부 생성 | `account_book_create_screen.dart` | `canPop`, `onPopInvokedWithResult` |
| 가계부 수정 | `account_book_edit_screen.dart` | `canPop`, `onPopInvokedWithResult` |
| 통계 | `statistics_screen.dart` | `automaticallyImplyLeading: false` |
| 자산 | `asset_screen.dart` | `automaticallyImplyLeading: false` |
| 설정 | `settings_screen.dart` | `automaticallyImplyLeading: false` |
| 커플 연동 | `couple_screen.dart` | `centerTitle`, `leading` |
| 파트너 초대 | `couple_invite_screen.dart` | `centerTitle`, `leading` |
| 코드 입력 | `couple_join_screen.dart` | `centerTitle`, `leading` |
| 예산 설정 | `budget_settings_screen.dart` | `backgroundColor`, `actions` |
| 수입 등록 | `add_income_screen.dart` | `canPop: false`, `centerTitle` |
| 지출 등록 | `add_expense_screen.dart` | `canPop: false`, `centerTitle` |

## 미적용 화면

다음 화면들은 특수한 구조로 인해 `DefaultLayout`을 적용하지 않았습니다:

- **HomeScreen**: 복잡한 커스텀 AppBar (드롭다운, 알림 아이콘 등)
- **인증 화면들**: 별도의 디자인 시스템 사용
- **온보딩/스플래시**: AppBar 없는 전체화면 레이아웃

## AppBar 동작 원리

`DefaultLayout`은 다음 조건 중 하나라도 만족하면 `AppBar`를 렌더링합니다:
- `title`이 설정됨
- `titleWidget`이 설정됨
- `actions`이 설정됨
- `leading`이 설정됨

모든 조건이 `null`이면 `AppBar` 없이 `Scaffold`만 렌더링됩니다.

## PopScope 동작 원리

`DefaultLayout`은 다음 조건일 때만 `PopScope`로 래핑합니다:
- `canPop`이 `false`일 때
- `onPopInvokedWithResult`가 설정되었을 때

기본적으로는 `PopScope` 없이 순수 `Scaffold`만 반환하여 성능을 최적화합니다.

## 주의사항

1. **title vs titleWidget**: 둘 다 설정된 경우 `titleWidget`이 우선합니다.
2. **backgroundColor**: `Scaffold`와 `AppBar` 모두에 동일하게 적용됩니다.
3. **canPop: false**: 반드시 `leading`에 닫기 버튼을 제공해야 사용자가 화면을 벗어날 수 있습니다.
4. **automaticallyImplyLeading: false**: 메인 탭 화면에서 사용하여 불필요한 뒤로가기 버튼을 숨깁니다.
