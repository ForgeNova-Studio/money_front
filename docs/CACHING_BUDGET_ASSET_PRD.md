# PRD: 캐싱 시스템 및 예산/자산 정보 갱신 개선

## 개요

### 배경
현재 앱의 캐싱 시스템 및 예산/자산 정보 갱신 로직에서 코드 리뷰를 통해 다수의 개선점이 발견되었습니다. 이 문서는 발견된 이슈들을 정리하고, 개선 작업의 범위와 우선순위를 정의합니다.

### 목표
1. 디버깅 효율성 향상
2. 다중 사용자 환경에서의 캐시 정합성 보장
3. 장기 사용 시 메모리 안정성 확보
4. 코드 가독성 및 유지보수성 개선

---

## 이슈 목록

### 🔴 Critical (즉시 수정 필요)

#### Issue 1: 에러 로깅 부재
- **위치**: `HomeViewModel._loadBudgetAndAsset`
- **현상**: `catch (_) {}`로 에러를 삼켜서 디버깅이 불가능
- **영향**: 프로덕션에서 문제 발생 시 원인 파악 불가
- **해결책**: `debugPrint` 또는 로깅 시스템을 통한 에러 기록

#### Issue 2: 중복 클래스 정의
- **위치**: 
  - `HomeLocalDataSource.BudgetCacheEntry`
  - `monthly_home_cache.CachedBudget`
- **현상**: 거의 동일한 캐시 엔트리 클래스가 두 곳에 정의됨
- **영향**: 코드 혼란, 유지보수 어려움
- **해결책**: 하나로 통합하거나 명확한 역할 구분

---

### 🟡 Medium (조기 수정 권장)

#### Issue 3: 메모리 캐시 크기 제한 없음
- **위치**: `HomeViewModel._budgetCache`
- **현상**: `Map<int, CachedBudget>`이 무한히 증가 가능
- **영향**: 사용자가 여러 달을 탐색할수록 메모리 사용량 증가
- **해결책**: LRU 캐시 또는 최대 6개월 제한 적용

#### Issue 4: 로컬 캐시에 userId 누락
- **위치**: `HomeRepositoryImpl.getCachedBudget/saveCachedBudget`
- **현상**: 캐시 키가 `budget:$accountBookId:$yearMonth`로 userId 미포함
- **영향**: 다중 사용자 환경에서 캐시 충돌 가능 (보안 이슈)
- **해결책**: 캐시 키에 userId 추가

#### Issue 5: 예산/자산 캐시 무효화 누락
- **위치**: `HomeViewModel.deleteTransaction`
- **현상**: 트랜잭션 삭제 시 월간 데이터는 무효화하지만 예산/자산 캐시는 무효화 안 함
- **영향**: 로컬 캐시에 오래된 데이터가 남아있을 수 있음
- **해결책**: `invalidateBudgetCache`, `invalidateAssetCache` 메서드 추가 및 호출

---

### 🟢 Low (개선 권장)

#### Issue 6: Hive 초기화 Race Condition
- **위치**: `HomeLocalDataSourceImpl._ensureInitialized`
- **현상**: 동시 요청 시 `Hive.openBox`가 여러 번 호출될 수 있음
- **영향**: 드물지만 앱 시작 시 크래시 가능
- **해결책**: `Completer` 패턴으로 초기화 동기화

#### Issue 7: 불필요한 중복 ref.watch
- **위치**: `HomeBudgetInfoCard`
- **현상**: `build()`와 `_buildAssetContent()`에서 같은 provider를 두 번 watch
- **영향**: 성능에 큰 영향 없으나 불필요한 코드
- **해결책**: 파라미터로 전달하거나 한 번만 watch

#### Issue 8: 메서드 이름 명확화
- **위치**: `HomeViewModel._loadBudgetAndAsset`
- **현상**: 메서드 이름이 역할을 명확히 표현하지 않음
- **해결책**: `_ensureBudgetAndAssetLoaded`로 이름 변경 권장

---

## 수정 계획

### Phase 1: Critical (Sprint 1)
| 태스크 | 예상 시간 | 담당 |
|--------|----------|------|
| 에러 로깅 추가 | 30분 | - |
| 중복 클래스 통합 | 1시간 | - |

### Phase 2: Medium (Sprint 1-2)
| 태스크 | 예상 시간 | 담당 |
|--------|----------|------|
| 메모리 캐시 크기 제한 | 1시간 | - |
| 로컬 캐시 키에 userId 추가 | 1시간 | - |
| 예산/자산 캐시 무효화 추가 | 30분 | - |

### Phase 3: Low (Backlog)
| 태스크 | 예상 시간 | 담당 |
|--------|----------|------|
| Hive 초기화 race condition 수정 | 30분 | - |
| 중복 ref.watch 제거 | 15분 | - |
| 메서드 이름 변경 | 15분 | - |

---

## 성공 지표

1. **에러 로깅**: 프로덕션에서 발생하는 캐시 관련 에러를 로그로 확인 가능
2. **캐시 정합성**: 다중 사용자 환경에서 캐시 충돌 0건
3. **메모리 안정성**: 장시간 사용 후에도 캐시 관련 메모리 사용량 일정 유지 (최대 6개월치)
4. **코드 품질**: 중복 클래스 제거, 명확한 메서드 네이밍

---

## 관련 파일

- `lib/features/home/presentation/viewmodels/home_view_model.dart`
- `lib/features/home/data/datasources/home_local_data_source.dart`
- `lib/features/home/data/repositories/home_repository_impl.dart`
- `lib/features/home/domain/entities/monthly_home_cache.dart`
- `lib/features/home/presentation/widgets/home_budget_info_card.dart`

---

## 참고 문서

- [코드 리뷰 상세 보고서](file:///Users/hanwool/.gemini/antigravity/brain/b1e945ed-fc2a-4755-9ea9-19a48050077a/code_review_caching_budget_asset.md)
