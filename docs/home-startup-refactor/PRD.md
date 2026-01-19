# 홈 시작 리팩터링 PRD

## 개요
앱 시작부터 홈 화면까지의 흐름과 홈 데이터 로딩의 신뢰성을 개선합니다. 중복 초기화를 제거하고, 최초 월간 데이터 조회를 보장하며, 장부 선택 로직을 한 곳으로 통합합니다.

## 문제점
- 스플래시/초기화가 두 번 수행됨 (main 초기화 + SplashScreen).
- HomeViewModel 생성 전에 장부가 이미 선택되어 있으면 최초 월간 조회가 스킵될 수 있음.
- UI 레이어에서 장부 선택 보정(side-effect)을 수행함.
- 월간 조회 요청이 레이스를 일으켜 오래된 결과가 최신 상태를 덮을 수 있음.
- refresh indicator provider가 UI에 연결되지 않음.
- 인증 상태가 불안정할 때 캐시 키가 "anonymous"로 저장될 수 있음.

## 목표
- 유효한 장부가 있을 때 홈 첫 진입 시 월간 데이터가 항상 로드됨.
- 장부 선택/보정 로직의 단일 책임화.
- 중복 초기화/리다이렉트 제거.
- 최신 요청 결과만 상태에 반영.
- refresh indicator 사용 정리(연결 또는 제거).

## 비목표
- 홈 UI/캘린더 UX 재설계.
- 백엔드 API/스키마 변경.
- 캐시 전략 전면 개편.

## 범위
- 앱 시작 흐름(main, splash, router redirect).
- HomeViewModel 조회 시퀀싱 및 레이스 처리.
- SelectedAccountBookViewModel의 장부 선택 책임 강화.
- Home UI의 listen/side-effect 제거.

## 우선순위 작업
1) 인증 + 장부 선택 준비 시 최초 월간 데이터 조회 보장.
2) HomeScreen의 장부 선택 보정 로직 제거 및 ViewModel로 이동.
3) SplashScreen/메인 초기화 중복 제거.
4) 요청 시퀀스 관리(토큰/시퀀스 ID)로 stale 결과 방지.
5) refresh indicator 정리(삭제 또는 UI 연동).
6) "anonymous" 캐시 키 저장 방지.

## UX 메모
- 캐시가 있으면 즉시 표시.
- 캐시가 있는 경우 로딩 플리커 최소화.
- 새로고침 실패는 비차단 스낵바로 알림.

## 완료 기준
- 앱 시작 시 초기화 흐름이 단일화됨.
- 홈 첫 진입 시 월간 데이터가 항상 로드됨.
- 장부/월 빠른 전환에서도 오래된 데이터가 화면을 덮지 않음.
- HomeScreen initState에 장부 선택 보정 로직이 없음.
- "anonymous" 캐시 키로 저장되지 않음.

## 리스크 / 오픈 이슈
- 장부 목록 로딩이 HomeViewModel 이후에 완료되는 경우에도 최초 조회가 보장되어야 함.
- 초기화가 main에서 처리될 경우 SplashScreen 유지 여부 결정 필요.
