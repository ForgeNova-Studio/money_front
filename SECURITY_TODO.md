# 🔒 회원가입 보안 강화 TODO

작성일: 2025-12-02
우선순위: 🔴 Critical (즉시 수정 필요)

---

## 📋 목차

1. [문제점 요약](#문제점-요약)
2. [백엔드 TODO](#백엔드-todo)
3. [프론트엔드 TODO](#프론트엔드-todo)
4. [테스트 TODO](#테스트-todo)
5. [배포 체크리스트](#배포-체크리스트)

---

## 🚨 문제점 요약

### 현재 보안 취약점

**문제**: 이메일 인증 없이 회원가입 API를 직접 호출 가능

```bash
# 공격 시나리오 (현재 가능함!)
curl -X POST http://172.20.10.3:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "victim@example.com",
    "password": "hacker123",
    "nickname": "해커"
  }'
# 결과: 이메일 인증 없이 회원가입 성공 😱
```

**원인**:
- 이메일 인증 완료 여부가 클라이언트(앱)에서만 관리됨
- 백엔드가 이메일 인증 완료를 검증할 방법이 없음
- `_isEmailVerified` 플래그는 UI 상태일 뿐, 서버는 모름

**영향**:
- 🔴 다른 사람의 이메일로 계정 생성 가능
- 🔴 스팸 계정 대량 생성 가능
- 🔴 이메일 인증 시스템 무용지물

---

## 🔧 백엔드 TODO

### Priority 1: verificationToken 시스템 구현

#### TODO 1-1: 인증번호 확인 API 수정

**파일**: `src/main/java/.../.../AuthController.java` (또는 해당 경로)

**현재 코드**:
```java
@PostMapping("/verify-signup-code")
public Map<String, Object> verifySignupCode(@RequestBody VerifyRequest request) {
    boolean isValid = emailService.verifyCode(request.getEmail(), request.getCode());
    return Map.of("success", isValid);
}
```

**수정 필요**:
```java
@PostMapping("/verify-signup-code")
public VerifyResponse verifySignupCode(@RequestBody VerifyRequest request) {
    // 1. 인증번호 확인
    boolean isValid = emailService.verifyCode(request.getEmail(), request.getCode());

    if (!isValid) {
        throw new ValidationException("인증번호가 일치하지 않습니다");
    }

    // 2. verificationToken 생성 (UUID 또는 랜덤 문자열)
    String verificationToken = UUID.randomUUID().toString();

    // 3. Redis에 저장 (10분 TTL)
    // Key: "verify_token:" + token
    // Value: email
    redisTemplate.opsForValue().set(
        "verify_token:" + verificationToken,
        request.getEmail(),
        10,
        TimeUnit.MINUTES
    );

    // 4. 토큰 반환
    return new VerifyResponse(true, verificationToken);
}
```

**Response DTO 추가**:
```java
public class VerifyResponse {
    private boolean success;
    private String verificationToken;  // 추가!

    // constructor, getters, setters
}
```

**체크리스트**:
- [ ] VerifyResponse DTO에 verificationToken 필드 추가
- [ ] UUID 또는 안전한 랜덤 문자열 생성
- [ ] Redis 또는 DB에 토큰 저장 (10분 TTL)
- [ ] 토큰과 이메일 매핑 저장
- [ ] Response에 토큰 포함하여 반환

---

#### TODO 1-2: 회원가입 API 수정

**파일**: `src/main/java/.../.../AuthController.java`

**현재 코드**:
```java
@PostMapping("/register")
public RegisterResponse register(@RequestBody RegisterRequest request) {
    // 이메일 중복 체크
    if (userRepository.existsByEmail(request.getEmail())) {
        throw new ValidationException("이미 가입된 이메일입니다");
    }

    // 회원가입 진행
    User user = userService.register(request);
    return createAuthResponse(user);
}
```

**수정 필요**:
```java
@PostMapping("/register")
public RegisterResponse register(@RequestBody RegisterRequest request) {
    // 1. verificationToken 검증
    if (request.getVerificationToken() == null || request.getVerificationToken().isEmpty()) {
        throw new UnauthorizedException("이메일 인증을 완료해주세요");
    }

    // 2. Redis에서 토큰으로 이메일 조회
    String verifiedEmail = redisTemplate.opsForValue().get(
        "verify_token:" + request.getVerificationToken()
    );

    // 3. 토큰이 유효한지 확인
    if (verifiedEmail == null) {
        throw new UnauthorizedException("인증 토큰이 만료되었거나 유효하지 않습니다");
    }

    // 4. 토큰의 이메일과 요청 이메일이 일치하는지 확인
    if (!verifiedEmail.equals(request.getEmail())) {
        throw new UnauthorizedException("이메일이 일치하지 않습니다");
    }

    // 5. 토큰 삭제 (일회용)
    redisTemplate.delete("verify_token:" + request.getVerificationToken());

    // 6. 이메일 중복 체크
    if (userRepository.existsByEmail(request.getEmail())) {
        throw new ValidationException("이미 가입된 이메일입니다");
    }

    // 7. 회원가입 진행
    User user = userService.register(request);
    return createAuthResponse(user);
}
```

**Request DTO 수정**:
```java
public class RegisterRequest {
    private String email;
    private String password;
    private String nickname;
    private String verificationToken;  // 추가!

    // constructor, getters, setters, validation
}
```

**체크리스트**:
- [ ] RegisterRequest DTO에 verificationToken 필드 추가
- [ ] verificationToken null 체크
- [ ] Redis에서 토큰으로 이메일 조회
- [ ] 토큰 유효성 검증 (만료 여부)
- [ ] 토큰의 이메일과 요청 이메일 일치 확인
- [ ] 검증 성공 시 토큰 삭제 (일회용 보장)
- [ ] 검증 실패 시 401 Unauthorized 반환

---

#### TODO 1-3: Redis 설정 (또는 DB 테이블)

**옵션 A: Redis 사용 (권장)**

```yaml
# application.yml
spring:
  redis:
    host: localhost
    port: 6379
    timeout: 2000ms
```

```java
// RedisConfig.java
@Configuration
public class RedisConfig {
    @Bean
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, String> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new StringRedisSerializer());
        return template;
    }
}
```

**옵션 B: DB 테이블 사용**

```sql
CREATE TABLE email_verification_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    token VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    INDEX idx_token (token),
    INDEX idx_expires_at (expires_at)
);

-- 만료된 토큰 자동 삭제 (스케줄러)
DELETE FROM email_verification_tokens
WHERE expires_at < NOW() OR used = TRUE;
```

**체크리스트**:
- [ ] Redis 또는 DB 중 선택
- [ ] Redis 사용 시: 의존성 추가, 설정 파일 작성
- [ ] DB 사용 시: 테이블 생성, Entity/Repository 작성
- [ ] TTL 설정 (10분)
- [ ] 만료된 토큰 자동 삭제 로직

---

### Priority 2: 추가 보안 강화

#### TODO 2-1: 인증번호 재전송 제한

```java
@PostMapping("/send-signup-code")
public void sendSignupCode(@RequestBody SendCodeRequest request) {
    String key = "send_code_limit:" + request.getEmail();

    // 1분 내 재전송 체크
    String lastSent = redisTemplate.opsForValue().get(key);
    if (lastSent != null) {
        throw new ValidationException("1분 후에 다시 시도해주세요");
    }

    // 인증번호 전송
    emailService.sendVerificationCode(request.getEmail());

    // Redis에 1분 TTL로 저장
    redisTemplate.opsForValue().set(key, "sent", 60, TimeUnit.SECONDS);
}
```

**체크리스트**:
- [ ] 이메일 또는 IP 기준 재전송 제한 (60초)
- [ ] Redis에 쿨다운 상태 저장
- [ ] 제한 시 에러 메시지 반환

---

#### TODO 2-2: API Rate Limiting

```java
// Spring Security + Bucket4j 예시
@Configuration
public class RateLimitConfig {
    @Bean
    public Bucket createRateLimiter() {
        // IP당 1시간에 5회 제한
        Bandwidth limit = Bandwidth.classic(5, Refill.intervally(5, Duration.ofHours(1)));
        return Bucket4j.builder().addLimit(limit).build();
    }
}
```

**체크리스트**:
- [ ] 회원가입 API에 Rate Limiting 적용
- [ ] IP 또는 디바이스 기준으로 제한
- [ ] 429 Too Many Requests 반환

---

#### TODO 2-3: HTTPS 설정

```yaml
# application.yml (프로덕션)
server:
  port: 443
  ssl:
    enabled: true
    key-store: classpath:keystore.p12
    key-store-password: ${SSL_PASSWORD}
    key-store-type: PKCS12
```

**체크리스트**:
- [ ] SSL 인증서 발급 (Let's Encrypt 등)
- [ ] 프로덕션 환경에 HTTPS 적용
- [ ] HTTP → HTTPS 리다이렉트 설정
- [ ] 개발 환경에서도 가능하면 HTTPS 사용

---

## 📱 프론트엔드 TODO

### Priority 1: verificationToken 처리

#### TODO 3-1: VerifySignupCodeUseCase 수정

**파일**: `lib/features/auth/domain/usecases/verify_signup_code_usecase.dart`

**현재 코드**:
```dart
Future<bool> call({
  required String email,
  required String code,
}) async {
  _validateInput(email: email, code: code);
  return await _repository.verifySignupCode(email, code);
}
```

**수정 필요**:
```dart
Future<String?> call({  // bool → String? (토큰 반환)
  required String email,
  required String code,
}) async {
  _validateInput(email: email, code: code);
  return await _repository.verifySignupCode(email, code);
}
```

**체크리스트**:
- [ ] 반환 타입 변경: `bool` → `String?` (verificationToken)
- [ ] Repository 인터페이스 수정
- [ ] 주석 업데이트

---

#### TODO 3-2: AuthRepository 인터페이스 수정

**파일**: `lib/features/auth/domain/repositories/auth_repository.dart`

**현재 코드**:
```dart
Future<bool> verifySignupCode(String email, String code);
```

**수정 필요**:
```dart
Future<String?> verifySignupCode(String email, String code);
```

**파일**: `lib/features/auth/data/repositories/auth_repository_impl.dart`

**현재 코드**:
```dart
@override
Future<bool> verifySignupCode(String email, String code) async {
  return await remoteDataSource.verifySignupCode(email, code);
}
```

**수정 필요**:
```dart
@override
Future<String?> verifySignupCode(String email, String code) async {
  return await remoteDataSource.verifySignupCode(email, code);
}
```

**체크리스트**:
- [ ] 인터페이스 메서드 반환 타입 변경
- [ ] 구현체 메서드 반환 타입 변경
- [ ] 주석 업데이트

---

#### TODO 3-3: AuthRemoteDataSource 수정

**파일**: `lib/features/auth/data/datasources/remote/auth_remote_datasource.dart`

**현재 코드**:
```dart
Future<bool> verifySignupCode(String email, String code);
```

**수정 필요**:
```dart
Future<String?> verifySignupCode(String email, String code);
```

**파일**: `lib/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart`

**현재 코드**:
```dart
@override
Future<bool> verifySignupCode(String email, String code) async {
  try {
    final response = await dio.post(
      ApiConstants.verifySignupCode,
      data: {'email': email, 'code': code},
    );
    return response.data['success'] as bool? ?? false;
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }
}
```

**수정 필요**:
```dart
@override
Future<String?> verifySignupCode(String email, String code) async {
  try {
    final response = await dio.post(
      ApiConstants.verifySignupCode,
      data: {'email': email, 'code': code},
    );

    // success가 true이면 verificationToken 반환
    if (response.data['success'] == true) {
      return response.data['verificationToken'] as String?;
    }
    return null;
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }
}
```

**체크리스트**:
- [ ] 인터페이스 메서드 반환 타입 변경
- [ ] 구현체에서 verificationToken 추출
- [ ] success가 false이면 null 반환
- [ ] 에러 처리 유지

---

#### TODO 3-4: AuthViewModel 수정

**파일**: `lib/features/auth/presentation/viewmodels/auth_view_model.dart`

**현재 코드**:
```dart
Future<bool> verifySignupCode({
  required String email,
  required String code,
}) async {
  state = AuthState.loading();
  try {
    final useCase = ref.read(verifySignupCodeUseCaseProvider);
    final isVerified = await useCase(email: email, code: code);
    state = AuthState.initial();
    return isVerified;
  } catch (e) {
    // 에러 처리
  }
}
```

**수정 필요**:
```dart
Future<String?> verifySignupCode({
  required String email,
  required String code,
}) async {
  state = AuthState.loading();
  try {
    final useCase = ref.read(verifySignupCodeUseCaseProvider);
    final token = await useCase(email: email, code: code);
    state = AuthState.initial();
    return token;  // verificationToken 반환
  } catch (e) {
    // 에러 처리
  }
}
```

**체크리스트**:
- [ ] 반환 타입 변경: `bool` → `String?`
- [ ] verificationToken 저장 또는 반환
- [ ] 에러 처리 유지

---

#### TODO 3-5: RegisterScreen 수정

**파일**: `lib/features/auth/presentation/screens/register_screen.dart`

**추가 필요**:
```dart
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 기존 변수들...
  String? _verificationToken;  // 추가!

  Future<void> _handleVerifyCode() async {
    if (_verificationCodeController.text.isEmpty) {
      // 에러 처리
      return;
    }

    try {
      // verificationToken 받아서 저장
      final token = await ref
          .read(authViewModelProvider.notifier)
          .verifySignupCode(
            email: _emailController.text,
            code: _verificationCodeController.text,
          );

      if (mounted && token != null) {
        setState(() {
          _isEmailVerified = true;
          _verificationToken = token;  // 토큰 저장!
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
        );
      }
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> _handleSignUp() async {
    // 기존 검증...

    try {
      await ref.read(authViewModelProvider.notifier).register(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        nickname: _displayNameController.text,
        verificationToken: _verificationToken,  // 토큰 전달!
      );
    } catch (e) {
      // 에러 처리
    }
  }
}
```

**체크리스트**:
- [ ] `_verificationToken` 변수 추가
- [ ] `_handleVerifyCode()`에서 토큰 저장
- [ ] `_handleSignUp()`에서 토큰 전달
- [ ] 토큰이 null이면 회원가입 불가 처리

---

#### TODO 3-6: RegisterUseCase 수정

**파일**: `lib/features/auth/domain/usecases/register_usecase.dart`

**현재 코드**:
```dart
Future<AuthResult> call({
  required String email,
  required String password,
  required String confirmPassword,
  required String nickname,
}) async {
  _validateInput(
    email: email,
    password: password,
    confirmPassword: confirmPassword,
    nickname: nickname,
  );

  return await _repository.register(
    email: email,
    password: password,
    nickname: nickname,
  );
}
```

**수정 필요**:
```dart
Future<AuthResult> call({
  required String email,
  required String password,
  required String confirmPassword,
  required String nickname,
  String? verificationToken,  // 추가!
}) async {
  _validateInput(
    email: email,
    password: password,
    confirmPassword: confirmPassword,
    nickname: nickname,
  );

  // verificationToken 검증 (선택적 - 백엔드에서도 검증함)
  if (verificationToken == null || verificationToken.isEmpty) {
    throw ValidationException('이메일 인증을 완료해주세요');
  }

  return await _repository.register(
    email: email,
    password: password,
    nickname: nickname,
    verificationToken: verificationToken,  // 전달!
  );
}
```

**체크리스트**:
- [ ] verificationToken 파라미터 추가
- [ ] 토큰 null 검증 (선택적)
- [ ] Repository에 토큰 전달

---

#### TODO 3-7: AuthRepository 및 DataSource 수정

**파일**: `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
Future<AuthResult> register({
  required String email,
  required String password,
  required String nickname,
  String? verificationToken,  // 추가!
});
```

**파일**: `lib/features/auth/data/repositories/auth_repository_impl.dart`

```dart
@override
Future<AuthResult> register({
  required String email,
  required String password,
  required String nickname,
  String? verificationToken,  // 추가!
}) async {
  final response = await remoteDataSource.register(
    email: email,
    password: password,
    nickname: nickname,
    verificationToken: verificationToken,  // 전달!
  );
  // 나머지 로직...
}
```

**파일**: `lib/features/auth/data/datasources/remote/auth_remote_datasource.dart`

```dart
Future<RegisterResponseModel> register({
  required String email,
  required String password,
  required String nickname,
  String? verificationToken,  // 추가!
});
```

**파일**: `lib/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart`

```dart
@override
Future<RegisterResponseModel> register({
  required String email,
  required String password,
  required String nickname,
  String? verificationToken,  // 추가!
}) async {
  try {
    final response = await dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'nickname': nickname,
        'verificationToken': verificationToken,  // 전달!
      },
    );
    return RegisterResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }
}
```

**체크리스트**:
- [ ] 모든 레이어에 verificationToken 파라미터 추가
- [ ] API 요청 body에 verificationToken 포함
- [ ] 주석 및 문서 업데이트

---

### Priority 2: 인증번호 재전송 쿨다운

#### TODO 4-1: RegisterScreen에 타이머 추가

**파일**: `lib/features/auth/presentation/screens/register_screen.dart`

**추가 코드**:
```dart
import 'dart:async';

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 기존 변수들...
  int _resendCooldown = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    _resendTimer?.cancel();
    // 기존 dispose...
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCooldown = 60;  // 60초 쿨다운
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _handleSendVerificationCode() async {
    // 쿨다운 중이면 리턴
    if (_resendCooldown > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_resendCooldown초 후에 다시 시도해주세요.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // 기존 로직...
    try {
      await ref.read(authViewModelProvider.notifier)
          .sendSignupCode(_emailController.text);

      if (mounted) {
        setState(() {
          _isVerificationCodeSent = true;
        });
        _startResendTimer();  // 타이머 시작!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증번호가 전송되었습니다.')),
        );
      }
    } catch (e) {
      // 에러 처리
    }
  }

  // UI 수정
  ElevatedButton(
    onPressed: _isEmailVerified || _resendCooldown > 0
        ? null
        : _handleSendVerificationCode,
    child: Text(
      _isEmailVerified
          ? '인증완료'
          : _resendCooldown > 0
              ? '재전송 ($_resendCooldown초)'
              : '인증요청',
    ),
  ),
}
```

**체크리스트**:
- [ ] `_resendCooldown` 변수 추가
- [ ] `Timer` 생성 및 관리
- [ ] dispose에서 타이머 취소
- [ ] 60초 카운트다운 UI 표시
- [ ] 쿨다운 중 버튼 비활성화

---

## 🧪 테스트 TODO

### TODO 5-1: 백엔드 테스트

```java
@SpringBootTest
class AuthControllerTest {

    @Test
    void 이메일_인증_없이_회원가입_시도시_401_반환() {
        RegisterRequest request = RegisterRequest.builder()
            .email("test@example.com")
            .password("password1")
            .nickname("테스터")
            // verificationToken 없음!
            .build();

        assertThrows(UnauthorizedException.class, () -> {
            authController.register(request);
        });
    }

    @Test
    void 만료된_토큰으로_회원가입_시도시_401_반환() {
        // 토큰 생성 후 11분 대기 (TTL 10분)
        String expiredToken = createAndExpireToken("test@example.com");

        RegisterRequest request = RegisterRequest.builder()
            .email("test@example.com")
            .password("password1")
            .nickname("테스터")
            .verificationToken(expiredToken)
            .build();

        assertThrows(UnauthorizedException.class, () -> {
            authController.register(request);
        });
    }

    @Test
    void 다른_이메일의_토큰으로_회원가입_시도시_401_반환() {
        // user1@example.com의 토큰 생성
        String token = createToken("user1@example.com");

        // user2@example.com으로 회원가입 시도
        RegisterRequest request = RegisterRequest.builder()
            .email("user2@example.com")
            .password("password1")
            .nickname("테스터")
            .verificationToken(token)
            .build();

        assertThrows(UnauthorizedException.class, () -> {
            authController.register(request);
        });
    }

    @Test
    void 유효한_토큰으로_회원가입_성공() {
        // 정상적인 인증 플로우
        String email = "test@example.com";

        // 1. 인증번호 전송
        authController.sendSignupCode(new SendCodeRequest(email));

        // 2. 인증번호 확인 (토큰 발급)
        VerifyResponse verifyResponse = authController.verifySignupCode(
            new VerifyRequest(email, "123456")
        );
        assertNotNull(verifyResponse.getVerificationToken());

        // 3. 회원가입
        RegisterRequest request = RegisterRequest.builder()
            .email(email)
            .password("password1")
            .nickname("테스터")
            .verificationToken(verifyResponse.getVerificationToken())
            .build();

        RegisterResponse response = authController.register(request);
        assertNotNull(response.getAccessToken());
    }
}
```

**체크리스트**:
- [ ] 토큰 없이 회원가입 시도 테스트
- [ ] 만료된 토큰 테스트
- [ ] 다른 이메일의 토큰 사용 테스트
- [ ] 정상 플로우 통합 테스트
- [ ] 토큰 일회용 검증 테스트

---

### TODO 5-2: 프론트엔드 테스트

```dart
// test/features/auth/domain/usecases/verify_signup_code_usecase_test.dart
void main() {
  group('VerifySignupCodeUseCase', () {
    test('인증 성공 시 verificationToken을 반환해야 한다', () async {
      final mockRepository = MockAuthRepository();
      final useCase = VerifySignupCodeUseCase(mockRepository);

      when(mockRepository.verifySignupCode('test@example.com', '123456'))
          .thenAnswer((_) async => 'token_abc123');

      final token = await useCase(
        email: 'test@example.com',
        code: '123456',
      );

      expect(token, 'token_abc123');
    });

    test('인증 실패 시 null을 반환해야 한다', () async {
      final mockRepository = MockAuthRepository();
      final useCase = VerifySignupCodeUseCase(mockRepository);

      when(mockRepository.verifySignupCode('test@example.com', '999999'))
          .thenAnswer((_) async => null);

      final token = await useCase(
        email: 'test@example.com',
        code: '999999',
      );

      expect(token, null);
    });
  });
}
```

**체크리스트**:
- [ ] VerifySignupCodeUseCase 테스트 수정
- [ ] RegisterUseCase에 토큰 검증 테스트 추가
- [ ] 위젯 테스트 (RegisterScreen)
- [ ] 통합 테스트

---

## 📋 배포 체크리스트

### 백엔드 배포 전

- [ ] verificationToken 시스템 구현 완료
- [ ] Redis 또는 DB 설정 완료
- [ ] 인증번호 재전송 제한 구현
- [ ] API Rate Limiting 설정
- [ ] HTTPS 인증서 설정
- [ ] 프로덕션 환경 변수 설정
- [ ] 모든 테스트 통과
- [ ] Swagger 문서 업데이트

### 프론트엔드 배포 전

- [ ] verificationToken 처리 로직 구현
- [ ] 인증번호 재전송 쿨다운 추가
- [ ] baseUrl을 프로덕션 HTTPS URL로 변경
- [ ] 모든 테스트 통과
- [ ] 백엔드 API와 통합 테스트 완료

### 통합 테스트

- [ ] 전체 회원가입 플로우 E2E 테스트
- [ ] 토큰 없이 API 직접 호출 시 차단 확인
- [ ] 만료된 토큰 처리 확인
- [ ] 에러 시나리오 모두 테스트
- [ ] 재전송 쿨다운 동작 확인

---

## 📞 문의 및 지원

### 백엔드 팀
- verificationToken 시스템 구현
- Redis 설정
- API 수정

### 프론트엔드 팀
- verificationToken 처리
- UI/UX 개선

### 공통
- 통합 테스트
- 배포 및 모니터링

---

**작성일**: 2025-12-02
**우선순위**: 🔴 Critical
**예상 소요 시간**:
- 백엔드: 4-6시간
- 프론트엔드: 2-3시간
- 테스트: 2-3시간
- **총 8-12시간**

**마감일 권장**: 1주일 이내
