# 홈 시작 리팩터링 티켓

## HSR-001: 홈 첫 진입 시 월간 데이터 최초 조회 보장
- 우선순위: P0
- 문제: 장부 선택 변경 시에만 fetch가 발생하여 최초 조회가 누락될 수 있음.
- 작업:
  - build 시점에 장부가 이미 선택된 경우에도 최초 fetch 실행.
  - 최초 1회만 실행되도록 루프 방지.
  - accountBookId가 없으면 fetch하지 않도록 가드 유지.
- 완료 기준:
  - 유효한 장부가 있을 때 홈 첫 진입에서 월간 데이터가 항상 로드됨.
- 대상 파일:
  - money_front/lib/features/home/presentation/viewmodels/home_view_model.dart

## HSR-002: 장부 선택 보정 로직을 HomeScreen에서 분리
- 우선순위: P0
- 문제: UI initState가 accountBooksProvider 결과를 보고 선택 보정을 수행.
- 작업:
  - ensureSelectedAccountBookId 로직을 SelectedAccountBookViewModel 또는 전용 provider로 이동.
  - 장부 목록 로딩 이후 1회 실행되도록 조정.
  - HomeScreen의 listenManual 제거.
- 완료 기준:
  - HomeScreen에 장부 선택 보정 로직이 없음.
  - 화면 간 장부 선택이 일관됨.
- 대상 파일:
  - money_front/lib/features/home/presentation/screens/home_screen.dart
  - money_front/lib/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart
  - money_front/lib/features/account_book/presentation/providers/account_book_providers.dart

## HSR-003: 중복 초기화 제거
- 우선순위: P1
- 문제: main.dart와 SplashScreen이 모두 auth 초기화를 대기함.
- 작업:
  - 초기화 책임을 main 또는 SplashScreen 중 하나로 단일화.
  - 불필요한 redirect 제거.
- 완료 기준:
  - 초기화 흐름이 1번만 실행됨.
- 대상 파일:
  - money_front/lib/main.dart
  - money_front/lib/features/common/screens/splash_screen.dart
  - money_front/lib/router/router_provider.dart

## HSR-004: 월간 조회 결과의 레이스 방지
- 우선순위: P1
- 문제: 이전 요청이 늦게 도착하면 최신 상태를 덮을 수 있음.
- 작업:
  - request token/sequence id로 stale 결과 무시.
  - prefetch는 상태를 직접 덮지 않도록 보장.
- 완료 기준:
  - 장부/월을 빠르게 전환해도 이전 데이터가 표시되지 않음.
- 대상 파일:
  - money_front/lib/features/home/presentation/viewmodels/home_view_model.dart

## HSR-005: refresh indicator 정리
- 우선순위: P2
- 문제: homeRefreshIndicatorProvider가 UI에서 사용되지 않음.
- 작업:
  - provider 제거 또는 UI에 노출.
- 완료 기준:
  - 미사용 provider가 없음.
- 대상 파일:
  - money_front/lib/features/home/presentation/viewmodels/home_view_model.dart
  - money_front/lib/features/home/presentation/providers/home_providers.dart
  - money_front/lib/features/home/presentation/widgets/transaction_list_section.dart

## HSR-006: anonymous 캐시 키 방지
- 우선순위: P2
- 문제: 인증 상태 불확실 시 \"anonymous\"로 캐시가 저장됨.
- 작업:
  - 유효한 userId가 있을 때만 캐시 read/write 수행.
- 완료 기준:
  - placeholder userId로 캐시 키가 생성되지 않음.
- 대상 파일:
  - money_front/lib/features/home/presentation/viewmodels/home_view_model.dart
  - money_front/lib/features/home/data/repositories/home_repository_impl.dart
