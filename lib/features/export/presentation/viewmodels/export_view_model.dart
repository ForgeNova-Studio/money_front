import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus, XFile;

import 'package:moamoa/features/export/data/services/csv_export_service.dart';
import 'package:moamoa/features/home/data/models/home_monthly_response_model.dart';
import 'package:moamoa/features/home/presentation/providers/home_providers.dart';

part 'export_view_model.g.dart';

/// 내보내기 상태
class ExportState {
  final int startYear;
  final int startMonth;
  final int endYear;
  final int endMonth;
  final bool isExporting;
  final double progress; // 0.0 ~ 1.0
  final int completedMonths;
  final int totalMonths;
  final String? filePath;
  final String? errorMessage;
  final int transactionCount;

  const ExportState({
    required this.startYear,
    required this.startMonth,
    required this.endYear,
    required this.endMonth,
    this.isExporting = false,
    this.progress = 0,
    this.completedMonths = 0,
    this.totalMonths = 0,
    this.filePath,
    this.errorMessage,
    this.transactionCount = 0,
  });

  factory ExportState.initial() {
    final now = DateTime.now();
    return ExportState(
      startYear: now.year,
      startMonth: now.month,
      endYear: now.year,
      endMonth: now.month,
    );
  }

  ExportState copyWith({
    int? startYear,
    int? startMonth,
    int? endYear,
    int? endMonth,
    bool? isExporting,
    double? progress,
    int? completedMonths,
    int? totalMonths,
    String? filePath,
    String? errorMessage,
    int? transactionCount,
    bool clearFilePath = false,
    bool clearError = false,
  }) {
    return ExportState(
      startYear: startYear ?? this.startYear,
      startMonth: startMonth ?? this.startMonth,
      endYear: endYear ?? this.endYear,
      endMonth: endMonth ?? this.endMonth,
      isExporting: isExporting ?? this.isExporting,
      progress: progress ?? this.progress,
      completedMonths: completedMonths ?? this.completedMonths,
      totalMonths: totalMonths ?? this.totalMonths,
      filePath: clearFilePath ? null : (filePath ?? this.filePath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }

  /// 선택된 기간의 월 수
  int get monthCount {
    return (endYear - startYear) * 12 + (endMonth - startMonth) + 1;
  }

  /// 시작 DateTime
  DateTime get startDate => DateTime(startYear, startMonth);

  /// 종료 DateTime
  DateTime get endDate => DateTime(endYear, endMonth);
}

@riverpod
class ExportViewModel extends _$ExportViewModel {
  @override
  ExportState build() => ExportState.initial();

  /// 시작 월 변경
  void setStartDate(int year, int month) {
    state = state.copyWith(
      startYear: year,
      startMonth: month,
      clearFilePath: true,
      clearError: true,
    );
    // 시작이 종료보다 이후면 종료도 함께 변경
    if (DateTime(year, month).isAfter(state.endDate)) {
      state = state.copyWith(endYear: year, endMonth: month);
    }
  }

  /// 종료 월 변경
  void setEndDate(int year, int month) {
    state = state.copyWith(
      endYear: year,
      endMonth: month,
      clearFilePath: true,
      clearError: true,
    );
    // 종료가 시작보다 이전이면 시작도 함께 변경
    if (DateTime(year, month).isBefore(state.startDate)) {
      state = state.copyWith(startYear: year, startMonth: month);
    }
  }

  /// 내보내기 실행
  Future<void> export({
    required String accountBookId,
    required String accountBookName,
  }) async {
    final totalMonths = state.monthCount;
    if (totalMonths > 12) {
      state = state.copyWith(errorMessage: '최대 12개월까지 내보낼 수 있습니다.');
      return;
    }

    state = state.copyWith(
      isExporting: true,
      progress: 0,
      completedMonths: 0,
      totalMonths: totalMonths,
      clearFilePath: true,
      clearError: true,
    );

    try {
      final homeRemoteDS = ref.read(homeRemoteDataSourceProvider);
      final monthlyDataMap =
          <String, Map<String, DailyTransactionSummaryModel>>{};

      // 월별 데이터를 순차 호출 (진행률 표시를 위해)
      for (int i = 0; i < totalMonths; i++) {
        final date = DateTime(state.startYear, state.startMonth + i);
        final yearMonth =
            '${date.year}-${date.month.toString().padLeft(2, '0')}';

        try {
          final data = await homeRemoteDS.getMonthlyData(
            yearMonth: yearMonth,
            accountBookId: accountBookId,
          );
          monthlyDataMap[yearMonth] = data;
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[ExportViewModel] $yearMonth 데이터 조회 실패: $e');
          }
          // 개별 월 실패는 건너뜀
        }

        state = state.copyWith(
          completedMonths: i + 1,
          progress: (i + 1) / totalMonths,
        );
      }

      // 거래 건수 확인
      final count = CsvExportService.countTransactions(monthlyDataMap);
      if (count == 0) {
        state = state.copyWith(
          isExporting: false,
          errorMessage: '선택한 기간에 내보낼 거래 내역이 없습니다.',
        );
        return;
      }

      // CSV 파일 생성
      final service = CsvExportService();
      final filePath = await service.generate(
        monthlyDataMap: monthlyDataMap,
        accountBookName: accountBookName,
      );

      state = state.copyWith(
        isExporting: false,
        filePath: filePath,
        transactionCount: count,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ExportViewModel] 내보내기 실패: $e');
      }
      state = state.copyWith(
        isExporting: false,
        errorMessage: '내보내기 중 오류가 발생했습니다.',
      );
    }
  }

  /// 파일 공유
  Future<void> share() async {
    final path = state.filePath;
    if (path == null) return;

    await SharePlus.instance.share(
      ShareParams(files: [XFile(path)]),
    );
  }

  /// 상태 초기화
  void reset() {
    state = state.copyWith(
      clearFilePath: true,
      clearError: true,
      isExporting: false,
    );
  }
}
