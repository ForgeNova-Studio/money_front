# 환경 변수 관리 가이드 (.env)

이 프로젝트는 민감한 정보(API 키, 비밀 값 등)와 환경별 설정을 관리하기 위해 `.env` 파일을 사용합니다.  
`flutter_dotenv` 패키지를 통해 앱 실행 시 환경 변수를 로드하여 사용합니다.

## 1. `.env` 파일 설정

### 파일 생성
프로젝트 루트(`money_front/`)에 `.env` 파일을 생성합니다.  
**주의:** `.env` 파일은 `.gitignore`에 등록되어 있어 Git 저장소에 업로드되지 않습니다. 로컬 개발 환경에서만 안전하게 보관하세요.

### 값 추가하기
`KEY=VALUE` 형식으로 키와 값을 추가합니다. 문자열 값을 넣을 때 따옴표(`"`, `'`)는 필요하지 않습니다.

**예시 (`.env`):**
```env
# 카카오 네이티브 앱 키
KAKAO_NATIVE_APP_KEY=a770c13cac29a2b59c8320c87c28ee18

# OneSignal 앱 ID
ONESIGNAL_APP_ID=d4c0efab-ecfb-4bb5-a649-082b8a78957b

# 새로운 키 추가 예시
NEW_API_KEY=12345abcdef
SERVER_URL=https://api.example.com
```

---

## 2. Dart 코드에서 사용하기

`flutter_dotenv` 패키지를 import하고, `dotenv.env['키이름']`으로 값을 가져옵니다.  
반환 값은 `String?` (문자열 또는 null) 타입입니다.

### 사용 예시

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  // 1. 값 가져오기
  String? apiKey = dotenv.env['NEW_API_KEY']; 
  
  // 2. 사용하기
  if (apiKey != null) {
      print("API Key: $apiKey");
  } else {
      print("API Key가 설정되지 않았습니다.");
  }
}
```

---

## 3. 주의사항

1.  **앱 재실행 필수**  
    `.env` 파일은 앱 빌드/실행 시 Assets으로 로드됩니다.  
    파일 내용을 수정하거나 새로운 키를 추가한 경우, **Hot Restart가 아닌 앱을 완전히 종료 후 다시 실행(Full Restart)** 해야 변경 사항이 반영됩니다.

2.  **보안**  
    `.env` 파일에는 절대 외부에 유출되어서는 안 되는 비밀번호나 민감한 개인정보를 저장하지 마세요. 필요한 경우 암호화된 스토리지를 사용하는 것이 좋습니다.

3.  **팀원 공유**  
    협업 시에는 필요한 키의 목록만 적힌 `.env.example` 파일을 만들어 공유하고, 실제 값은 각자 로컬에서 채워 넣도록 하는 것이 관례입니다.
