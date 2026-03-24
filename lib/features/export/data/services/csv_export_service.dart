import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/core/constants/income_categories.dart';
import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';

/// CSV 파일 생성 서비스
///
/// 월별 거래 데이터를 CSV 파일로 생성합니다.
/// UTF-8 BOM 인코딩으로 한글 엑셀 호환을 보장합니다.
class CsvExportService {
  static final _numberFormat = NumberFormat('#,###');

  /// 카테고리 코드 → 한글 이름 매핑
  static String _categoryLabel(String code) {
    final expense = DefaultExpenseCategories.all
        .where((c) => c.id == code)
        .firstOrNull;
    if (expense != null) return expense.name;

    final income = DefaultIncomeCategories.all
        .where((c) => c.id == code)
        .firstOrNull;
    if (income != null) return income.name;

    return code;
  }

  /// 거래 내역 CSV 파일 생성
  ///
  /// [monthlyDataMap] — yearMonth(예: "2026-03") → 일별 거래 요약 맵
  /// [accountBookName] — 파일 이름에 포함할 가계부 이름
  ///
  /// 반환: 생성된 CSV 파일 경로
  Future<String> generate({
    required Map<String, Map<String, DailyTransactionSummaryModel>>
        monthlyDataMap,
    required String accountBookName,
  }) async {
    // 1. 모든 거래를 단일 리스트로 플래튼
    final rows = <List<String>>[];

    // 헤더
    rows.add(['날짜', '시간', '유형', '카테고리', '내용', '메모', '금액']);

    // 월별 → 일별 → 거래별 순회 (날짜 내림차순)
    final sortedMonths = monthlyDataMap.keys.toList()..sort((a, b) => b.compareTo(a));

    for (final yearMonth in sortedMonths) {
      final dailyMap = monthlyDataMap[yearMonth]!;
      final sortedDays = dailyMap.keys.toList()..sort((a, b) => b.compareTo(a));

      for (final dayKey in sortedDays) {
        final summary = dailyMap[dayKey]!;
        for (final tx in summary.transactions) {
          final isExpense = tx.type == 'EXPENSE';
          final amount = isExpense ? -tx.amount : tx.amount;

          rows.add([
            summary.date,
            tx.time,
            isExpense ? '지출' : '수입',
            _categoryLabel(tx.category),
            tx.title,
            tx.memo ?? '',
            _numberFormat.format(amount),
          ]);
        }
      }
    }

    // 2. CSV 문자열 생성
    const converter = ListToCsvConverter();
    final csvString = converter.convert(rows);

    // 3. UTF-8 BOM + CSV 저장
    final dir = await getTemporaryDirectory();
    final sanitized = accountBookName.replaceAll(RegExp(r'[/\\:*?"<>|]'), '_');
    final months = sortedMonths.isNotEmpty
        ? '${sortedMonths.last.replaceAll('-', '')}_${sortedMonths.first.replaceAll('-', '')}'
        : 'empty';
    final fileName = '모아모아_거래내역_${sanitized}_$months.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString('\uFEFF$csvString');

    return file.path;
  }

  /// 총 거래 건수 계산
  static int countTransactions(
      Map<String, Map<String, DailyTransactionSummaryModel>> monthlyDataMap) {
    int count = 0;
    for (final daily in monthlyDataMap.values) {
      for (final summary in daily.values) {
        count += summary.transactions.length;
      }
    }
    return count;
  }

  /// 월별 요약 데이터 생성
  static Map<String, ({int income, int expense})> buildMonthlySummary(
      Map<String, Map<String, DailyTransactionSummaryModel>> monthlyDataMap) {
    final result = <String, ({int income, int expense})>{};
    for (final entry in monthlyDataMap.entries) {
      int totalIncome = 0;
      int totalExpense = 0;
      for (final summary in entry.value.values) {
        totalIncome += summary.totalIncome;
        totalExpense += summary.totalExpense;
      }
      result[entry.key] = (income: totalIncome, expense: totalExpense);
    }
    return result;
  }
}
