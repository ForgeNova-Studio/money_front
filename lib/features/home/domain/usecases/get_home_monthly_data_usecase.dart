import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/repositories/home_repository.dart';

/// 특정 월의 홈 화면 데이터를 조회하는 UseCase
///
/// 선택된 가계부의 월간 거래 내역을 일별 요약 형태로 반환합니다.
/// Repository 패턴을 사용하여 데이터 소스를 추상화합니다.
///
/// 반환값:
/// - `Map<String, DailyTransactionSummary>`: 날짜(yyyy-MM-dd)별 거래 요약
///
/// 파라미터:
/// - [yearMonth]: 조회할 연월 (날짜의 day는 무시됨)
/// - [userId]: 사용자 ID
/// - [accountBookId]: 가계부 ID
///
/// 사용 예시:
/// ```dart
/// final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
/// final data = await useCase(
///   yearMonth: DateTime(2024, 2),
///   userId: 'user123',
///   accountBookId: 'book456',
/// );
/// ```
class GetHomeMonthlyDataUseCase {
  final HomeRepository _repository;

  GetHomeMonthlyDataUseCase(this._repository);

  Future<Map<String, DailyTransactionSummary>> call({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  }) async {
    return await _repository.getMonthlyHomeData(
      yearMonth: yearMonth,
      userId: userId,
      accountBookId: accountBookId,
    );
  }
}
