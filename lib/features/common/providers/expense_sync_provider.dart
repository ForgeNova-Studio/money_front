import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_sync_provider.g.dart';

/// expense_sync_provider.dart는 기능적으로 이벤트 버스입니다.
/// 지출/트랜잭션 변경을 공통 신호로 발행하고, Home/Statistics가 이 신호를 구독해 재조회하도록 연결합니다.
/// [지출 변경]
///  영향: 분석 화면
///  - 지출 등록/수정 expense_view_model.dart:140
///  - 홈에서 지출 삭제 home_view_model.dart:336
///  - SMS 일괄 저장(지출 생성) pending_expenses_view_model.dart:103
///  - OCR 일괄 저장(지출 생성) ocr_scan_view_model.dart:159
///
/// [트랜잭션 변경]
/// 영향: 홈 화면
///  - 지출 등록/수정 성공 expense_view_model.dart:134
///  - 수입 등록/수정 성공 income_view_model.dart:124
///  - SMS 일괄 지출 저장 성공 pending_expenses_view_model.dart:99
///  - OCR 일괄 지출 저장 성공 ocr_scan_view_model.dart:155

/// 지출 데이터 변경 신호 (분석 동기화용)
/// - 지출 변경을 월 단위로 전달하여 분석 화면의 캐시를 무효화 한다
class ExpenseSyncSignal {
  final DateTime month;
  final String? accountBookId;

  const ExpenseSyncSignal({
    required this.month,
    required this.accountBookId,
  });
}

/// 지출 변경 이벤트 발행 Notifier
@riverpod
class ExpenseSync extends _$ExpenseSync {
  @override
  ExpenseSyncSignal? build() => null;

  // 지출 변경 이벤트 발행
  // - 지출 변경을 월 단위로 추려서 state에 기록
  void emit({
    required DateTime date,
    String? accountBookId,
  }) {
    state = ExpenseSyncSignal(
      month: DateTime(date.year, date.month),
      accountBookId: accountBookId,
    );
  }
}

/// 트랜잭션 변경 신호 (홈 동기화용)
/// - 트랜잭션 변경을 날짜 단위로 전달하여 홈 화면의 캐시를 무효화 한다
class TransactionSyncSignal {
  final DateTime date;
  final String? accountBookId;

  const TransactionSyncSignal({
    required this.date,
    required this.accountBookId,
  });
}

/// 트랜잭션 변경 이벤트 발행 Notifier
@riverpod
class TransactionSync extends _$TransactionSync {
  @override
  TransactionSyncSignal? build() => null;

  // 트랜잭션 변경 이벤트 발행
  // - 트랜잭션 변경을 날짜 단위로 추려서 state에 기록
  void emit({
    required DateTime date,
    String? accountBookId,
  }) {
    state = TransactionSyncSignal(
      date: date,
      accountBookId: accountBookId,
    );
  }
}
