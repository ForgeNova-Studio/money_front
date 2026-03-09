import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';

part 'home_monthly_response_model.freezed.dart';
part 'home_monthly_response_model.g.dart';

/// 홈 화면 월간 조회 API의 개별 거래 내역 모델
///
/// 서버로부터 수신된 개별 수입/지출 내역을 담습니다.
/// [DailyTransactionSummaryModel] 내부에 리스트 형태로 포함됩니다.
///
/// 주요 속성:
/// - [id]: 거래 ID (UUID)
/// - [type]: 거래 타입 ("INCOME" / "EXPENSE")
/// - [amount]: 금액
/// - [title]: 제목 (사용자 입력 또는 카테고리/소스 명)
/// - [category]: 카테고리 코드
/// - [time]: 시간 문자열 ("HH:mm")
///
/// 메서드:
/// - [toEntity]: [TransactionEntity]로 변환 (날짜 정보는 부모 모델로부터 주입받음)
@freezed
sealed class HomeTransactionModel with _$HomeTransactionModel {
  const HomeTransactionModel._();

  const factory HomeTransactionModel({
    required String
        id, // UUID String (예: "123e4567-e89b-12d3-a456-426614174000")
    required String type, // "INCOME" or "EXPENSE"
    required int amount,
    required String
        title, // 사용자 입력 설명 (지출: merchant ?? category, 수입: description ?? source)
    required String category, // 카테고리 코드 (지출: category, 수입: source)
    String? memo, // 추가 메모 (지출: memo, 수입: null)
    required String time, // "14:30"
  }) = _HomeTransactionModel;

  factory HomeTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$HomeTransactionModelFromJson(json);

  TransactionEntity toEntity(DateTime date) {
    // time을 파싱하여 date와 합침
    DateTime dateTime;
    if (time.isEmpty || !time.contains(':')) {
      // time이 빈 문자열이거나 형식이 잘못된 경우 날짜만 사용
      dateTime = DateTime(date.year, date.month, date.day);
    } else {
      final timeParts = time.split(':');
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute =
          timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;
      dateTime = DateTime(date.year, date.month, date.day, hour, minute);
    }

    return TransactionEntity(
      id: id,
      amount: amount,
      date: dateTime,
      title: title,
      category: category,
      memo: memo,
      type: type == 'INCOME' ? TransactionType.income : TransactionType.expense,
      createdAt: dateTime,
    );
  }
}

/// 홈 화면 월간 조회 API의 일별 요약 모델
///
/// 특정 날짜의 수입/지출 합계와 거래 내역 리스트를 포함합니다.
///
/// 주요 속성:
/// - [date]: 날짜 문자열 ("yyyy-MM-dd")
/// - [totalIncome]: 일별 총 수입
/// - [totalExpense]: 일별 총 지출
/// - [transactions]: 해당 날짜의 거래 내역 리스트 ([HomeTransactionModel])
///
/// 메서드:
/// - [toEntity]: [DailyTransactionSummary] 엔티티로 변환
@freezed
sealed class DailyTransactionSummaryModel with _$DailyTransactionSummaryModel {
  const DailyTransactionSummaryModel._();

  const factory DailyTransactionSummaryModel({
    required String date, // "2025-12-24"
    required int totalIncome,
    required int totalExpense,
    required List<HomeTransactionModel> transactions,
  }) = _DailyTransactionSummaryModel;

  factory DailyTransactionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTransactionSummaryModelFromJson(json);

  DailyTransactionSummary toEntity() {
    final dateTime = DateTime.parse(date); // String -> DateTime 변환

    return DailyTransactionSummary(
      date: dateTime,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      transactions: transactions.map((t) => t.toEntity(dateTime)).toList(),
    );
  }
}
