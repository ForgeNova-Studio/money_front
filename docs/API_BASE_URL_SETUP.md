# API base URL 설정 (VSCode + dart-define)

이 프로젝트는 `lib/core/constants/api_constants.dart`에서
`String.fromEnvironment('API_BASE_URL')`를 사용한다. 실행/빌드 시
`--dart-define` 또는 `--dart-define-from-file`로 base URL을 주입하므로
환경마다 Dart 파일을 직접 수정할 필요가 없다.

## 현재 폴더 구조

워크스페이스를 상위 폴더(예: `ForgedNova_Studio`)로 열어 둔 상태:

```
<FORGEDNOVA_ROOT>/
  .vscode/
    launch.json
    env/
      device.json
      emulator.json
      prod.json
  money_front/
    lib/
      main.dart
```

`money_front`를 직접 워크스페이스로 열었다면 아래
"다른 워크스페이스로 열 때" 항목을 참고.

## VSCode 런 설정

런 설정은 `<WORKSPACE>/.vscode/launch.json`에 있으며,
`--dart-define-from-file`과 명시적인 `program` 경로를 포함한다:

- Device (dev)
- Emulator (local)
- Release (prod)

각 설정은 VSCode 내장 변수 `${workspaceFolder}`를 사용하므로
현재 워크스페이스 루트 기준으로 경로가 해석된다.

## 환경 파일 (수정 대상)

- `.vscode/env/device.json`
  - `API_BASE_URL`에 맥의 로컬 IP 설정 (예: `http://192.168.0.12:8080`)
- `.vscode/env/emulator.json`
  - Android 에뮬레이터: `http://10.0.2.2:8080`
  - iOS 시뮬레이터: `http://127.0.0.1:8080`
- `.vscode/env/prod.json`
  - 운영 base URL (현재 기본값: `http://158.179.166.233:80`)

## 사용 방법

VSCode에서 Run/Debug 선택:
- "Money • Device (dev)"
- "Money • Emulator (local)"
- "Money • Release (prod)"

앱은 선택한 env 파일에서 `API_BASE_URL`을 읽는다.

## Xcode Archive / TestFlight 주의사항

VSCode 런 설정은 Xcode Archive에 영향이 없다. Xcode에서 Archive하면
Dart define이 자동 주입되지 않는다.

현재 동작:
- Xcode에서 별도 define 없이 Archive하면 `ApiConstants.baseUrl`의
  `defaultValue`가 사용됨
- 기본값이 운영을 가리키므로 TestFlight는 운영으로 붙는다

운영을 명시적으로 고정하는 방법:
- `flutter build ipa --dart-define-from-file=<path>/prod.json`로 빌드 후 업로드
- 또는 Xcode Release 빌드 설정에 `DART_DEFINES` 추가

## 다른 워크스페이스로 열 때

VSCode에서 `money_front` 폴더를 직접 열면 `${workspaceFolder}`가
`money_front`를 가리키도록 경로를 조정해야 한다:

- `.vscode`를 `money_front` 안으로 이동하거나
- `launch.json`에서 `program: lib/main.dart`와
  `--dart-define-from-file=.vscode/env/<file>.json`로 수정

## 자주 나오는 에러

- "Did not find the file passed to --dart-define-from-file"
  - 경로는 워크스페이스 루트 기준이다. 상위 폴더를 열었다면
    `${workspaceFolder}/.vscode/env/<file>.json`를 사용

- "Set the 'program' value in your launch config"
  - 워크스페이스 루트가 상위 폴더일 때 발생한다. 아래처럼 설정:
    `program: ${workspaceFolder}/money_front/lib/main.dart`

## Git 관련

env 파일에 민감한 값이 들어간다면 `.vscode/env/`를 `.gitignore`에 추가하고
로컬에서만 관리하는 것을 권장한다.
