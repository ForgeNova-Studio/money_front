/// 가계부의 총 자산 및 통계 정보를 담는 도메인 엔티티
///
/// 애플리케이션 내에서 자산 현황과 관련된 핵심 비즈니스 로직 및 UI 표현에 사용되는 불변 객체입니다.
/// 특정 가계부 기준으로 현재 총 자산, 초기 잔액, 전체 및 특정 기간(이번 달 등)의 수입/지출 내역을 포함합니다.
///
/// **Key Features:**
/// *   가계부 식별 정보 및 자산 총액 제공
/// *   기간별(전체/월간) 수입 및 지출 내역 세분화
///
/// **Parameters:**
/// *   [accountBookId] - 통계가 조회된 가계부의 고유 식별자
/// *   [accountBookName] - 해당 가계부의 이름
/// *   [currentTotalAssets] - 현재 시점의 총 자산 금액 (초기 잔액 + 총 수입 - 총 지출)
/// *   [initialBalance] - 가계부 시작 시점에 설정된 초기 잔액 자산
/// *   [totalIncome] - 가계부 생성 이후 누적된 전체 수입 총액
/// *   [totalExpense] - 가계부 생성 이후 누적된 전체 지출 총액
/// *   [periodIncome] - 특정 기간(예: 이번 달) 동안의 수입 총액
/// *   [periodExpense] - 특정 기간(예: 이번 달) 동안의 지출 총액
/// *   [periodNetIncome] - 특정 기간(예: 이번 달) 동안의 순수익 (수입 - 지출)
///
/// **Usage Example:**
/// ```dart
/// final assetInfo = AssetEntity(
///   accountBookId: 'ab-123',
///   accountBookName: '내 가계부',
///   currentTotalAssets: 1500000,
///   initialBalance: 500000,
///   totalIncome: 2000000,
///   totalExpense: 1000000,
///   periodIncome: 1000000,
///   periodExpense: 500000,
///   periodNetIncome: 500000,
/// );
/// print(assetInfo.currentTotalAssets);
/// ```
class AssetEntity {
  final String accountBookId;
  final String accountBookName;
  final double currentTotalAssets;
  final double initialBalance;
  final double totalIncome;
  final double totalExpense;

  /// 이번 달 수입
  final double periodIncome;

  /// 이번 달 지출
  final double periodExpense;

  /// 이번 달 순수익
  final double periodNetIncome;

  const AssetEntity({
    required this.accountBookId,
    required this.accountBookName,
    required this.currentTotalAssets,
    required this.initialBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.periodIncome,
    required this.periodExpense,
    required this.periodNetIncome,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetEntity &&
          runtimeType == other.runtimeType &&
          accountBookId == other.accountBookId &&
          accountBookName == other.accountBookName &&
          currentTotalAssets == other.currentTotalAssets &&
          initialBalance == other.initialBalance &&
          totalIncome == other.totalIncome &&
          totalExpense == other.totalExpense &&
          periodIncome == other.periodIncome &&
          periodExpense == other.periodExpense &&
          periodNetIncome == other.periodNetIncome;

  @override
  int get hashCode =>
      accountBookId.hashCode ^
      accountBookName.hashCode ^
      currentTotalAssets.hashCode ^
      initialBalance.hashCode ^
      totalIncome.hashCode ^
      totalExpense.hashCode ^
      periodIncome.hashCode ^
      periodExpense.hashCode ^
      periodNetIncome.hashCode;
}
