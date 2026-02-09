import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// 하루 단위의 수입/지출 요약 정보를 담는 엔티티 클래스
///
/// 특정 날짜의 총 수입, 총 지출, 그리고 개별 거래 내역 리스트를 포함합니다.
/// 월간 캘린더나 일별 상세 내역 표시에 사용됩니다.
///
/// 주요 속성:
/// - [date]: 해당 날짜
/// - [totalIncome]: 총 수입 금액
/// - [totalExpense]: 총 지출 금액
/// - [transactions]: 해당 날짜의 거래 내역 리스트
///
/// 생성자:
/// - [DailyTransactionSummary]: 기본 생성자
/// - [DailyTransactionSummary.empty]: 거래 내역이 없는 빈 객체 생성 (초기화용)
class DailyTransactionSummary {
  final DateTime date;
  final int totalIncome;
  final int totalExpense;
  final List<TransactionEntity> transactions;

  const DailyTransactionSummary({
    required this.date,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  });

  factory DailyTransactionSummary.empty(DateTime date) {
    return DailyTransactionSummary(
      date: date,
      totalIncome: 0,
      totalExpense: 0,
      transactions: const [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTransactionSummary &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalIncome == other.totalIncome &&
          totalExpense == other.totalExpense &&
          _listEquals(transactions, other.transactions);

  @override
  int get hashCode =>
      date.hashCode ^
      totalIncome.hashCode ^
      totalExpense.hashCode ^
      Object.hashAll(transactions);
}
