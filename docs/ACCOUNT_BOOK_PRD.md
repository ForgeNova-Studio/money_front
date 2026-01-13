# Account Book Multi-Book Support (Frontend PRD)

## 배경
- 유저가 여러 가계부를 만들고 전환하며 관리할 수 있어야 한다.
- 각 가계부는 두명 이상의 멤버가 함께 작성하고 데이터가 공유된다.
- 홈 화면 AppBar에서 가계부 전환이 주요 진입점이다.

## 목표
- 홈 AppBar에서 현재 가계부 표시 및 전환 모달 제공.
- 가계부 생성/목록/상세/멤버 조회/멤버 추가/비활성화 API 연동.
- 선택된 가계부 컨텍스트를 홈에 적용할 수 있는 구조 마련.

## 비목표
- 멤버 초대 링크/이메일 기반 초대 UX (API 미제공).
- 멤버 권한 변경/추방 (API 미제공).
- 가계부별 지출/수입/예산/통계 API 재설계 (백엔드 변경 필요).

## 사용자 스토리
- 유저로서 여러 가계부를 만들고 홈에서 쉽게 전환하고 싶다.
- 유저로서 특정 가계부에 멤버를 추가하고 멤버 목록을 확인하고 싶다.
- 유저로서 불필요한 가계부를 비활성화하고 싶다 (OWNER만).

## 범위 내 기능
- 가계부 목록 조회 및 선택
- 가계부 생성
- 가계부 상세/멤버 조회
- 멤버 추가 (newMemberId 기반, 임시 UX)
- 가계부 비활성화

## API 요약 (백엔드 확인)
- POST /api/account-books
- GET /api/account-books
- GET /api/account-books/{id}
- GET /api/account-books/{id}/members
- POST /api/account-books/{id}/members?newMemberId=UUID
- DELETE /api/account-books/{id}

## 데이터 모델 (Frontend)
- AccountBook
  - accountBookId: String
  - name: String
  - bookType: enum { COUPLE_LIVING, TRIP, PROJECT }
  - coupleId?: String
  - memberCount?: int
  - description?: String
  - startDate?: DateTime
  - endDate?: DateTime
  - isActive?: bool
  - createdAt?: DateTime
  - members?: List<MemberInfo>
- MemberInfo
  - userId: String
  - nickname: String
  - email: String
  - role: String (OWNER/MEMBER)
  - joinedAt: DateTime

## UX 플로우
1) 홈 진입
- AppBar 타이틀에 현재 선택된 가계부명 표시
- 초기 선택: 로컬 저장된 가계부 -> 없으면 첫 활성 가계부

2) 가계부 전환 모달
- AppBar 타이틀 탭 -> BottomSheet/Modal
- 가계부 리스트, 유형 라벨, 멤버 수
- 액션: "새 가계부 만들기", "가계부 설정" 진입

3) 가계부 생성
- 입력: 이름, 유형, 설명, 기간(선택), 인원수(선택), 커플ID(선택)
- 생성 성공 시 자동 선택 및 홈 리프레시

4) 멤버 관리
- 멤버 목록 화면에서 role 표시
- 멤버 추가는 newMemberId 입력 UX로 임시 제공

5) 가계부 비활성화
- OWNER만 가능
- 삭제 후 목록 리프레시, 선택 가계부 자동 전환

## 상태 관리
- features/account_book 모듈 신규 추가
- 선택 가계부 전역 상태: selectedAccountBookProvider
- 최근 선택 로컬 저장(SharedPreferences/Hive)

## 에러/엣지 케이스
- 목록 비어 있음 -> 첫 가계부 생성 유도
- 선택된 가계부 비활성화됨 -> 자동 다른 가계부로 전환
- 멤버 추가 실패(이미 멤버/권한 없음) -> 스낵바 처리

## 의존/오픈 이슈
- home/monthly-data에 accountBookId 파라미터 지원 여부 확인 필요
- 멤버 추가 UX 개선을 위한 사용자 검색/초대 API 필요 여부 확인

## 성공 지표
- 홈에서 가계부 전환 성공률
- 가계부 생성 완료율
- 멤버 추가 성공률

