# Income/Expense `copyWith` Null Clear 이슈 정리

## 요약
- 이슈: 수입/지출 수정 시, 사용자가 메모/설명 필드를 비워도(삭제해도) 기존 값이 유지되어 저장됨
- 영향 기능:
  - 수입 수정 (`description`)
  - 지출 수정 (`merchant`, `memo`, `paymentMethod` 등 nullable 필드)
- 원인: 엔티티 `copyWith`가 `??` 기반이라 "파라미터 생략"과 "명시적 null"을 구분하지 못함
- 조치: sentinel(`_unset`) 기반 `copyWith`로 변경하여 명시적 null 덮어쓰기 가능하게 수정

## 증상
1. 기존 메모/설명이 있는 수입/지출을 수정 화면에서 연다.
2. 메모/설명 입력값을 모두 지운다.
3. 저장을 누른다.
4. 기대 결과: 해당 필드가 `null`로 저장되어야 함
5. 실제 결과(수정 전): 기존 값이 그대로 유지됨

## 원인 상세
수정 전 `copyWith` 패턴:

```dart
description: description ?? this.description
```

위 방식은 아래 2가지 케이스를 동일하게 처리한다.
- 인자를 전달하지 않음 (`keep`)
- 인자를 `null`로 명시 전달 (`clear`)

결과적으로 `null`을 전달해도 기존값(`this.description`)이 유지되어 필드 삭제가 불가능했다.

## 영향 범위
- 도메인 엔티티
  - `moamoa_front/lib/features/income/domain/entities/income.dart`
  - `moamoa_front/lib/features/expense/domain/entities/expense.dart`
- 수정 흐름에서 `existingEntity.copyWith(...)`를 통해 update payload를 만드는 모든 경로

## 적용한 수정
sentinel 상수(`_unset`)를 도입해 파라미터 생략과 명시적 null을 분리:

```dart
Object? description = _unset
...
description: identical(description, _unset)
  ? this.description
  : description as String?
```

이제 동작은 다음과 같이 분리된다.
- 인자 생략: 기존값 유지
- `null` 명시 전달: `null`로 덮어쓰기

## 검증
- 정적 분석: `flutter analyze` 통과
- 단위 테스트 추가 및 통과:
  - `moamoa_front/test/features/income/domain/entities/income_copywith_test.dart`
  - `moamoa_front/test/features/expense/domain/entities/expense_copywith_test.dart`

## 공유 포인트
- nullable 필드가 있는 엔티티에서 `copyWith`를 수동 구현할 때 `??` 패턴을 그대로 쓰면 동일 문제가 반복될 수 있음
- 향후 신규 엔티티/리팩토링 시에도 "생략 vs 명시적 null" 구분 규칙을 동일하게 적용 권장
