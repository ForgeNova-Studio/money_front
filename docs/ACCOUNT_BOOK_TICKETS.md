# Account Book Implementation Tickets (Frontend)

## T1. API 모델/레포지토리/유스케이스 추가
- Scope
  - features/account_book/data: remote data source, model, repository impl
  - features/account_book/domain: entity, repository, usecases
- Tasks
  - AccountBook/MemberInfo 모델 생성 및 JSON 매핑
  - AccountBookRepository 인터페이스 정의
  - AccountBookRepositoryImpl 및 RemoteDataSource 구현
  - Create/Get/List/Members/AddMember/Deactivate 유스케이스 추가
- Acceptance
  - AccountBook API 호출 경로가 ApiConstants 사용
  - API 응답 모델 파싱 정상

## T2. 전역 선택 가계부 상태 및 저장
- Scope
  - selectedAccountBookProvider 추가
  - 로컬 저장(SharedPreferences/Hive) 연동
- Tasks
  - 최근 선택 가계부 ID 저장 및 로드
  - 앱 시작 시 기본 선택 로직 구현
- Acceptance
  - 앱 재시작 후 선택 가계부 유지
  - 선택 가계부가 비활성일 경우 자동 대체

## T3. 홈 AppBar 가계부 전환 모달
- Scope
  - HomeScreen AppBar UI 수정
  - AccountBookSwitcherSheet 추가
- Tasks
  - AppBar 타이틀을 탭 가능한 컴포넌트로 변경
  - BottomSheet에서 가계부 목록 노출
  - 가계부 선택 시 상태 업데이트 및 홈 리프레시
- Acceptance
  - 가계부 전환 시 홈 화면 컨텍스트 변경
  - 빈 목록일 경우 생성 유도 UI 표시

## T4. 가계부 생성 화면
- Scope
  - AccountBookCreateScreen 및 폼 UI
- Tasks
  - 필드: 이름, 유형, 설명, 기간, 인원수, 커플ID(선택)
  - 생성 성공 시 목록 갱신 및 자동 선택
- Acceptance
  - 폼 유효성 검사 통과 시 생성 성공
  - 생성 후 홈에서 새 가계부 표시

## T5. 가계부 상세/멤버 관리 화면
- Scope
  - AccountBookDetailScreen
- Tasks
  - 멤버 목록 표시 (role 포함)
  - 멤버 추가 (newMemberId 입력 UX)
  - OWNER만 삭제 버튼 노출
- Acceptance
  - 멤버 목록 조회 성공
  - 멤버 추가/삭제 성공 시 목록 업데이트

## T6. 홈 데이터 스코프 연결
- Scope
  - HomeViewModel -> accountBookId 전달 구조 설계
- Tasks
  - selectedAccountBookProvider 연동
  - home/monthly-data 스코프 파라미터 필요 여부 확인
  - (필요 시) API 확장 대응
- Acceptance
  - 홈 데이터가 선택된 가계부 컨텍스트 기준으로 요청됨

## T7. 품질 보강
- Scope
  - 로딩/에러 상태 UX 정리
- Tasks
  - API 에러 메시지 표준화
  - 비활성화/권한 없음 에러 핸들링
- Acceptance
  - 주요 실패 케이스에서 사용자 피드백 제공

