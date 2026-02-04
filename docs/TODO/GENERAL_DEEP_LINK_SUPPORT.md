# 일반 딥링크 지원 (General Deep Link Support)

## 현황 (Current Status)
현재 `DeepLinkService`는 `moamoa://import` 스킴만 처리하도록 하드코딩되어 있습니다.
따라서 SMS 자동 입력 외의 일반적인 앱 내 페이지 이동(예: `moamoa://settings`, `moamoa://assets`)은 동작하지 않습니다.

## 목표 (Goal)
`moamoa://` 스킴으로 들어오는 모든 딥링크를 처리하여, 해당 `path`와 `query parameters`에 맞는 앱 내 화면으로 이동할 수 있도록 지원합니다.

## 구현 상세 (Implementation Details)

### 1. DeepLinkService 수정
- `moamoa` 스킴인 경우 `host`가 `import`가 아니더라도 데이터를 `state`에 저장하거나, 별도의 `GeneralDeepLink` 상태로 관리해야 합니다.
- **AS-IS**:
  ```dart
  if (uri.scheme == 'moamoa' && uri.host == 'import') { ... }
  ```
- **TO-BE**:
  ```dart
  if (uri.scheme == 'moamoa') {
    if (uri.host == 'import') {
      // Existing logic
    } else {
      // General Deep Link Logic
      // state = GeneralDeepLinkData(uri: uri);
    }
  }
  ```

### 2. AppRouter / AppShell 수정
- `AppShell` 또는 `AppRouter`(`GoRouter`)에서 `DeepLinkService`의 일반 딥링크 상태를 감지하여 페이지 이동(`context.go` or `context.push`)을 처리해야 합니다.
- `GoRouter`의 `redirect` 로직에서 처리하는 것이 가장 깔끔할 수 있습니다.

### 3. iOS / Android 설정 확인
- 현재 `Info.plist`와 `AndroidManifest.xml`에 `moamoa` 스킴이 등록되어 있으므로, 네이티브 설정은 수정할 필요가 없을 것으로 예상됩니다.
- 단, Universal Link (https://...) 지원이 필요하다면 추가 설정이 필요합니다.

## 참고 사항
- 딥링크 처리 시 인증 상태(로그인 여부)를 반드시 체크해야 합니다.
- 로그아웃 상태에서 접근 시 로그인 후 해당 페이지로 리다이렉트되는 로직이 보장되어야 합니다.
