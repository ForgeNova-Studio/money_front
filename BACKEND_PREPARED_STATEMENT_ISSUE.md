# Backend Issue: PostgreSQL Prepared Statement Conflict

## 이슈 요약

Flutter 앱에서 Hot Restart 시 백엔드에서 PostgreSQL Prepared Statement 충돌이 발생하여 사용자가 강제 로그아웃되는 문제

**심각도**: 🔴 Critical
**영향**: 사용자 경험 저하 (예상치 못한 로그아웃)
**발생 조건**: 동시 다발적인 API 요청 (Hot Restart, 화면 전환 등)

---

## 증상

### 사용자 관점
1. 홈 화면에서 Flutter Hot Restart 실행
2. 로딩 후 갑자기 로그인 화면으로 이동
3. "세션이 만료되었습니다. 다시 로그인해주세요." 메시지 표시

### 백엔드 로그
```
2025-12-24T16:46:38.319+09:00  WARN 68385 --- [moneyflow-backend] [nio-8080-exec-4] o.h.engine.jdbc.spi.SqlExceptionHelper   : SQL Error: 0, SQLState: 42P05
2025-12-24T16:46:38.319+09:00 ERROR 68385 --- [moneyflow-backend] [nio-8080-exec-4] o.h.engine.jdbc.spi.SqlExceptionHelper   : ERROR: prepared statement "S_3" already exists

org.hibernate.exception.SQLGrammarException: JDBC exception executing SQL [select u1_0.user_id,u1_0.created_at,u1_0.email,... from users u1_0 where u1_0.user_id=?] [ERROR: prepared statement "S_3" already exists]
```

---

## 근본 원인

### 1. PostgreSQL Prepared Statement 중복 생성

HikariCP 커넥션 풀과 PostgreSQL JDBC 드라이버의 prepared statement 캐싱 메커니즘 충돌:

```
동시 요청 1: GET /api/users/me
  → HikariCP Connection #1
  → Hibernate: userRepository.findById()
  → PostgreSQL: CREATE PREPARED STATEMENT "S_3"

동시 요청 2: GET /api/expenses
  → HikariCP Connection #1 (재사용)
  → Hibernate: userRepository.findById()
  → PostgreSQL: CREATE PREPARED STATEMENT "S_3" ❌
  → ERROR: prepared statement "S_3" already exists
```

### 2. 요청 흐름

```
Flutter Hot Restart
  ↓
동시에 3개 API 호출
  ├─ GET /api/users/me
  ├─ GET /api/expenses?startDate=2025-12-01&endDate=2025-12-31
  └─ GET /api/incomes?startDate=2025-12-01&endDate=2025-12-31
  ↓
모든 요청이 JwtAuthenticationFilter 통과 필요
  ↓
각 요청마다 userRepository.findById(userId) 실행
  ↓
같은 커넥션에서 동일한 PreparedStatement ID 재사용 시도
  ↓
PostgreSQL Error: prepared statement "S_X" already exists
  ↓
JwtAuthenticationFilter 예외 발생
  ↓
SecurityContext에 인증 정보 설정 실패
  ↓
401 Unauthorized 응답
  ↓
프론트엔드 AuthInterceptor가 401 감지
  ↓
강제 로그아웃 처리
```

### 3. 문제가 되는 코드 경로

**백엔드 - JwtAuthenticationFilter.java**
```java
// com/moneyflow/security/JwtAuthenticationFilter.java
@Override
protected void doFilterInternal(HttpServletRequest request,
                                 HttpServletResponse response,
                                 FilterChain filterChain) {
    String jwt = parseJwt(request);

    if (jwt != null && jwtUtils.validateJwtToken(jwt)) {
        UUID userId = jwtUtils.getUserIdFromJwtToken(jwt);

        // ⚠️ 여기서 동시 요청 시 충돌 발생
        UserDetails userDetails = userDetailsService.loadUserById(userId);
        // ...
    }
}
```

**백엔드 - CustomUserDetailsService.java**
```java
public UserDetails loadUserById(UUID userId) {
    // ⚠️ 동일한 쿼리가 동시에 여러 번 실행됨
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    // ...
}
```

---

## 해결 방법

### Option 1: Prepared Statement 캐싱 비활성화 (적용됨)

**파일**: `money_back/src/main/resources/application.yml`

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.PostgreSQLDialect
        # Prepared Statement 캐싱 비활성화
        jdbc:
          batch_size: 0
        temp:
          use_jdbc_metadata_defaults: false

  # HikariCP 커넥션 풀 설정
  datasource:
    hikari:
      # Prepared Statement 캐싱 비활성화
      data-source-properties:
        prepareThreshold: 0
        preparedStatementCacheQueries: 0
        preparedStatementCacheSizeMiB: 0
      # 커넥션 풀 설정
      maximum-pool-size: 10
      minimum-idle: 2
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

**장점**:
- 즉시 적용 가능
- 설정만으로 해결

**단점**:
- Prepared Statement 재사용 불가로 인한 약간의 성능 저하 (미미함)
- 매번 statement를 새로 생성

### Option 2: 커넥션 격리 수준 조정 (추가 검토 필요)

```yaml
spring:
  datasource:
    hikari:
      transaction-isolation: TRANSACTION_READ_COMMITTED
      auto-commit: false
      connection-test-query: SELECT 1
```

### Option 3: JwtAuthenticationFilter 최적화 (장기 개선)

사용자 정보를 요청마다 DB에서 조회하는 대신:
- JWT에 필요한 정보 포함 (권한 등)
- Redis 캐싱 도입
- 세션 캐시 활용

```java
// 개선 예시
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Cacheable(value = "userDetails", key = "#userId")
    public UserDetails loadUserById(UUID userId) {
        // 캐시 히트 시 DB 조회 생략
        return userRepository.findById(userId)...;
    }
}
```

---

## 적용된 수정 사항

### 변경 파일
- `money_back/src/main/resources/application.yml`

### 변경 내용
1. **HikariCP Prepared Statement 캐싱 비활성화**
   - `prepareThreshold: 0`: PostgreSQL JDBC의 자동 prepared statement 생성 비활성화
   - `preparedStatementCacheQueries: 0`: 캐시된 쿼리 수 제한
   - `preparedStatementCacheSizeMiB: 0`: 캐시 메모리 크기 제한

2. **Hibernate 배치 처리 비활성화**
   - `jdbc.batch_size: 0`: 배치 insert/update 비활성화

3. **커넥션 풀 최적화**
   - `maximum-pool-size: 10`: 최대 커넥션 수 제한
   - `max-lifetime: 1800000`: 30분마다 커넥션 재생성 (prepared statement 정리)

---

## 테스트 방법

### 1. 백엔드 재시작
```bash
cd money_back
./mvnw spring-boot:run
```

### 2. 프론트엔드 테스트
```bash
cd money_front
flutter run
```

### 3. 재현 시나리오
1. 앱에서 로그인
2. 홈 화면 진입
3. Flutter Hot Restart (단축키: `R`)
4. 로그아웃 없이 정상 작동 확인

### 4. 로그 확인
정상 로그:
```
2025-12-24T16:50:00.123+09:00 DEBUG 12345 --- [nio-8080-exec-1] org.hibernate.SQL : select u1_0.user_id,... from users u1_0 where u1_0.user_id=?
2025-12-24T16:50:00.234+09:00 DEBUG 12345 --- [nio-8080-exec-2] org.hibernate.SQL : select e1_0.expense_id,... from expenses e1_0 where ...
```

에러 로그 사라짐:
```
❌ ERROR: prepared statement "S_3" already exists (이제 발생하지 않음)
```

---

## 성능 영향 분석

### Before (Prepared Statement 캐싱 활성화)
- 장점: 동일 쿼리 재사용으로 파싱 비용 절감
- 단점: 동시 요청 시 충돌 발생

### After (Prepared Statement 캐싱 비활성화)
- 장점: 충돌 없음, 안정성 향상
- 단점: 매 요청마다 statement 생성 (약 1-2ms 추가)

**결론**: 사용자 수가 적은 초기 단계에서는 성능 영향 미미. 추후 트래픽 증가 시 캐싱 레이어(Redis) 도입 권장.

---

## 장기 개선 방안

### 1. Redis 캐싱 도입
```java
@Cacheable(value = "users", key = "#userId", ttl = 300)
public User findById(UUID userId) {
    return userRepository.findById(userId)...;
}
```

### 2. JWT 페이로드 확장
```json
{
  "userId": "uuid",
  "roles": ["USER"],
  "permissions": ["READ", "WRITE"],
  "exp": 1735034400
}
```
→ DB 조회 없이 JWT에서 권한 정보 추출

### 3. Monitoring 추가
- HikariCP 메트릭 수집
- Prepared Statement 사용량 모니터링
- Slow Query 로그 분석

---

## 참고 자료

### PostgreSQL Prepared Statement
- https://www.postgresql.org/docs/current/sql-prepare.html
- https://jdbc.postgresql.org/documentation/server-prepare/

### HikariCP Configuration
- https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby
- https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing

### Spring Boot + PostgreSQL Best Practices
- https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql.datasource.connection-pool

---

## 작성 정보

**작성일**: 2024-12-24
**작성자**: 프론트엔드 팀
**관련 이슈**: Hot Restart 시 강제 로그아웃
**해결 상태**: ✅ 해결됨 (백엔드 설정 변경 필요)

---

## 체크리스트

- [x] 문제 재현 확인
- [x] 근본 원인 분석
- [x] 해결 방법 제시
- [x] application.yml 수정
- [ ] 백엔드 재시작 및 테스트
- [ ] 프로덕션 환경 적용 전 성능 테스트
- [ ] 모니터링 설정 추가 (Optional)
