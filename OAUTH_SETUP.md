# OAuth 설정 가이드 (프론트엔드)

## ⚠️ 중요: 민감 정보 관리

이 프로젝트는 OAuth Client ID와 Secret을 사용합니다.
**절대 Git에 커밋하지 마세요!**

다음 파일들은 `.gitignore`에 추가되어 있습니다:
- `ios/Runner/Info.plist`
- `android/app/src/main/res/values/strings.xml`

대신 `.example` 파일을 참고하여 로컬에서 생성하세요.

---

## 🔧 iOS 설정

### 1. Info.plist 생성

```bash
cd ios/Runner
cp Info.plist.example Info.plist
```

### 2. 실제 값으로 교체

`Info.plist` 파일을 열고 다음 값들을 교체하세요:

#### Google OAuth
```xml
<key>GIDClientID</key>
<string>YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com</string>

<key>CFBundleURLSchemes</key>
<array>
    <string>YOUR_GOOGLE_REVERSED_CLIENT_ID</string>
</array>
```

**값 얻는 방법**:
1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 프로젝트 선택 → API 및 서비스 → 사용자 인증 정보
3. OAuth 2.0 클라이언트 ID 선택 (iOS)
4. 클라이언트 ID 복사
5. Reversed Client ID는 클라이언트 ID를 역순으로 (예: `com.googleusercontent.apps.123456-abcdef`)

#### Naver OAuth
```xml
<key>NidClientID</key>
<string>YOUR_NAVER_CLIENT_ID</string>
<key>NidClientSecret</key>
<string>YOUR_NAVER_CLIENT_SECRET</string>
```

**값 얻는 방법**:
1. [네이버 개발자 센터](https://developers.naver.com/) 접속
2. 애플리케이션 → 내 애플리케이션 등록
3. Client ID / Client Secret 확인

#### Kakao OAuth
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>kakao{NATIVE_APP_KEY}</string>
</array>
```

**값 얻는 방법**:
1. [Kakao Developers](https://developers.kakao.com/) 접속
2. 내 애플리케이션 → 앱 키
3. 네이티브 앱 키 복사 → `kakao` 접두사 붙이기

---

## 🤖 Android 설정

### 1. strings.xml 생성

```bash
cd android/app/src/main/res/values
cp strings.xml.example strings.xml
```

### 2. 실제 값으로 교체

`strings.xml` 파일을 열고 다음 값들을 교체하세요:

```xml
<string name="naver_client_id">YOUR_NAVER_CLIENT_ID</string>
<string name="naver_client_secret">YOUR_NAVER_CLIENT_SECRET</string>
```

**네이버 Client ID/Secret**은 위 iOS 설정에서와 동일한 값을 사용하세요.

---

## 🧪 테스트

설정이 완료되면 다음 명령어로 테스트하세요:

```bash
# iOS
flutter run -d "iPhone 15 Pro"

# Android
flutter run -d emulator-5554
```

로그인 화면에서 각 소셜 로그인 버튼이 정상 작동하는지 확인하세요.

---

## 📝 현재 설정된 값 (참고용)

### Google OAuth
- **Client ID**: `886590665036-4chomeefga43fmilrkdu90ajnhblc2po.apps.googleusercontent.com`
- **Reversed Client ID**: `com.googleusercontent.apps.886590665036-4chomeefga43fmilrkdu90ajnhblc2po`

### Naver OAuth
- **Client ID**: 네이버 개발자 센터에서 확인
- **Client Secret**: 네이버 개발자 센터에서 확인

### Kakao OAuth
- **Native App Key**: 카카오 개발자 콘솔에서 확인
- **URL Scheme**: `kakao{NATIVE_APP_KEY}`

---

## 🚨 문제 해결

### "Google Sign In failed"
- `Info.plist`의 `GIDClientID`가 올바른지 확인
- Google Cloud Console에서 iOS 앱이 등록되었는지 확인
- Bundle ID가 일치하는지 확인

### "Naver login failed"
- `Info.plist` / `strings.xml`의 Client ID/Secret 확인
- 네이버 개발자 센터에서 앱이 등록되었는지 확인
- URL Scheme이 `naverlogin`인지 확인

### "Kakao login failed"
- `Info.plist`의 URL Scheme이 `kakao{NATIVE_APP_KEY}` 형식인지 확인
- 카카오 개발자 콘솔에서 플랫폼 설정 확인
- iOS Bundle ID / Android 패키지명이 등록되었는지 확인

---

## 🔐 보안 주의사항

### ⚠️ 절대 하지 말 것
- ❌ `Info.plist`를 Git에 커밋
- ❌ `strings.xml`를 Git에 커밋
- ❌ Client Secret을 코드에 하드코딩
- ❌ 스크린샷에 Client ID/Secret 노출

### ✅ 해야 할 것
- ✅ `.example` 파일만 커밋
- ✅ 팀원에게 실제 값은 별도 전달 (Slack, 1Password 등)
- ✅ 프로덕션과 개발 환경을 분리
- ✅ 정기적으로 Secret 재발급

---

## 📚 참고 자료

- [Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating)
- [Naver Login API](https://developers.naver.com/docs/login/api/)
- [Kakao Login](https://developers.kakao.com/docs/latest/ko/kakaologin/common)
