# Income Module Models - TODO

## ⚠️ 모델 구조 불일치 주의 (Refactoring Required)

현재 `Income` 모듈의 데이터 파싱 로직과 백엔드 API 응답 구조 사이에 불일치가 발견되었습니다. 추후 `Expense` 모듈의 구조를 참고하여 수정이 필요합니다.

### 1. 현재 문제점
*   **백엔드 응답 (`IncomeListResponse.java`)**: 
    ```json
    {
      "incomes": [...],
      "totalAmount": 10000,
      "count": 5
    }
    ```
    위와 같이 객체 형태로 응답하며 내부에 리스트와 메타데이터를 포함합니다.
*   **현재 프론트엔드 (`IncomeRemoteDataSourceImpl.dart`)**: 
    응답 본문(`response.data`)을 `List<dynamic>`으로 직접 캐스팅하여 사용 중입니다. 이로 인해 실제 API 호출 시 런타임 에러가 발생할 가능성이 높습니다.

### 2. 해결 방안 (TODO)
`features/expense` 모듈에 구현된 방식을 참고하여 아래 작업을 수행해야 합니다.

1.  **`IncomeListResponseModel` 생성**: `freezed`를 사용하여 백엔드 DTO와 일치하는 응답 모델을 작성합니다.
2.  **`IncomeRemoteDataSourceImpl` 수정**: `dio.get` 응답을 `IncomeListResponseModel.fromJson`을 통해 파싱하도록 변경합니다.
3.  **`IncomeRepositoryImpl` 및 `UseCase` 수정**: 변경된 모델 구조에 맞춰 엔티티 변환 로직을 업데이트합니다.

### 3. 참고 모델
*   `lib/features/expense/data/models/expense_list_response_model.dart`
*   `money_back/src/main/java/com/moneyflow/dto/response/IncomeListResponse.java`

---
**작성일**: 2025-12-23
**우선순위**: 중(Medium) - 실제 API 연동 시 즉시 수정 필요
